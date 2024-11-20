import React, { useState, useEffect } from "react";
import { useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';
import axios from 'axios';
import { useAuth } from "../../auth/AuthContext";
import { Link } from "react-router-dom";
import { useRoomCount } from '../RoomCountContext/RoomCountContext';


const SelectedRoom = () => {

    const { token } = useAuth();
    const [cart, setCart] = useState({});
    const [hotels, setHotels] = useState([]);
    const [roomType, setRoomType] = useState({});
    const [selectedRoom, setSelectedRoom] = useState(null);
    const { setRoomCount } = useRoomCount();

    const fetchCart = async() => {
        const URL = 'http://127.0.0.1:8000/api/view_cart';
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
            
        }
        catch (error) {
            console.error(error);
        }
    }

    const deleteCartItem = async (id) => {
        const URL = 'http://127.0.0.1:8000/api/delete_cart_item';
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
        const URL = `http://127.0.0.1:8000/api/hotels/${slugHotel}/room-types/${slugRoomtype}/rooms/`;
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

    return (
        <>
            <div id="main_wrapper" class="selection-list">
                <div id="titlebar" class="gradient">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-12">
                            <h2>All Room Selections</h2>
                            <nav id="breadcrumbs">
                                <ul>
                                    <li><a>Home</a></li>
                                    <li><a>Hotel</a></li>
                                    <li><a>Rooms</a></li>
                                    <li>My selected rooms</li>
                                </ul>
                            </nav>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container margin-bottom-75">
                    <div class="row">
                        <div class="col-lg-8 col-md-8 utf_listing_payment_section">
                            {hotels.map(hotel => (
                                <li key={hotel.id}>
                                    <div class="utf_booking_listing_section_form margin-bottom-40">
                                    <Link to={`/detailhotel/${hotel.hotel_slug}`}><h3><i class="fas fa-bed"></i>{hotel.hotel_name}</h3></Link>
                                        <div class="utf_listing_section">
                                            <div class="utf_pricing_list_section">
                                                <ul>
                                                    {hotel.rooms.map(room => (
                                                        <>
                                                            <li key={room.id}>
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
                                    </div>
                                </li>
                            ))}

                            {selectedRoom && (
                                <div className="modal" onClick={handleOutsideClick} style={modalStyles}>
                                    <div className="modal-content" style={modalContentStyles}>
                                        <span className="close" onClick={handleCloseModal} style={closeButtonStyles}>&times;</span>
                                        <h2>{selectedRoom.type}</h2>
                                        <img 
                                            src={`http://127.0.0.1:8000${selectedRoom.image}`} 
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
                            
                            
                            <form class="utf_booking_listing_section_form margin-bottom-40" method="POST">
                            {/* {% csrf_token %} */}
                            <h3><i class="fas fa-user"></i> Billing Information</h3>
                            <div class="row">
                                <div class="col-md-12">
                                    <label>First Name</label>
                                    <input name="full_name" type="text" value="{{request.user.profile.full_name|title}}" placeholder="First Name"/>
                                </div>
                                <div class="col-md-6">
                                    <div class="medium-icons">
                                        <label>E-Mail</label>
                                        <input name="email" type="text" value="{{request.user.email}}" placeholder="Email"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="medium-icons">
                                        <label>Phone</label>
                                        <input name="phone" type="text" value="{{request.user.phone}}" placeholder="Phone"/>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <button type="submit" class="button utf_booking_confirmation_button margin-top-20 margin-bottom-10">Continue to checkout <i class="fas fa-right-arrow"></i></button> 		
                                </div>
                            </div>
                            </form>
                        </div>
                        <div class="col-lg-4 col-md-4 margin-top-0 utf_listing_payment_section">
                            <div class="utf_booking_listing_item_container compact utf_order_summary_widget_section">
                            <div class="listing-item">
                                <img src="{{hotel.image.url}}" alt=""/>
                                <div class="utf_listing_item_content">
                                    {/* <h3>{{hotel.name}}</h3> */}
                                    <span><i class="fa fa-map-marker"></i> </span>
                                    <br/>
                                    {/* <span><i class="fa fa-phone"></i> {{hotel.mobile}}</span>											 */}
                                    <div class="utf_star_rating_section" data-rating="4.5">
                                        <div class="utf_counter_star_rating">(18) Reviews</div>
                                    </div>
                                </div>
                            </div>
                            </div>
                            <div class="boxed-widget opening-hours summary margin-top-0">
                            <h3><i class="fa fa-calendar-check-o"></i> Booking Summary</h3>
                            <ul>
                                {/* <li>Check-in <span>{{checkin}}</span></li>
                                <li>Check-out <span>{{checkout}}</span></li>
                                <li>Total Days <span>{{total_days}} Days</span></li>
                                <li>Adults <span>{{ adult }} Adult</span></li>
                                <li>Children <span>{{ children }} Children</span></li>
                                <li>V.A.T <span>$0.00</span></li>
                                <li class="total-costs">Total Cost <span>${{total}}</span></li> */}
                            </ul>
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