package com.tourdulich.dao;

import com.tourdulich.model.NguoiDung;

import java.util.List;
import java.util.Optional;

public interface NguoiDungDAO {
    
    Optional<NguoiDung> findById(Long id);
    
    Optional<NguoiDung> findByUsername(String tendangnhap);
    
    Optional<NguoiDung> findByEmail(String email);
    
    List<NguoiDung> findAll();
    
    List<NguoiDung> findByRole(NguoiDung.Role role);
    
    Long save(NguoiDung nguoiDung);
    
    boolean update(NguoiDung nguoiDung);
    
    boolean delete(Long id);
    
    boolean updateStatus(Long id, NguoiDung.Status status);
    
    boolean existsByUsername(String tendangnhap);
    
    boolean existsByEmail(String email);
    
    long count();
}



