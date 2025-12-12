package com.tourdulich.service.impl;

import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.dao.impl.KhachHangDAOImpl;
import com.tourdulich.dao.impl.NguoiDungDAOImpl;
import com.tourdulich.model.KhachHang;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.service.AuthService;
import com.tourdulich.util.PasswordUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;
import java.util.UUID;

public class AuthServiceImpl implements AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthServiceImpl.class);
    
    private final NguoiDungDAO nguoiDungDAO;
    private final KhachHangDAO khachHangDAO;
    
    public AuthServiceImpl() {
        this.nguoiDungDAO = new NguoiDungDAOImpl();
        this.khachHangDAO = new KhachHangDAOImpl();
    }
    

    public AuthServiceImpl(NguoiDungDAO nguoiDungDAO, KhachHangDAO khachHangDAO) {
        this.nguoiDungDAO = nguoiDungDAO;
        this.khachHangDAO = khachHangDAO;
    }

    @Override
    public Long register(String tendangnhap, String matkhau, String hotennguoidung, 
                        String email, String sdt, String diachi) {
        try {

            if (nguoiDungDAO.existsByUsername(tendangnhap)) {
                logger.warn("Username đã tồn tại: {}", tendangnhap);
                return null;
            }
            

            if (nguoiDungDAO.existsByEmail(email)) {
                logger.warn("Email đã tồn tại: {}", email);
                return null;
            }
            

            String hashedPassword = PasswordUtil.hashPassword(matkhau);
            

            NguoiDung nguoiDung = new NguoiDung(tendangnhap, hashedPassword, hotennguoidung, email, sdt, NguoiDung.Role.CUSTOMER);
            nguoiDung.setManguoidung("ND" + System.currentTimeMillis());
            nguoiDung.setStatus(NguoiDung.Status.ACTIVE);
            
            Long nguoidungId = nguoiDungDAO.save(nguoiDung);
            
            if (nguoidungId != null) {

                KhachHang khachHang = new KhachHang(nguoidungId, diachi);
                khachHang.setMakhachhang("KH" + System.currentTimeMillis());
                
                Long khachhangId = khachHangDAO.save(khachHang);
                
                if (khachhangId != null) {
                    logger.info("Đăng ký thành công: username={}, nguoidungId={}, khachhangId={}", 
                               tendangnhap, nguoidungId, khachhangId);
                    return nguoidungId;
                } else {

                    nguoiDungDAO.delete(nguoidungId);
                    logger.error("Lỗi tạo khách hàng, đã rollback");
                    return null;
                }
            }
            
        } catch (Exception e) {
            logger.error("Lỗi đăng ký tài khoản", e);
        }
        return null;
    }

    @Override
    public Optional<NguoiDung> login(String tendangnhap, String matkhau) {
        try {
            Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findByUsername(tendangnhap);
            
            if (nguoiDungOpt.isPresent()) {
                NguoiDung nguoiDung = nguoiDungOpt.get();
                

                if (nguoiDung.getStatus() == NguoiDung.Status.LOCKED) {
                    logger.warn("Tài khoản bị khóa: {}", tendangnhap);
                    return Optional.empty();
                }
                

                if (PasswordUtil.verifyPassword(matkhau, nguoiDung.getMatkhau())) {
                    logger.info("Đăng nhập thành công: username={}, role={}", tendangnhap, nguoiDung.getRole());
                    return Optional.of(nguoiDung);
                } else {
                    logger.warn("Sai mật khẩu: {}", tendangnhap);
                }
            } else {
                logger.warn("Không tìm thấy username: {}", tendangnhap);
            }
            
        } catch (Exception e) {
            logger.error("Lỗi đăng nhập", e);
        }
        return Optional.empty();
    }

    @Override
    public boolean isUsernameExists(String tendangnhap) {
        return nguoiDungDAO.existsByUsername(tendangnhap);
    }

    @Override
    public boolean isEmailExists(String email) {
        return nguoiDungDAO.existsByEmail(email);
    }

    @Override
    public Optional<KhachHang> getKhachHangByNguoiDungId(Long nguoidungId) {
        return khachHangDAO.findByNguoiDungId(nguoidungId);
    }

    @Override
    public boolean updateProfile(Long nguoidungId, String hotennguoidung, String email, String sdt, String diachi) {
        try {

            Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(nguoidungId);
            if (nguoiDungOpt.isPresent()) {
                NguoiDung nguoiDung = nguoiDungOpt.get();
                

                if (!nguoiDung.getEmail().equals(email) && nguoiDungDAO.existsByEmail(email)) {
                    logger.warn("Email đã tồn tại: {}", email);
                    return false;
                }
                
                nguoiDung.setHotennguoidung(hotennguoidung);
                nguoiDung.setEmail(email);
                nguoiDung.setSdt(sdt);
                
                boolean updated = nguoiDungDAO.update(nguoiDung);
                

                if (updated && diachi != null) {
                    Optional<KhachHang> khachHangOpt = khachHangDAO.findByNguoiDungId(nguoidungId);
                    if (khachHangOpt.isPresent()) {
                        KhachHang khachHang = khachHangOpt.get();
                        khachHang.setDiachi(diachi);
                        khachHangDAO.update(khachHang);
                    }
                }
                
                logger.info("Cập nhật profile thành công: nguoidungId={}", nguoidungId);
                return updated;
            }
            
        } catch (Exception e) {
            logger.error("Lỗi cập nhật profile", e);
        }
        return false;
    }

    @Override
    public boolean changePassword(Long nguoidungId, String oldPassword, String newPassword) {
        try {
            Optional<NguoiDung> nguoiDungOpt = nguoiDungDAO.findById(nguoidungId);
            
            if (nguoiDungOpt.isPresent()) {
                NguoiDung nguoiDung = nguoiDungOpt.get();
                

                if (!PasswordUtil.verifyPassword(oldPassword, nguoiDung.getMatkhau())) {
                    logger.warn("Mật khẩu cũ không đúng: nguoidungId={}", nguoidungId);
                    return false;
                }
                

                String hashedPassword = PasswordUtil.hashPassword(newPassword);
                nguoiDung.setMatkhau(hashedPassword);
                
                boolean updated = nguoiDungDAO.update(nguoiDung);
                
                if (updated) {
                    logger.info("Đổi mật khẩu thành công: nguoidungId={}", nguoidungId);
                }
                
                return updated;
            }
            
        } catch (Exception e) {
            logger.error("Lỗi đổi mật khẩu", e);
        }
        return false;
    }
}

