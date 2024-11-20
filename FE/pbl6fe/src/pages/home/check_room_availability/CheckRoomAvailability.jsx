import React, {useState, useEffect} from "react";
import Header from "../../baseComponent/Header";
import { useParams } from "react-router-dom";
import { useLocation } from 'react-router-dom';
import { useNavigate } from "react-router-dom";
import axios from "axios";
import Swal from 'sweetalert2';
import { useRoomCount } from '../RoomCountContext/RoomCountContext';
import { useAuth } from '../../auth/AuthContext';

const CheckRoomAvailability = () => {
    const [roomAvailabilities, setRoomAvailabilities] = useState([]);
    const [nameHotel, setNameHotel] = useState('');
    const [roomType, setRoomType] = useState(); //detail roomtype
    const [listRoomTypes, setListRoomTypes] = useState([]); // list roomtypes
    const [error, setError] = useState([]);
    const [selectedRoom, setSelectedRoom] = useState(null);

    const { token } = useAuth();
    const { slug } = useParams();
    const navigate = useNavigate();

    const query = new URLSearchParams(useLocation().search);
    const initialRoomType = query.get('room-type'); 
    const dateCheckin = query.get('date-checkin');
    const dateCheckout = query.get('date-checkout');
    const quantityAdults = query.get('adults');
    const quantityChildrens = query.get('childrens');

    const [roomTypeInit, setRoomTypeInit] = useState(initialRoomType);
    const [adults, setAdults] = useState(parseInt(quantityAdults));
    const [childrens, setChildrens] = useState(parseInt(quantityChildrens));
    const [checkin, setCheckin] = useState(dateCheckin); 
    const [checkout, setCheckout] = useState(dateCheckout);
    const { setRoomCount } = useRoomCount();

    console.log(initialRoomType,slug,dateCheckin,dateCheckout,quantityAdults,quantityChildrens);

    useEffect(() => {
        const fetchRoomAvailability = async () => {
            try {
                const responseRoomAvailability = await axios.get(`http://127.0.0.1:8000/api/hotels/${slug}/room-types/${initialRoomType}/rooms`,{
                    headers: {
                        'Authorization': `Bearer ${token}`  
                    }
                })
                setRoomAvailabilities(responseRoomAvailability.data.listroom);
                console.log(responseRoomAvailability.data.listroom);
                setRoomType(responseRoomAvailability.data.roomtype);
                setNameHotel(responseRoomAvailability.data.hotel)

                const responseListRoomType = await axios.get(`http://127.0.0.1:8000/api/hotels/${slug}/room-types`, {
                    headers: {
                        'Authorization': `Bearer ${token}`  
                    }
                });
                console.log(responseListRoomType.data.roomtype);
                setListRoomTypes(responseListRoomType.data.roomtype)
            } catch (error) {
                setError(error)
            }
        };
        fetchRoomAvailability();
    },[initialRoomType])

    const fetchTypeRoom = async(slugHotel, slugRoomtype) => {
        const URL = `http://127.0.0.1:8000/api/hotels/${slugHotel}/room-types/${slugRoomtype}/rooms/`;
        try {
            const respoonse = await axios.get(URL, {
                headers: {
                    'Authorization' : `Bearer ${token}`
                }
            });
            setSelectedRoom(respoonse.data.roomtype);
        }
        catch (error) {
            console.error(error);
        }

    }

    const changeQuantity = (type, quantity) => {
        if(type === 'adults') {
            setAdults(prev => Math.max(prev + quantity, 0));
        }
        else {
            setChildrens(prev => Math.max(prev + quantity, 0));
        }
    }

    const handleSelectRoomType = (e) => {
        setRoomTypeInit(e.target.value);
    }

    const handleCheckinDate = (e) => {
        setCheckin(e.target.value); 
    }
    
    const handleCheckoutDate = (e) => {
        const dateCheckout = e.target.value;
        if(new Date(checkin) > new Date(dateCheckout)) {
            setCheckout('');
            Swal.fire({
                icon: 'error',
                title: 'Ngày Checkout không hợp lệ!',
                text: ' Bạn vui lòng nhập lại ngày Check out',
                showConfirmButton: false,
                timer: 3000
            })
        }
        else {
            setCheckout(dateCheckout);
        }
    }

    const handleCheckRoomAvailability = () => {
        let responseData
        console.log(responseData)
        if((checkin && checkout) && (new Date(checkin) < new Date(checkout))) {
            if(roomTypeInit && checkin && checkout && adults && childrens) {
                const urlAPICheckRoomAvailability = 'http://127.0.0.1:8000/booking/api/booking/check-room-availability/'
                const data = {
                    hotel_id: nameHotel.id,
                    room_type: roomTypeInit,
                    checkin: checkin,
                    checkout: checkout,
                    adult: adults,
                    children: childrens
                };
                console.log(data)
                axios.post(urlAPICheckRoomAvailability, data, {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                })
                .then(response => {
                    responseData = response.data
                    console.log('responseData : ', responseData)
                    navigate(`/checkroomavailability/${encodeURIComponent(responseData.slug)}?room-type=${encodeURIComponent(responseData.room_type)}&date-checkin=${encodeURIComponent(checkin)}&date-checkout=${encodeURIComponent(checkout)}&adults=${encodeURIComponent(adults)}&childrens=${encodeURIComponent(childrens)}`);
                })
                .catch(error => {
                    console.error('There was an error!', error);
                })
            }
            else {
                Swal.fire({
                    icon: 'error',
                    title: 'Nhập thiếu thông tin!',
                    text: 'Vui lòng nhập đầy đủ các thông tin cần để kiểm tra phòng trống',
                    showConfirmButton: false,
                    timer: 2000
                })
            }
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Ngày Checkout không hợp lệ!',
                text: ' Bạn vui lòng nhập lại ngày Check out',
                showConfirmButton: false,
                timer: 3000
            })
        }

    }

    const handleAddToSelection = (roomId, checkin, checkout, adults, childrens) => {
        let responseData;
        const urlAPIAddToSelection = 'http://127.0.0.1:8000/api/add-cart-item';
        const data = {
            "room": roomId,
            "check_in_date": checkin,
            "check_out_date": checkout,
            "num_adults": adults,
            "num_children": childrens,
        };
      
        axios.post(urlAPIAddToSelection, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        })
        .then(response => {
            responseData = response.data;
            console.log(responseData);
            setRoomCount(prevCount => prevCount + 1);
        })
        .catch(error => {
            if (error.response && error.response.data.error) {
                Swal.fire({
                    icon: 'error',
                    title: error.response.data.error,
                    text: 'Vui lòng kiểm tra lại.',
                    showConfirmButton: false,
                    timer: 3000
                });
            } else {
                console.error('There was an error', error);
            }
        });
    };

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
            <div id="titlebar" class="gradient">
                <div class="container">
                <div class="row">
                    <div class="col-md-12">
                    <h2>{nameHotel.name} - {initialRoomType} Room</h2>
                    <nav id="breadcrumbs">
                        <ul>
                        <li><p>{roomAvailabilities.length} Available Rooms</p></li>
                        </ul>
                    </nav>
                    </div>
                </div>
                </div>
            </div>
            <section class="fullwidth_block margin-top-0 padding-top-0 padding-bottom-50" data-background-color="#fff"> 
                <div class="container">
                <div class="row">
                    <div class="col-md-12">
                    <h3 class="headline_part centered margin-bottom-20">All Available Rooms<span>The {initialRoomType} room has {roomAvailabilities.length} available room(s)</span></h3>
                    </div>
                </div>
                <div class="row">  
                    <div class="col-lg-8 "> 
                        <ul>
                            {roomAvailabilities.map(RoomAvailability =>(
                                <li key={RoomAvailability.id}>
                                        <div class="plan featured col-md-4 col-sm-6 col-xs-12">
                                            <div 
                                            class="utf_price_plan"
                                            onClick={() => handleRoomClick(slug, initialRoomType)} 
                                            style={{ 
                                                cursor: 'pointer', 
                                            }}
                                            >
                                                <h3>Room No. {RoomAvailability.room_number} </h3>
                                                <span class="value">{roomType.price} VNĐ<span>/Per Night</span></span> 
                                            </div>
                                            <div class="utf_price_plan_features">
                                                <ul>
                                                <li>Beds:  {roomType.number_of_beds}</li>
                                                <li>Room Capacity: {roomType.room_capacity}</li>
                                                </ul>
                                                <input type="hidden" class="room_id_{{r.id}}" value="{{r.id}}" id="room_id"/>
                                                <input type="hidden" class="room_number_{{r.id}}" value="{{r.room_number}}" id="room_number"/>
                                                <button class="button border add-to-selection" data-index="{{r.id}}"
                                                        onClick={() => handleAddToSelection(RoomAvailability.id, dateCheckin,dateCheckout,quantityAdults,quantityChildrens )}><i class="fas fa-shopping-cart"></i> Add To Selection</button> 
                                            </div>
                                        </div>
                                </li>
                            ))}
                        </ul>
                    </div>

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
           
                    <input type="hidden" value="{{hotel.id}}" id="id"/>
                    <input type="hidden" value="{{hotel.name}}" id="hotel_name"/>
                    <input type="hidden" value="{{room_type.type}}" id="room_name"/>
                    <input type="hidden" value="{{room_type.price}}" id="room_price"/>
                    <input type="hidden" value="{{room_type.number_of_beds}}" id="number_of_beds"/>
                    <input type="hidden" value="{{room_type.id}}" id="room_type"/>
                    <input type="hidden" value="{{checkin}}" id="checkin"/>
                    <input type="hidden" value="{{checkout}}" id="checkout"/>
                    <input type="hidden" value="{{adult}}" id="adult"/>
                    <input type="hidden" value="{{children}}" id="children"/>

                    <div class="col-lg-4">
                        <div class=" booking_widget_box" style={{ border: '1px dashed rgba(42, 1, 119, 0.61)', padding: '14px', borderRadius: '10px'}}>
                            <h3><i class="fa fa-calendar"></i> Booking</h3>
                            <input type="text" value={nameHotel.name} name="hotel-id" id=""/>
                            <div class="col-lg-12 col-md-12 select_date_box">
                                <label for="">Check-in Date</label>
                                <input type="date" id="date-picker" value={checkin} name="checkin" placeholder="Select Date"
                                    onChange={handleCheckinDate}/>
                            </div>
                            <div class="col-lg-12 col-md-12 select_date_box">
                                <label for="">Check-out Date</label>
                                <input type="date" class="checkout_date" name="checkout" value={checkout}  placeholder="Select Date"
                                    onChange={handleCheckoutDate}/>
                            </div>
                            <div class="with-forms">
                                <div class="col-lg-12 col-md-12">
                                    <a href="#">Guests <span class="qtyTotal" name="qtyTotal">{adults + childrens}</span></a>
                                    <div class="panel-dropdown-content">
                                            <div class="qtyButtons">
                                            <div class="qtyTitle">Adults</div>
                                                <button className="btn-decrement" style={{width:'40px', border:'none' }}
                                                onClick={() => changeQuantity('adults', -1)}>-</button>
                                                <input type="text" name="adult" value={adults}/>
                                                <button className="btn-increment" style={{width:'40px', border:'none' }}
                                                onClick={() => changeQuantity('adults', 1)}>+</button>
                                            </div>
                                            <div class="qtyButtons">
                                            <div class="qtyTitle">Childrens</div>
                                                <button className="btn-decrement" style={{width:'40px', border:'none' }}
                                                onClick={() => changeQuantity('childrens', -1)}>-</button>
                                                <input type="text" name="children" value={childrens}/>
                                                <button className="btn-increment" style={{width:'40px', border:'none' }}
                                                onClick={() => changeQuantity('childrens', 1)}>+</button>
                                            </div>
                                    </div>
                                </div>
                            </div>
                            <div class="with-forms margin-top-30">
                                <div class="col-lg-12 col-md-12 ">
                                    <label for="">Select Room Type </label>
                                        <select 
                                        name="room-type" className="utf_chosen_select_single" 
                                        required
                                        value={roomTypeInit}
                                        onChange={handleSelectRoomType}
                                        >
                                            {listRoomTypes.map(roomType => (
                                                <option value={roomType.type}>{roomType.type}</option>
                                            ))}
                                        </select>
                                </div>
                            </div>     
                            <button type="submit" 
                            className="utf_progress_button button fullwidth_block margin-top-5"
                            onClick={handleCheckRoomAvailability}
                            >
                                Check Availability
                            </button>
                        <button class="like-button add_to_wishlist"><span class="like-icon"></span> Add to Wishlist</button>
                        <div class="clearfix"></div>
                        </div>
                    </div>      
                </div>      
                </div>    
            </section>
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

export default CheckRoomAvailability