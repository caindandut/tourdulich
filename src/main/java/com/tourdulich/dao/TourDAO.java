package com.tourdulich.dao;

import com.tourdulich.model.Tour;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface TourDAO {
    
    Optional<Tour> findById(Long id);
    
    Optional<Tour> findByMaTour(String matour);
    
    List<Tour> findAll();
    
    List<Tour> findAllActive();
    
    List<Tour> findTopNewest(int limit);
    
    List<Tour> searchByName(String keyword);
    
    List<Tour> searchByLocation(String location);
    
    List<Tour> searchByPriceRange(BigDecimal minPrice, BigDecimal maxPrice);
    
    List<Tour> search(String keyword, String location, BigDecimal minPrice, BigDecimal maxPrice);
    
    Long save(Tour tour);
    
    boolean update(Tour tour);
    
    boolean delete(Long id);
    
    boolean updateStatus(Long id, Tour.Status status);
    
    long count();
    
    long countActive();
}



