import 'package:booking_hotel_app/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
  final BookingData bookingData;

  const InvoiceScreen({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Hey ${bookingData.fullName},',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Booking ID', bookingData.bookingID),
                      _buildInfoRow('Booking Date', bookingData.startDate != null ? DateFormat('yyyy-MM-dd').format(bookingData.startDate!) : ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoHeader(context,'Client Information'),
                      _buildInfoRow('Name', bookingData.fullName),
                      _buildInfoRow('Address', bookingData.address),
                      _buildInfoRow('Email', bookingData.email),
                      _buildInfoRow('Phone', bookingData.phone),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoHeader(context,'Accommodation Information'),
                      _buildInfoRow('Hotel', bookingData.hotelName),
                      _buildInfoRow('Room Type', bookingData.roomType),
                      _buildInfoRow('Check-in Date', bookingData.startDate != null ? DateFormat('yyyy-MM-dd').format(bookingData.startDate!) : ''),
                      _buildInfoRow('Check-out Date', bookingData.endDate != null ? DateFormat('yyyy-MM-dd').format(bookingData.endDate!) : ''),
                      _buildInfoRow('Number of Adults', bookingData.numberOfAdults.toString()),
                      _buildInfoRow('Number of Children', bookingData.numberOfChildren.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoHeader(context,'Description'),
                      Text(
                        '${bookingData.hotelName} - ${bookingData.roomType} x ${bookingData.totalDays} days',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('\$${bookingData.pricePernight} USD', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('${bookingData.saved} USD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor )),
                          Text('\$${(bookingData.totalAmount).toString()} USD',
                              style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(vertical: 16),
              //   decoration: BoxDecoration(
              //     color: Colors.green,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: const Center(
              //     child: Text(
              //       'PAID',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoHeader(BuildContext context,String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

