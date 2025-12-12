package com.tourdulich.service;

import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;

import java.util.Optional;

public interface AuthService {
    
    Long register(String tendangnhap, String matkhau, String hotennguoidung, 
                  String email, String sdt, String diachi);
    
    Optional<NguoiDung> login(String tendangnhap, String matkhau);
    
    boolean isUsernameExists(String tendangnhap);
    
    boolean isEmailExists(String email);
    
    Optional<KhachHang> getKhachHangByNguoiDungId(Long nguoidungId);
    
    boolean updateProfile(Long nguoidungId, String hotennguoidung, String email, String sdt, String diachi);
    
    boolean changePassword(Long nguoidungId, String oldPassword, String newPassword);
}



