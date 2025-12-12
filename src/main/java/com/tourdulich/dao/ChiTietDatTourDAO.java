package com.tourdulich.dao;

import com.tourdulich.model.ChiTietDatTour;

import java.util.List;
import java.util.Optional;

public interface ChiTietDatTourDAO {
    
    Optional<ChiTietDatTour> findById(Long id);
    
    List<ChiTietDatTour> findByDatTourId(Long dattourId);
    
    List<ChiTietDatTour> findByTourId(Long tourId);
    
    Long save(ChiTietDatTour chiTietDatTour);
    
    boolean update(ChiTietDatTour chiTietDatTour);
    
    boolean delete(Long id);
    
    boolean deleteByDatTourId(Long dattourId);
}



