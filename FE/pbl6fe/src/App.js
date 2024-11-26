import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from './pages/home'
import Login from './pages/auth/login.jsx'
import './styles/index.css';
import Register from "./pages/auth/register";
import ListHotel from "./pages/home/list_hotel/ListHotel";
import DetailHotel from "./pages/home/detail_hotel/DetailHotel";
import CheckRoomAvailability from "./pages/home/check_room_availability/CheckRoomAvailability";
import Checkout from "./pages/home/check_out/Checkout";
import SelectedRoom from "./pages/home/selected_rooms/SelectedRoom";
import { RoomCountProvider } from './pages/home/RoomCountContext/RoomCountContext';
import Header from './pages/baseComponent/Header';


export default function App() {
  return (
    <RoomCountProvider>
      <BrowserRouter>
        <Header />
        <Routes>
            <Route index element={<Home />} />
            <Route path="login" element={<Login />} />
            <Route path="selected_room" element={<SelectedRoom />} />
            <Route path="checkout" element={<Checkout />} />
            <Route path="register" element={<Register />} />
            <Route path="listhotel" element={<ListHotel />} />
            <Route path="detailhotel/:slug" element={<DetailHotel />} />
            <Route path="checkroomavailability/:slug" element={<CheckRoomAvailability />} />
            <Route path="contact" element={<div>Contact</div>} />
            <Route path="*" element={<div>1</div>} />
        </Routes>
      </BrowserRouter>
    </RoomCountProvider>
    // <div>
    //   <CsrfTokenFetcher/>
    // </div>
  );
}

