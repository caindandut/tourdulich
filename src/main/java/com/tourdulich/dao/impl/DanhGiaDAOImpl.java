package com.tourdulich.dao.impl;

import com.tourdulich.dao.DanhGiaDAO;
import com.tourdulich.model.DanhGia;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DanhGiaDAOImpl implements DanhGiaDAO {
    private static final Logger logger = LoggerFactory.getLogger(DanhGiaDAOImpl.class);

    @Override
    public List<DanhGia> findAll() {
        String sql = "SELECT * FROM DanhGia ORDER BY thoigian DESC";
        List<DanhGia> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Loi lay tat ca danh gia", e);
        }
        return list;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM DanhGia";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Loi dem danh gia", e);
        }
        return 0;
    }

    @Override
    public Optional<DanhGia> findById(Long id) {
        String sql = "SELECT * FROM DanhGia WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Loi tim danh gia theo ID: {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<DanhGia> findByTourId(Long tourId) {

        String sql = "SELECT * FROM DanhGia WHERE tour_id = ? AND (trangthai = 'HIEN_THI' OR trangthai IS NULL) ORDER BY thoigian DESC";
        List<DanhGia> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, tourId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {

            if (e.getMessage() != null && (e.getMessage().contains("trangthai") || e.getMessage().contains("Unknown column"))) {
                logger.warn("Cột trangthai chưa tồn tại, sử dụng query cũ cho tour: {}", tourId);
                return findByTourIdLegacy(tourId);
            }
            logger.error("Loi lay danh gia theo tour: {}", tourId, e);
        }
        return list;
    }
    

    private List<DanhGia> findByTourIdLegacy(Long tourId) {
        String sql = "SELECT * FROM DanhGia WHERE tour_id = ? ORDER BY thoigian DESC";
        List<DanhGia> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, tourId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Loi lay danh gia theo tour (legacy): {}", tourId, e);
        }
        return list;
    }

    @Override
    public List<DanhGia> findByKhachHangId(Long khachhangId) {
        String sql = "SELECT * FROM DanhGia WHERE khachhang_id = ? ORDER BY thoigian DESC";
        List<DanhGia> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, khachhangId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Loi lay danh gia theo khach hang: {}", khachhangId, e);
        }
        return list;
    }

    @Override
    public boolean existsByKhachHangIdAndTourId(Long khachhangId, Long tourId) {
        String sql = "SELECT COUNT(*) FROM DanhGia WHERE khachhang_id = ? AND tour_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, khachhangId);
            pstmt.setLong(2, tourId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.error("Loi kiem tra danh gia ton tai", e);
        }
        return false;
    }

    @Override
    public Long save(DanhGia danhGia) {
        String sql = "INSERT INTO DanhGia (madanhgia, khachhang_id, tour_id, noidung, rating) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, danhGia.getMadanhgia());
            pstmt.setLong(2, danhGia.getKhachhangId());
            pstmt.setLong(3, danhGia.getTourId());
            pstmt.setString(4, danhGia.getNoidung());
            pstmt.setInt(5, danhGia.getRating() != null ? danhGia.getRating() : 5);
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Loi them danh gia", e);
        }
        return null;
    }

    @Override
    public boolean update(DanhGia danhGia) {
        String sql = "UPDATE DanhGia SET noidung = ?, rating = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, danhGia.getNoidung());
            pstmt.setInt(2, danhGia.getRating() != null ? danhGia.getRating() : 5);
            pstmt.setLong(3, danhGia.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Loi cap nhat danh gia ID: {}", danhGia.getId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM DanhGia WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Loi xoa danh gia ID: {}", id, e);
        }
        return false;
    }

    @Override
    public long countByTourId(Long tourId) {

        String sql = "SELECT COUNT(*) FROM DanhGia WHERE tour_id = ? AND (trangthai = 'HIEN_THI' OR trangthai IS NULL)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, tourId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {

            if (e.getMessage() != null && (e.getMessage().contains("trangthai") || e.getMessage().contains("Unknown column"))) {
                logger.warn("Cột trangthai chưa tồn tại, sử dụng query cũ để đếm cho tour: {}", tourId);
                return countByTourIdLegacy(tourId);
            }
            logger.error("Loi dem danh gia tour: {}", tourId, e);
        }
        return 0;
    }
    

    private long countByTourIdLegacy(Long tourId) {
        String sql = "SELECT COUNT(*) FROM DanhGia WHERE tour_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, tourId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Loi dem danh gia tour (legacy): {}", tourId, e);
        }
        return 0;
    }
    
    public boolean updateTrangthai(Long id, DanhGia.TrangThai trangthai) {
        String sql = "UPDATE DanhGia SET trangthai = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, trangthai.name());
            pstmt.setLong(2, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Loi cap nhat trang thai danh gia ID: {}", id, e);
        }
        return false;
    }

    private DanhGia mapResultSetToEntity(ResultSet rs) throws SQLException {
        DanhGia danhGia = new DanhGia();
        danhGia.setId(rs.getLong("id"));
        danhGia.setMadanhgia(rs.getString("madanhgia"));
        danhGia.setKhachhangId(rs.getLong("khachhang_id"));
        danhGia.setTourId(rs.getLong("tour_id"));
        danhGia.setNoidung(rs.getString("noidung"));
        
        try {
            int rating = rs.getInt("rating");
            if (!rs.wasNull()) {
                danhGia.setRating(rating);
            } else {
                danhGia.setRating(5);
            }
        } catch (SQLException e) {
            danhGia.setRating(5);
        }
        
        try {
            String trangthai = rs.getString("trangthai");
            if (trangthai != null) {
                danhGia.setTrangthai(DanhGia.TrangThai.valueOf(trangthai));
            } else {
                danhGia.setTrangthai(DanhGia.TrangThai.HIEN_THI);
            }
        } catch (SQLException e) {
            danhGia.setTrangthai(DanhGia.TrangThai.HIEN_THI);
        } catch (IllegalArgumentException e) {
            danhGia.setTrangthai(DanhGia.TrangThai.HIEN_THI);
        }
        
        Timestamp thoigian = rs.getTimestamp("thoigian");
        if (thoigian != null) {
            danhGia.setThoigian(thoigian.toLocalDateTime());
        }
        
        return danhGia;
    }
}
