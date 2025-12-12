package com.tourdulich.dao;

import com.tourdulich.model.DatTour;

import java.util.List;
import java.util.Optional;

public interface DatTourDAO {
    
    Optional<DatTour> findById(Long id);
    
    Optional<DatTour> findByMaDatTour(String madattour);
    
    List<DatTour> findAll();
    
    List<DatTour> findByKhachHangId(Long khachhangId);
    
    List<DatTour> findByTrangThai(DatTour.TinhTrang tinhtrang);
    
    List<DatTour> findByKhachHangIdAndTrangThai(Long khachhangId, DatTour.TinhTrang tinhtrang);
    
    Long save(DatTour datTour);
    
    boolean update(DatTour datTour);
    
    boolean updateTrangThai(Long id, DatTour.TinhTrang tinhtrang);
    
    boolean updateDaThanhToan(Long id, Boolean dathanhtoan);
    
    boolean delete(Long id);
    
    long count();
    
    long countByTrangThai(DatTour.TinhTrang tinhtrang);
    
    java.math.BigDecimal getTotalRevenue();
}

