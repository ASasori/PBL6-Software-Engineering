import React, { createContext, useState, useContext } from 'react';

const RoomCountContext = createContext();

export const RoomCountProvider = ({ children }) => {
    const [roomCount, setRoomCount] = useState(0);

    return (
        <RoomCountContext.Provider value={{ roomCount, setRoomCount }}>
            {children}
        </RoomCountContext.Provider>
    );
};

export const useRoomCount = () => {
    return useContext(RoomCountContext);
};