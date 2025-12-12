package com.tourdulich.service;

import com.tourdulich.model.Tour;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface TourService {
    
    List<Tour> getTopNewestTours(int limit);
    
    List<Tour> getAllActiveTours();
    
    Optional<Tour> getTourById(Long id);
    
    List<Tour> searchTours(String keyword, String location, BigDecimal minPrice, BigDecimal maxPrice);
    
    List<Tour> getToursByLocation(String location);
    
    long getTotalActiveTours();
}



