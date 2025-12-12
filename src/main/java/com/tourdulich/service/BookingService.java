package com.tourdulich.service;

import com.tourdulich.model.DatTour;
import com.tourdulich.model.Tour;

import java.util.List;
import java.util.Optional;

public interface BookingService {
    
    Long createBooking(DatTour datTour, Tour tour);
    
    List<DatTour> getBookingsByKhachHang(Long khachhangId);
    
    Optional<DatTour> getBookingById(Long id);
    
    boolean cancelBooking(Long bookingId, Long khachhangId);
    
    boolean confirmBooking(Long bookingId);
    
    List<DatTour> getAllBookings();
}



