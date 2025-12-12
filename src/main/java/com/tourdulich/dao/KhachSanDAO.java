package com.tourdulich.dao;

import com.tourdulich.model.KhachSan;
import java.util.List;
import java.util.Optional;

public interface KhachSanDAO {
    
    List<KhachSan> findAll();
    
    Optional<KhachSan> findById(Long id);
    
    Optional<KhachSan> findByMaKhachSan(String maKhachSan);
    
    KhachSan save(KhachSan khachSan);
    
    boolean update(KhachSan khachSan);
    
    boolean delete(Long id);
    
    long count();
    
    List<KhachSan> findByDiaChi(String diaChi);
    
    List<KhachSan> findAllAvailable();

    List<KhachSan> findAvailableByDiaChi(String diaChiLike);
}

