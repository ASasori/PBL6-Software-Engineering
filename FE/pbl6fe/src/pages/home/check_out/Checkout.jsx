import React, { useState, useEffect } from "react";
import { useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';
import axios from 'axios';
import { useAuth } from "../../auth/AuthContext";
import { Link } from "react-router-dom";
import { useRoomCount } from '../RoomCountContext/RoomCountContext';
import API_BASE_URL from '../../../config/apiConfig';

const SelectedRoom = () => {

    const [cart, setCart] = useState({});
    const [hotels, setHotels] = useState([]);
    const [roomType, setRoomType] = useState({});
    const [selectedRoom, setSelectedRoom] = useState(null);
    const [fullName, setFullName] = useState('');
    const [email, setEmail] = useState('');
    const [phoneNumber, setPhoneNumber] = useState('');
    const [showDetailHotel, setShowDetailHotel] = useState(false);
    const [listRoomBooking, setListRoomBooking] = useState([]);
    const [totalPrice, setTotalPrice] = useState(0);
    const [orinalPrice, setOrinalPrice] = useState('');

    // const [showDetailHotels, setShowDetailHotels] = useState({});

    const { setRoomCount } = useRoomCount();
    const { token } = useAuth();

    const baseURL = API_BASE_URL;


    const fetchCart = async() => {
        const URL = `${baseURL}/api/view_cart`;
        try {
            const response = await axios.get(URL,{
                headers: {
                    'Authorization' : `Bearer ${token}`
                }
            });
            console.log(response.data);
            setRoomCount(response.data.total_items_in_cart);
            setHotels(response.data.hotels);
            console.log(response.data.hotels);
            const formattedData = response.data.hotels.flatMap(hotel =>
                hotel.rooms.map(room => {
                    const checkInDate = new Date(room.check_in_date);
                    const checkOutDate = new Date(room.check_out_date);
                    const totalDays = (checkOutDate - checkInDate) / (1000 * 60 * 60 * 24);
                    const beforeDiscount = room.price * totalDays;
                    setTotalPrice(prevTotal => prevTotal + Number(beforeDiscount));
                
                    return {
                        hotel_id: hotel.hotel_id,
                        hotel_name: hotel.hotel_name,
                        hotel_slug: hotel.hotel_slug[0], //
                        room_id: room.room_id,
                        room_number: room.room_number,
                        price: room.price,
                        bed: room.bed,
                        room_type: room.room_type,
                        slug_room_type: room.slug_room_type,
                        item_cart_id: room.item_cart_id,
                        check_in_date: room.check_in_date,
                        check_out_date: room.check_out_date,
                        before_discount: beforeDiscount
                    }
                })
            );
            setListRoomBooking(formattedData);
            console.log(formattedData);
        }
        catch (error) {
            console.error(error);
        }
    }

    const deleteCartItem = async (id) => {
        const URL = `${baseURL}/api/delete_cart_item`;
        const data = {
            item_cart_id: id
        }
        try {
            const response = await axios.post(URL, data, {
                headers: {
                    'Authorization' : `Bearer ${token}`
                }
            });
            fetchCart(); 
        }
        catch (error) {
            console.error(error);
        }
    }

    const fetchTypeRoom = async(slugHotel, slugRoomtype) => {
        const URL = `${baseURL}/api/hotels/${slugHotel}/room-types/${slugRoomtype}/rooms/`;
        try {
            const respoonse = await axios.get(URL, {
                headers: {
                    'Authorization' : `Bearer ${token}`
                }
            });
            console.log('in roomtype - ',respoonse.data.roomtype)
            setSelectedRoom(respoonse.data.roomtype);
        }
        catch (error) {
            console.error(error);
        }

    }

    const createBooking = async(fullname, email, phone) => {
        const URL = `${baseURL}/api/bookings/create/`;
        for(const room of listRoomBooking) {
            const data = {
                hotel_id: room.hotel_id,
                room_id: room.room_id,
                checkin: room.check_in_date,
                checkout: room.check_out_date,
                adult: 2,
                children: 2,
                room_type: room.slug_room_type,
                before_discount: room.before_discount,
                full_name: fullname,
                email: email,
                phone: phone
            };
            try {
                const response = await axios.post(URL, data, {
                    headers: {
                        'Authorization' : `Bearer  ${token}`
                    }
                });
                console.log(`Booking created for room ${room.room_number}:`, response.data);
            }
            catch (error) {
                console.error(`Error creating booking for room ${room.room_number}:`, error);
            }
        }
    }

    useEffect(() => {
        fetchCart();
    },[]);

    const handleDeleteCartItem = (idItemCart) => {
        console.log(idItemCart);
        deleteCartItem(idItemCart);
    }

    const handleRoomClick = (slugHotel, slugRoomtype) => {
        fetchTypeRoom(slugHotel, slugRoomtype);
    };

    const handleCloseModal = () => {
        setSelectedRoom(null);
    };

    const handleOutsideClick = (e) => {
        if (e.target.className === 'modal') {
            handleCloseModal();
        }
    };

    const handleFullNameBilling = (e) => {
        setFullName(e.target.value);
    }

    const handleEmailBilling = (e) => {
        setEmail(e.target.value);
    }

    const handlePhoneNumberBilling = (e) => {
        setPhoneNumber(e.target.value);
    }

    const handlePrintIn4 = () => {
        if((fullName === "") || (email === "") || (phoneNumber === "")){
            Swal.fire({
                icon: 'error',
                title: 'Nhập thiếu thông tin!',
                text: 'Vui lòng nhập đầy đủ các thông tin cần để kiểm tra phòng trống',
                showConfirmButton: false,
                timer: 2000
            })
        }
        else {
            createBooking(fullName, email, phoneNumber)
            console.log(fullName, email, phoneNumber);
            console.log("totalPrice:",totalPrice);
            setOrinalPrice(totalPrice);
        }
    }

    // const toggleShowDetail = (hotelId) => {
    //     setShowDetailHotels(prevState => ({
    //         ...prevState,
    //         [hotelId]: !prevState[hotelId] 
    //     }));
    // };

    return (
        <>
            <div id="main_wrapper" class="selection-list">
                <div id="titlebar" class="gradient">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-12 padding-top-60">
                            <h2>Check out Room</h2>
                            <nav id="breadcrumbs">
                                <ul>
                                    <li><a>Home</a></li>
                                    <li><a>Hotel</a></li>
                                    <li><a>Rooms</a></li>
                                    <li>Check out rooms</li>
                                </ul>
                            </nav>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container margin-bottom-75">
                    <div class="row">
                        <div class="col-lg-8 col-md-8 utf_listing_payment_section">
                            <form class="utf_booking_listing_section_form margin-bottom-40" method="POST">
                                <h3><i class="fas fa-user"></i> Billing Information</h3>
                                <div class="row">
                                    <div class="col-md-12">
                                        <label>Full Name</label>
                                        <input name="full_name" type="text" value={fullName} onChange={(e) => handleFullNameBilling(e)} placeholder="Full Name..."/>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="medium-icons">
                                            <label>E-Mail</label>
                                            <input name="email" type="text" value={email} onChange={(e) => handleEmailBilling(e)} placeholder="Email..."/>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="medium-icons">
                                            <label>Phone Number</label>
                                            <input name="phone" type="text" value={phoneNumber} onChange={(e) => handlePhoneNumberBilling(e)} placeholder="Phone Number..."/>
                                        </div>
                                    </div>
                                    {/* <div class="col-lg-12">
                                        <button type="submit" class="button utf_booking_confirmation_button margin-top-20 margin-bottom-10">Continue to checkout <i class="fas fa-right-arrow"></i></button> 		
                                    </div> */}
                                </div>
                            </form>
                                {hotels.map(hotel => (
                                    <li key={hotel.id}>
                                        <div class="utf_booking_listing_section_form margin-bottom-40">
                                            <Link to={`/detailhotel/${hotel.hotel_slug}`}>
                                                <div>
                                                    <h3>
                                                        <i class="fas fa-bed"></i>
                                                        {hotel.hotel_name}
                                                        {(() => {
                                                            const totalPrice = hotel.rooms.reduce((accumulator, room) => {
                                                                const checkInDate = new Date(room.check_in_date);
                                                                const checkOutDate = new Date(room.check_out_date);
                                                                const timeDifference = checkOutDate - checkInDate;
                                                                const dayDifference = timeDifference / (1000 * 3600 * 24); // Chuyển đổi từ milliseconds sang ngày
                                                                return accumulator + (room.price * (dayDifference > 0 ? dayDifference : 0)); // Chỉ cộng nếu dayDifference hợp lệ
                                                            }, 0);

                                                            return <div class="utf_listing_section" >
                                                            <div class="utf_pricing_list_section" >
                                                                <ul>
                                                                    <li style={{ backgroundColor: '#FDFDFD' }}>
                                                                        <h5>Total:</h5>
                                                                        <span className="">{totalPrice} VNĐ</span>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                        })()}
                                                    </h3>
                                                </div>
                                            </Link>
                                            {/* {showDetailHotels[hotel.id] && ( */}
                                            {showDetailHotel && (
                                                <div class="utf_listing_section">
                                                <div class="utf_pricing_list_section">
                                                    <ul>
                                                        
                                                        {hotel.rooms.map(room => (
                                                            <>
                                                                <li key={room.id}>
                                                                    <h5>Room Type: {room.room_type} <small><a style={{ cursor: 'pointer' }} class="delete-item" data-item="{{ id }}"><i onClick={() => handleDeleteCartItem(room.item_cart_id)}  class="fas fa-trash" style={{color: "red"}}></i></a></small> </h5>
                                                                    <h5>Room Type: {room.room_type} <small><a style={{ cursor: 'pointer' }} class="delete-item" data-item="{{ id }}"><i onClick={() => handleDeleteCartItem(room.item_cart_id)}  class="fas fa-trash" style={{color: "red"}}></i></a></small> </h5>
                                                                    <h5>Room Number: {room.room_number}<small><a style={{ cursor: 'pointer' }} class="delete-item" data-item="{{ id }}"></a></small> </h5>
                                                                    <h5>Check-in Date: {room.check_in_date}<small><a style={{ cursor: 'pointer' }} class="delete-item" data-item="{{ id }}"></a></small> </h5>
                                                                    <h5>Check-in Date: {room.check_out_date}<small><a style={{ cursor: 'pointer' }} class="delete-item" data-item="{{ id }}"></a></small> </h5>
                                                                    <p 
                                                                        onClick={() => handleRoomClick(hotel.hotel_slug, room.slug_room_type)} 
                                                                        style={{ 
                                                                            cursor: 'pointer', 
                                                                            textDecoration: 'underline', 
                                                                            // color: 'red'  
                                                                        }}
                                                                    >
                                                                        <strong>View detail...</strong>
                                                                    </p>
                                                                    <span> {room.price} VNĐ </span>
                                                                </li>
                                                            </>
                                                        ))}
                                                    </ul>
                                                </div>
                                            </div>
                                            )}
                                            <a
                                            href="#"
                                            class="show-more-button"
                                            
                                            onClick={(e) => {
                                                e.preventDefault(); 
                                                setShowDetailHotel(!showDetailHotel); 
                                            }}
                                            >
                                                {showDetailHotel ? "Hidden detail list room" : "Show detail list room"}
                                                <i className={showDetailHotel ? "fa fa-angle-double-up" : "fa fa-angle-double-down"}></i>
                                            </a>
                                            {/* <a
                                                href="#"
                                                className="show-more-button"
                                                onClick={(e) => {
                                                    e.preventDefault(); 
                                                    toggleShowDetail(hotel.id); // Gọi hàm để chuyển đổi trạng thái cho khách sạn cụ thể
                                                }}
                                            >
                                                {showDetailHotels[hotel.id] ? "Hidden detail list room" : "Show detail list room"}
                                                <i className={showDetailHotels[hotel.id] ? "fa fa-angle-double-up" : "fa fa-angle-double-down"}></i>
                                            </a> */}
                                        </div>
                                    </li>
                                ))}

                            {selectedRoom && (
                                <div className="modal" onClick={handleOutsideClick} style={modalStyles}>
                                    <div className="modal-content" style={modalContentStyles}>
                                        <span className="close" onClick={handleCloseModal} style={closeButtonStyles}>&times;</span>
                                        <h2>{selectedRoom.type}</h2>
                                        <img 
                                            src={`${baseURL}${selectedRoom.image}`} 
                                            alt={selectedRoom.type} 
                                            style={{ 
                                                maxWidth: '100%',  
                                                maxHeight: '400px', 
                                                objectFit: 'contain' 
                                            }}  
                                        />
                                        <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between', marginTop: '20px' }}>
                                            <div style={{ flex: '0 0 48%', marginBottom: '10px' }}>
                                                <p><strong>Price:</strong> {selectedRoom.price} VNĐ</p>
                                            </div>
                                            <div style={{ flex: '0 0 48%', marginBottom: '10px' }}>
                                                <p><strong>Description:</strong> {selectedRoom.description}</p>
                                            </div>
                                            <div style={{ flex: '0 0 48%', marginBottom: '10px' }}>
                                                <p><strong>Number of Beds:</strong> {selectedRoom.number_of_beds}</p>
                                            </div>
                                            <div style={{ flex: '0 0 48%', marginBottom: '10px' }}>
                                                <p><strong>Room Capacity:</strong> {selectedRoom.room_capacity} Persons</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            )}

                            <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '20px', marginBottom: '10px' }}>
                                <button 
                                    type="submit" 
                                    className="button utf_booking_confirmation_button"
                                    style={{ margin: '0' }} 
                                    onClick={() => handlePrintIn4()}
                                >
                                    Continue to checkout<i className="fas fa-right-arrow"></i>
                                </button>
                            </div>
                            {/* <div class="col-lg-12">
                                    <button type="submit" class="button utf_booking_confirmation_button margin-top-20 margin-bottom-10"><i class="fas fa-right-arrow"></i></button> 		
                            </div> */}
                        </div>
                        <div class="col-lg-4 col-md-4 margin-top-0 utf_listing_payment_section">
                            <div class="utf_booking_listing_item_container compact utf_order_summary_widget_section">
                            <div class="listing-item">
                                <div class="utf_listing_item_content">   							
                                </div>
                            </div>
                            </div>
                            <div class="boxed-widget opening-hours summary margin-top-0">
                                <h3><i class="fa fa-calendar-check-o"></i> Booking Summary</h3>
                                <ul>
                                    <li>Original Price<span>{orinalPrice}VNĐ</span></li>
                                        <li>Discount<span>-$</span></li>

                                    <li class="total-costs">
                                    <form action="" method="POST">
                                        <div class="col-md-8">
                                        <input id="couponCode" name="code" placeholder="Have a coupon enter here..." required="" type="text"/>
                                        </div>
                                        <div class="col-md-4">
                                        <input type="submit" class="coupon_code" value="Apply"/>	
                                        </div>
                                    </form>
                                    <div class="clearfix"></div>
                                    </li>
                                    <li class="total-costs">Total Cost <span>$</span></li>
                                </ul>
                                <form method="POST" action="https://checkout.flutterwave.com/v3/hosted/pay">
                                    <input type="hidden" name="public_key" value="FLWPUBK_TEST-a2c377d3cf56b37b9e660f85e26d2f8f-X" />
                                    <input type="hidden" name="customer[email]" value="{{booking.email}}" />
                                    <input type="hidden" name="customer[name]" value="{{booking.full_name}}" />
                                    <input type="hidden" name="tx_ref" value="ID-{{booking.booking_id}}" />
                                    <input type="hidden" name="amount" value="{{booking.total}}" />
                                    <input type="hidden" name="currency" value="USD" />
                                    <input type="hidden" name="meta[token]" value="54" />
                                    <input type="hidden" name="redirect_url" value="{{website_address}}/success/{{booking.booking_id}}/?success_id={{booking.success_id}}&booking_total={{booking.total}}" />
                                    
                                    <button id="flutter-btn" class="button utf_booking_confirmation_button margin-top-20 w-100 " style={{ backgroundColor: "orange", color: "rgb(37, 28, 3)" }}>Pay with Flutterwave <img src="https://asset.brandfetch.io/iddYbQIdlK/idmlgmHt_3.png" style={{width: "40px"}} alt=""/></button> 		
                                </form>
                                <button id="checkout-button" class="button utf_booking_confirmation_button margin-top-10 margin-bottom-10 w-100">Pay with Stripe <i class="fas fa-credit-card"></i></button> 		
                                <div id="paypal-button-container"></div>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}

const modalStyles = {
    display: 'flex',
    position: 'fixed',
    zIndex: 1000, // Đảm bảo modal ở trên cùng
    left: 0,
    top: 0,
    width: '100%',
    height: '100%',
    overflow: 'auto',
    backgroundColor: 'rgba(0, 0, 0, 0.8)',
    justifyContent: 'center',
    alignItems: 'center',
};

const modalContentStyles = {
    backgroundColor: '#fff',
    padding: '20px',
    borderRadius: '5px',
    textAlign: 'center',
    width: '80%',  // Thay đổi độ rộng modal
    maxWidth: '600px', // Thiết lập độ rộng tối đa
    height: 'auto', // Tự động điều chỉnh chiều cao
};

const closeButtonStyles = {
    cursor: 'pointer',
    float: 'right',
    fontSize: '28px',
    fontWeight: 'bold',
};

const imageStyles = {
    maxWidth: '100%',
    height: 'auto',
};

// CSS cho làm mờ
const styles = `
    .blurred {
        filter: blur(5px);
        pointer-events: none; /* Ngăn chặn tương tác với các phần tử mờ */
    }
`;

// Thêm CSS vào trang (có thể thực hiện trong file CSS riêng hoặc trong component)
const styleSheet = document.createElement("style");
styleSheet.type = "text/css";
styleSheet.innerText = styles;
document.head.appendChild(styleSheet);

export default SelectedRoom;