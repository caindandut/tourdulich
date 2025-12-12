package com.tourdulich.dao;

import com.tourdulich.model.KhachHang;

import java.util.List;
import java.util.Optional;

public interface KhachHangDAO {
    
    Optional<KhachHang> findById(Long id);
    
    Optional<KhachHang> findByNguoiDungId(Long nguoidungId);
    
    List<KhachHang> findAll();
    
    Long save(KhachHang khachHang);
    
    boolean update(KhachHang khachHang);
    
    boolean delete(Long id);
}



