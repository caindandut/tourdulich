package com.tourdulich.dao;

import com.tourdulich.model.DanhGia;

import java.util.List;
import java.util.Optional;

public interface DanhGiaDAO {
    
    List<DanhGia> findAll();
    
    long count();
    
    Optional<DanhGia> findById(Long id);
    
    List<DanhGia> findByTourId(Long tourId);
    
    List<DanhGia> findByKhachHangId(Long khachhangId);
    
    boolean existsByKhachHangIdAndTourId(Long khachhangId, Long tourId);
    
    Long save(DanhGia danhGia);
    
    boolean update(DanhGia danhGia);
    
    boolean delete(Long id);
    
    long countByTourId(Long tourId);
    
    boolean updateTrangthai(Long id, DanhGia.TrangThai trangthai);
}



