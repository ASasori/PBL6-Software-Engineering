import 'dart:convert';

import 'package:booking_hotel_app/models/booking.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:developer';

import 'api_services.dart';

class BookingServices {
  final ApiService _apiService = ApiService();
  String? baseUrl;

  final String secretKey;
  final String publishableKey;

  BookingServices({
    required this.secretKey,
    required this.publishableKey,
  }) {
    baseUrl = _apiService.baseUrl;
  }

  Future<dynamic> createBooking(int hotelId,
      int roomId,
      String checkInDate,
      String checkOutDate,
      int adults,
      int children,
      String rt_slug,
      double totalAmount,
      String fullName,
      String email,
      String phone) async {
    try {
      final response = await _apiService.dio.post(
        '$baseUrl/api/bookings/create/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'hotel_id': hotelId,
          'room_id': roomId,
          'checkin': checkInDate,
          'checkout': checkOutDate,
          'adult': adults,
          'children': children,
          'room_type': rt_slug,
          'before_discount': totalAmount,
          'full_name': fullName,
          'email': email,
          'phone': phone,
        }),
      );
      if (response.statusCode == 201) {
        final data = response.data['booking_id'];
        return data;
      }
    } catch (e) {
      print('Error call api create booking: $e');
      throw 'Fail to create booking';
    }
  }

  Future<Map<String, dynamic>> checkCoupon(String bookingId, String code) async {
    try {
      final response = await _apiService.dio.post(
        '$baseUrl/api/checkout-api/$bookingId/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'code': code,
        }),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      print("Error call api get discount: $e");
      return {};
    }
  }
  Future<Map<String, dynamic>?> makeIntentForPayment(String amountToBeCharge, String currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": (int.parse(amountToBeCharge) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      log("Error in making intent for payment: $e");
      return null;
    }
  }
  Future<bool> paymentSheetInitialization(String amountToBeCharge, String currency, String bookingId, int cartItemId) async {
    try {
      Stripe.publishableKey = publishableKey;
      Stripe.instance.applySettings();

      // Map<String, dynamic>? intentPaymentData = await makeIntentForPayment(amountToBeCharge, currency);
      //
      // if (intentPaymentData == null) {
      //   throw Exception("Payment intent creation failed");
      // }
      //
      // String paymentIntentId = intentPaymentData['id'];

      final response  = await getSessionId(bookingId, cartItemId);
      String sessionId = response['sessionId'];
      String clientSecret = response['clientSecret'];
      String paymentIntentId = clientSecret.split('_secret_')[0];
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          merchantDisplayName: 'BookingApp Store',
          // paymentIntentClientSecret: intentPaymentData['client_secret'],
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.dark,
        ),
      );

      bool isPaymentSuccessful = await showPaymentSheet(paymentIntentId);

      if (isPaymentSuccessful) {
        bool checkPaymentSuccess = await paymentSuccess(bookingId, sessionId);
        return checkPaymentSuccess;
      } else {
        bool checkPaymentFailed = await paymentFailed(bookingId);
        return !checkPaymentFailed;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> showPaymentSheet(String paymentIntentId) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      log("Payment Sheet presented successfully!");

      final paymentStatus = await checkPaymentIntentStatus(paymentIntentId);

      if (paymentStatus == "succeeded") {
        log("Payment completed successfully");
        return true;
      } else {
        log("Payment not completed. Status: $paymentStatus");
        return false;
      }
    } catch (e) {
      if (e is StripeException) {
        log("Stripe exception: ${e.error.localizedMessage}");
      } else {
        log("Error displaying payment sheet: $e");
      }
      return false;
    }
  }
  Future<String> checkPaymentIntentStatus(String paymentIntentId) async {
    final url = Uri.parse(
        "https://api.stripe.com/v1/payment_intents/$paymentIntentId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"];
    } else {
      log("Failed to fetch payment intent status: ${response.body}");
      throw Exception("Failed to fetch payment intent status");
    }
  }
  Future<Map<String, dynamic>> getSessionId(String bookingId, int cartItemId) async {
    try {
      Stripe.publishableKey = publishableKey;
      Stripe.instance.applySettings();

      var response = await _apiService.dio.post(
          '$baseUrl/api/checkout/$bookingId/',
          data: jsonEncode({"cart_item_id": cartItemId}),
          options: Options(
            contentType: 'application/json',
          )
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create checkout session");
      }

      final data = response.data;
      // if (!data.containsKey('sessionId')) {
      //   throw Exception("Key 'sessionId' not found in response data");
      // }
      // return data['sessionId'];
      return data;
    } catch (e) {
      print('Error call api session: $e');
      return {};
    }
  }
  Future<bool> paymentSuccess(String bookingId, String sessionId) async {
    try {
      final response = await _apiService.dio.post(
          '$baseUrl/api/payment-success/$bookingId/',
          data: jsonEncode({"sessionId": sessionId}),
          options: Options(
            contentType: 'application/json',
          )
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print ('error api paymentSuccess: $e');
      return false;
    }
  }
  Future<bool> paymentFailed(String bookingId) async {
    try {
      final response = await _apiService.dio.post(
          '$baseUrl/api/payment-failed/$bookingId/'
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print ('error api paymentSuccess: $e');
      return false;
    }
  }
  Future<List<BookingData>> fetchMyBookings () async{
    try {
      final response = await _apiService.dio.get(
        '$baseUrl/api/bookings/my-bookings/',
      );
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => BookingData.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetch my booking: $e");
      return [];
    }
  }
}

// comment first: chua xu li su kien
// Future<Map<String, dynamic>?> makeIntentForPayment(
//     String amountToBeCharge, String currency) async {
//   try {
//     Map<String, dynamic> paymentInfo = {
//       "amount": (int.parse(amountToBeCharge) * 100).toString(),
//       "currency": currency,
//       "payment_method_types[]": "card",
//     };
//
//     var response = await http.post(
//       Uri.parse("https://api.stripe.com/v1/payment_intents"),
//       body: paymentInfo,
//       headers: {
//         "Authorization": "Bearer ${secretKey}",
//         "Content-Type": "application/x-www-form-urlencoded"
//       },
//     );
//
//     return jsonDecode(response.body);
//   } catch (e) {
//     log("Error in making intent for payment: $e");
//     return null;
//   }
// }
//
// Future<void> paymentSheetInitialization(
//     String amountToBeCharge, String currency) async {
//   try {
//     Stripe.publishableKey = publishableKey;
//     Stripe.instance.applySettings();
//
//     Map<String, dynamic>? intentPaymentData =
//     await makeIntentForPayment(amountToBeCharge, currency);
//
//     if (intentPaymentData == null) {
//       throw Exception("Payment intent creation failed");
//     }
//
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         allowsDelayedPaymentMethods: true,
//         merchantDisplayName: 'Flutter Stripe Store Demo',
//         paymentIntentClientSecret: intentPaymentData['client_secret'],
//         style: ThemeMode.dark,
//       ),
//     );
//     await showPaymentSheet();
//   } catch (e) {
//     log("Error during payment initialization: $e");
//   }
// }
//
// Future<void> showPaymentSheet() async {
//   try {
//     await Stripe.instance.presentPaymentSheet();
//   } catch (e) {
//     if (e is StripeException) {
//       log("Stripe exception: ${e.error.localizedMessage}");
//     } else {
//       log("Error displaying payment sheet: $e");
//     }
//   }
// }

// goi toi checkout
/*
Future<void> paymentSheetInitialization(String bookingId, int cartItemId) async {
  try {
    Stripe.publishableKey = publishableKey;
    Stripe.instance.applySettings();

    var response = await _apiService.dio.post(
        '$baseUrl/api/checkout/$bookingId/',
        data: jsonEncode({"cart_item_id": cartItemId}),
        options: Options(
          contentType: 'application/json',
        )
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create checkout session");
    }

    final responseData = response.data;
    if (!responseData.containsKey('sessionId')) {
      throw Exception("Key 'sessionId' not found in response data");
    }

    final clientSecret = responseData['sessionId'];
    print("Client Secret: $clientSecret");

    if (!clientSecret.startsWith("cs_")) {
      throw Exception("Invalid client secret format");
    }

    print("$clientSecret");
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        merchantDisplayName: 'Boooking App Stripe',
        paymentIntentClientSecret: clientSecret,
        style: ThemeMode.dark,
      ),
    );
    await showPaymentSheet();
  } catch (e) {
    log("Error during payment initialization: $e");
  }
}

Future<void> showPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();
  } catch (e) {
    if (e is StripeException) {
      log("Stripe exception: ${e.error.localizedMessage}");
    } else {
      log("Error displaying payment sheet: $e");
    }
  }
}
* */
