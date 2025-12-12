package com.tourdulich.dao.impl;

import com.tourdulich.dao.KhachSanDAO;
import com.tourdulich.model.KhachSan;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class KhachSanDAOImpl implements KhachSanDAO {
    
    private static final Logger logger = LoggerFactory.getLogger(KhachSanDAOImpl.class);
    
    @Override
    public List<KhachSan> findAll() {
        List<KhachSan> list = new ArrayList<>();
        String sql = "SELECT * FROM khachsan ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToKhachSan(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all khach san", e);
        }
        return list;
    }
    
    @Override
    public Optional<KhachSan> findById(Long id) {
        String sql = "SELECT * FROM khachsan WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToKhachSan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding khach san by id: " + id, e);
        }
        return Optional.empty();
    }
    
    @Override
    public Optional<KhachSan> findByMaKhachSan(String maKhachSan) {
        String sql = "SELECT * FROM khachsan WHERE makhachsan = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, maKhachSan);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToKhachSan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding khach san by ma: " + maKhachSan, e);
        }
        return Optional.empty();
    }
    
    @Override
    public KhachSan save(KhachSan khachSan) {
        String sql = "INSERT INTO khachsan (makhachsan, tenkhachsan, gia, diachi, chatluong, hinhanh, trangthai, ngayden) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, khachSan.getMakhachsan());
            stmt.setString(2, khachSan.getTenkhachsan());
            stmt.setBigDecimal(3, khachSan.getGia());
            stmt.setString(4, khachSan.getDiachi());
            stmt.setString(5, khachSan.getChatluong());
            stmt.setString(6, khachSan.getHinhanh());
            stmt.setString(7, khachSan.getTrangthai() != null ? khachSan.getTrangthai().name() : "CON_PHONG");
            stmt.setDate(8, khachSan.getNgayden() != null ? Date.valueOf(khachSan.getNgayden()) : null);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        khachSan.setId(generatedKeys.getLong(1));
                    }
                }
                logger.info("Saved khach san: {}", khachSan.getTenkhachsan());
                return khachSan;
            }
        } catch (SQLException e) {

            if (e.getMessage().contains("hinhanh") || e.getMessage().contains("trangthai") || e.getMessage().contains("Unknown column")) {
                logger.warn("Cột mới chưa tồn tại, dùng SQL cũ: {}", e.getMessage());
                return saveOldVersion(khachSan);
            }
            logger.error("Error saving khach san", e);
        }
        return null;
    }
    
    private KhachSan saveOldVersion(KhachSan khachSan) {
        String sql = "INSERT INTO khachsan (makhachsan, tenkhachsan, gia, diachi, chatluong, ngayden) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, khachSan.getMakhachsan());
            stmt.setString(2, khachSan.getTenkhachsan());
            stmt.setBigDecimal(3, khachSan.getGia());
            stmt.setString(4, khachSan.getDiachi());
            stmt.setString(5, khachSan.getChatluong());
            stmt.setDate(6, khachSan.getNgayden() != null ? Date.valueOf(khachSan.getNgayden()) : null);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        khachSan.setId(generatedKeys.getLong(1));
                    }
                }
                return khachSan;
            }
        } catch (SQLException e) {
            logger.error("Error saving khach san (old version)", e);
        }
        return null;
    }
    
    @Override
    public boolean update(KhachSan khachSan) {
        String sql = "UPDATE khachsan SET makhachsan = ?, tenkhachsan = ?, gia = ?, diachi = ?, chatluong = ?, hinhanh = ?, trangthai = ?, ngayden = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, khachSan.getMakhachsan());
            stmt.setString(2, khachSan.getTenkhachsan());
            stmt.setBigDecimal(3, khachSan.getGia());
            stmt.setString(4, khachSan.getDiachi());
            stmt.setString(5, khachSan.getChatluong());
            stmt.setString(6, khachSan.getHinhanh());
            stmt.setString(7, khachSan.getTrangthai() != null ? khachSan.getTrangthai().name() : "CON_PHONG");
            stmt.setDate(8, khachSan.getNgayden() != null ? Date.valueOf(khachSan.getNgayden()) : null);
            stmt.setLong(9, khachSan.getId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                logger.info("Updated khach san: {}", khachSan.getId());
                return true;
            }
        } catch (SQLException e) {

            if (e.getMessage().contains("hinhanh") || e.getMessage().contains("trangthai") || e.getMessage().contains("Unknown column")) {
                logger.warn("Cột mới chưa tồn tại, dùng SQL cũ: {}", e.getMessage());
                return updateOldVersion(khachSan);
            }
            logger.error("Error updating khach san: " + khachSan.getId(), e);
        }
        return false;
    }
    
    private boolean updateOldVersion(KhachSan khachSan) {
        String sql = "UPDATE khachsan SET makhachsan = ?, tenkhachsan = ?, gia = ?, diachi = ?, chatluong = ?, ngayden = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, khachSan.getMakhachsan());
            stmt.setString(2, khachSan.getTenkhachsan());
            stmt.setBigDecimal(3, khachSan.getGia());
            stmt.setString(4, khachSan.getDiachi());
            stmt.setString(5, khachSan.getChatluong());
            stmt.setDate(6, khachSan.getNgayden() != null ? Date.valueOf(khachSan.getNgayden()) : null);
            stmt.setLong(7, khachSan.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating khach san (old version): " + khachSan.getId(), e);
        }
        return false;
    }
    
    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM khachsan WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                logger.info("Deleted khach san: {}", id);
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error deleting khach san: " + id, e);
        }
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM khachsan";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Error counting khach san", e);
        }
        return 0;
    }
    
    @Override
    public List<KhachSan> findByDiaChi(String diaChi) {
        List<KhachSan> list = new ArrayList<>();
        String sql = "SELECT * FROM khachsan WHERE diachi LIKE ? ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + diaChi + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToKhachSan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding khach san by dia chi: " + diaChi, e);
        }
        return list;
    }
    
    public boolean updateTrangThai(Long id, KhachSan.TrangThai trangthai) {
        String sql = "UPDATE khachsan SET trangthai = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, trangthai.name());
            stmt.setLong(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating trangthai khach san: " + id, e);
        }
        return false;
    }
    
    @Override
    public List<KhachSan> findAllAvailable() {
        List<KhachSan> list = new ArrayList<>();
        String sql = "SELECT * FROM khachsan WHERE trangthai = 'CON_PHONG' OR trangthai IS NULL ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToKhachSan(rs));
            }
        } catch (SQLException e) {

            if (e.getMessage().contains("trangthai") || e.getMessage().contains("Unknown column")) {
                logger.warn("Cột trangthai chưa tồn tại, trả về tất cả khách sạn");
                return findAll();
            }
            logger.error("Error finding available khach san", e);
        }
        return list;
    }

    @Override
    public List<KhachSan> findAvailableByDiaChi(String diaChiLike) {
        List<KhachSan> list = new ArrayList<>();
        String sql = "SELECT * FROM khachsan WHERE (trangthai = 'CON_PHONG' OR trangthai IS NULL) AND diachi LIKE ? ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + diaChiLike + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToKhachSan(rs));
                }
            }
        } catch (SQLException e) {

            if (e.getMessage().contains("trangthai") || e.getMessage().contains("Unknown column")) {
                logger.warn("Cột trangthai chưa tồn tại, fallback findByDiaChi");
                return findByDiaChi(diaChiLike);
            }
            logger.error("Error finding available khach san by dia chi: " + diaChiLike, e);
        }
        return list;
    }
    
    private KhachSan mapResultSetToKhachSan(ResultSet rs) throws SQLException {
        KhachSan ks = new KhachSan();
        ks.setId(rs.getLong("id"));
        ks.setMakhachsan(rs.getString("makhachsan"));
        ks.setTenkhachsan(rs.getString("tenkhachsan"));
        ks.setGia(rs.getBigDecimal("gia"));
        ks.setDiachi(rs.getString("diachi"));
        ks.setChatluong(rs.getString("chatluong"));
        

        try {
            ks.setHinhanh(rs.getString("hinhanh"));
        } catch (SQLException e) {

        }
        

        try {
            String trangthai = rs.getString("trangthai");
            if (trangthai != null) {
                ks.setTrangthai(KhachSan.TrangThai.valueOf(trangthai));
            } else {
                ks.setTrangthai(KhachSan.TrangThai.CON_PHONG);
            }
        } catch (SQLException e) {
            ks.setTrangthai(KhachSan.TrangThai.CON_PHONG);
        } catch (IllegalArgumentException e) {
            ks.setTrangthai(KhachSan.TrangThai.CON_PHONG);
        }
        
        Date ngayden = rs.getDate("ngayden");
        if (ngayden != null) {
            ks.setNgayden(ngayden.toLocalDate());
        }
        
        return ks;
    }
}
