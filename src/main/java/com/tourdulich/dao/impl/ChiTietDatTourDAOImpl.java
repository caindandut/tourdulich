package com.tourdulich.dao.impl;

import com.tourdulich.dao.ChiTietDatTourDAO;
import com.tourdulich.model.ChiTietDatTour;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ChiTietDatTourDAOImpl implements ChiTietDatTourDAO {
    private static final Logger logger = LoggerFactory.getLogger(ChiTietDatTourDAOImpl.class);

    @Override
    public Optional<ChiTietDatTour> findById(Long id) {
        String sql = "SELECT * FROM ChiTietDatTour WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm chi tiết đặt tour theo ID: {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<ChiTietDatTour> findByDatTourId(Long dattourId) {
        String sql = "SELECT * FROM ChiTietDatTour WHERE dattour_id = ?";
        List<ChiTietDatTour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, dattourId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy chi tiết đặt tour theo đặt tour ID: {}", dattourId, e);
        }
        return list;
    }

    @Override
    public Long save(ChiTietDatTour chiTiet) {
        String sql = "INSERT INTO ChiTietDatTour (dattour_id, tour_id, tentour, giatour, ngay_khoihanh) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setLong(1, chiTiet.getDattourId());
            pstmt.setLong(2, chiTiet.getTourId());
            pstmt.setString(3, chiTiet.getTentour());
            pstmt.setBigDecimal(4, chiTiet.getGiatour());
            
            if (chiTiet.getNgaykhoihanh() != null) {
                pstmt.setDate(5, java.sql.Date.valueOf(chiTiet.getNgaykhoihanh()));
            } else {
                pstmt.setNull(5, Types.DATE);
            }
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Lỗi thêm chi tiết đặt tour", e);
        }
        return null;
    }

    @Override
    public boolean update(ChiTietDatTour chiTiet) {
        String sql = "UPDATE ChiTietDatTour SET tentour = ?, giatour = ?, ngay_khoihanh = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, chiTiet.getTentour());
            pstmt.setBigDecimal(2, chiTiet.getGiatour());
            
            if (chiTiet.getNgaykhoihanh() != null) {
                pstmt.setDate(3, java.sql.Date.valueOf(chiTiet.getNgaykhoihanh()));
            } else {
                pstmt.setNull(3, Types.DATE);
            }
            
            pstmt.setLong(4, chiTiet.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật chi tiết đặt tour ID: {}", chiTiet.getId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM ChiTietDatTour WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi xóa chi tiết đặt tour ID: {}", id, e);
        }
        return false;
    }

    @Override
    public boolean deleteByDatTourId(Long dattourId) {
        String sql = "DELETE FROM ChiTietDatTour WHERE dattour_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, dattourId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi xóa chi tiết đặt tour theo đơn đặt tour ID: {}", dattourId, e);
        }
        return false;
    }

    @Override
    public List<ChiTietDatTour> findByTourId(Long tourId) {
        String sql = "SELECT * FROM ChiTietDatTour WHERE tour_id = ?";
        List<ChiTietDatTour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, tourId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy chi tiết đặt tour theo tour ID: {}", tourId, e);
        }
        return list;
    }

    private ChiTietDatTour mapResultSetToEntity(ResultSet rs) throws SQLException {
        ChiTietDatTour chiTiet = new ChiTietDatTour();
        chiTiet.setId(rs.getLong("id"));
        chiTiet.setDattourId(rs.getLong("dattour_id"));
        chiTiet.setTourId(rs.getLong("tour_id"));
        chiTiet.setTentour(rs.getString("tentour"));
        chiTiet.setGiatour(rs.getBigDecimal("giatour"));
        
        java.sql.Date ngayKhoihanh = rs.getDate("ngay_khoihanh");
        if (ngayKhoihanh != null) {
            chiTiet.setNgaykhoihanh(ngayKhoihanh.toLocalDate());
        }
        
        return chiTiet;
    }
}

