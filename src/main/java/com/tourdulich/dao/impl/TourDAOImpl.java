package com.tourdulich.dao.impl;

import com.tourdulich.dao.TourDAO;
import com.tourdulich.model.Tour;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class TourDAOImpl implements TourDAO {
    private static final Logger logger = LoggerFactory.getLogger(TourDAOImpl.class);

    @Override
    public Optional<Tour> findById(Long id) {
        String sql = "SELECT * FROM Tour WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm tour theo ID: {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Tour> findByMaTour(String matour) {
        String sql = "SELECT * FROM Tour WHERE matour = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, matour);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm tour theo mã: {}", matour, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Tour> findAll() {
        String sql = "SELECT * FROM Tour ORDER BY created_at DESC";
        return executeQuery(sql);
    }

    @Override
    public List<Tour> findAllActive() {
        String sql = "SELECT * FROM Tour WHERE status = 'ACTIVE' ORDER BY created_at DESC";
        return executeQuery(sql);
    }

    @Override
    public List<Tour> findTopNewest(int limit) {
        String sql = "SELECT * FROM Tour WHERE status = 'ACTIVE' ORDER BY created_at DESC LIMIT ?";
        List<Tour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy top tour mới nhất", e);
        }
        return list;
    }

    @Override
    public List<Tour> searchByName(String keyword) {
        String sql = "SELECT * FROM Tour WHERE tentour LIKE ? AND status = 'ACTIVE'";
        List<Tour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + keyword + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm kiếm tour theo tên: {}", keyword, e);
        }
        return list;
    }

    @Override
    public List<Tour> searchByLocation(String location) {
        String sql = "SELECT * FROM Tour WHERE diadiem LIKE ? AND status = 'ACTIVE'";
        List<Tour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + location + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm kiếm tour theo địa điểm: {}", location, e);
        }
        return list;
    }

    @Override
    public List<Tour> searchByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        String sql = "SELECT * FROM Tour WHERE gia BETWEEN ? AND ? AND status = 'ACTIVE'";
        List<Tour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBigDecimal(1, minPrice);
            pstmt.setBigDecimal(2, maxPrice);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm kiếm tour theo giá", e);
        }
        return list;
    }

    @Override
    public List<Tour> search(String keyword, String location, BigDecimal minPrice, BigDecimal maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Tour WHERE status = 'ACTIVE'");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND tentour LIKE ?");
            params.add("%" + keyword + "%");
        }
        
        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND diadiem LIKE ?");
            params.add("%" + location + "%");
        }
        
        if (minPrice != null && maxPrice != null) {
            sql.append(" AND gia BETWEEN ? AND ?");
            params.add(minPrice);
            params.add(maxPrice);
        }
        
        sql.append(" ORDER BY created_at DESC");
        
        List<Tour> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm kiếm tour", e);
        }
        return list;
    }

    @Override
    public Long save(Tour tour) {
        String sql = "INSERT INTO Tour (matour, tentour, diadiem, thoiluong, gia, mota, hinhanh, ngaykhoihanh, phuongtienchinh, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, tour.getMatour());
            pstmt.setString(2, tour.getTentour());
            pstmt.setString(3, tour.getDiadiem());
            pstmt.setString(4, tour.getThoiluong());
            pstmt.setBigDecimal(5, tour.getGia());
            pstmt.setString(6, tour.getMota());
            pstmt.setString(7, tour.getHinhanh());
            pstmt.setDate(8, tour.getNgaykhoihanh() != null ? Date.valueOf(tour.getNgaykhoihanh()) : null);
            pstmt.setString(9, tour.getPhuongtienchinh());
            pstmt.setString(10, tour.getStatus() != null ? tour.getStatus().name() : Tour.Status.ACTIVE.name());
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Lỗi thêm tour", e);
        }
        return null;
    }

    @Override
    public boolean update(Tour tour) {
        String sql = "UPDATE Tour SET tentour = ?, diadiem = ?, thoiluong = ?, gia = ?, mota = ?, " +
                     "hinhanh = ?, ngaykhoihanh = ?, phuongtienchinh = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tour.getTentour());
            pstmt.setString(2, tour.getDiadiem());
            pstmt.setString(3, tour.getThoiluong());
            pstmt.setBigDecimal(4, tour.getGia());
            pstmt.setString(5, tour.getMota());
            pstmt.setString(6, tour.getHinhanh());
            pstmt.setDate(7, tour.getNgaykhoihanh() != null ? Date.valueOf(tour.getNgaykhoihanh()) : null);
            pstmt.setString(8, tour.getPhuongtienchinh());
            pstmt.setString(9, tour.getStatus().name());
            pstmt.setLong(10, tour.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật tour ID: {}", tour.getId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM Tour WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi xóa tour ID: {}", id, e);
        }
        return false;
    }

    @Override
    public boolean updateStatus(Long id, Tour.Status status) {
        String sql = "UPDATE Tour SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status.name());
            pstmt.setLong(2, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật trạng thái tour ID: {}", id, e);
        }
        return false;
    }

    @Override
    public long count() {
        return executeCount("SELECT COUNT(*) FROM Tour");
    }

    @Override
    public long countActive() {
        return executeCount("SELECT COUNT(*) FROM Tour WHERE status = 'ACTIVE'");
    }

    private List<Tour> executeQuery(String sql) {
        List<Tour> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi thực thi query", e);
        }
        return list;
    }

    private long executeCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Lỗi đếm", e);
        }
        return 0;
    }

    private Tour mapResultSetToEntity(ResultSet rs) throws SQLException {
        Tour tour = new Tour();
        tour.setId(rs.getLong("id"));
        tour.setMatour(rs.getString("matour"));
        tour.setTentour(rs.getString("tentour"));
        tour.setDiadiem(rs.getString("diadiem"));
        tour.setThoiluong(rs.getString("thoiluong"));
        tour.setGia(rs.getBigDecimal("gia"));
        tour.setMota(rs.getString("mota"));
        tour.setHinhanh(rs.getString("hinhanh"));
        
        Date ngaykhoihanh = rs.getDate("ngaykhoihanh");
        if (ngaykhoihanh != null) {
            tour.setNgaykhoihanh(ngaykhoihanh.toLocalDate());
        }
        
        tour.setPhuongtienchinh(rs.getString("phuongtienchinh"));

        String status = null;
        try {
            status = rs.getString("status");
        } catch (SQLException e) {

        }
        if (status == null || status.isBlank()) {
            tour.setStatus(Tour.Status.ACTIVE);
        } else {
            try {
                tour.setStatus(Tour.Status.valueOf(status));
            } catch (IllegalArgumentException ex) {
                tour.setStatus(Tour.Status.ACTIVE);
            }
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            tour.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            tour.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return tour;
    }
}



