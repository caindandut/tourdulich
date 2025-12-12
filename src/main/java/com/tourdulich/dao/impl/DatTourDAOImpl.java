package com.tourdulich.dao.impl;

import com.tourdulich.dao.DatTourDAO;
import com.tourdulich.model.DatTour;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DatTourDAOImpl implements DatTourDAO {
    private static final Logger logger = LoggerFactory.getLogger(DatTourDAOImpl.class);

    @Override
    public Optional<DatTour> findById(Long id) {
        String sql = "SELECT * FROM DatTour WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm đặt tour theo ID: {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<DatTour> findAll() {
        String sql = "SELECT * FROM DatTour ORDER BY created_at DESC";
        List<DatTour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy tất cả đặt tour", e);
        }
        return list;
    }

    @Override
    public List<DatTour> findByKhachHangId(Long khachhangId) {
        String sql = "SELECT * FROM DatTour WHERE khachhang_id = ? ORDER BY created_at DESC";
        List<DatTour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, khachhangId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy đặt tour theo khách hàng: {}", khachhangId, e);
        }
        return list;
    }

    @Override
    public Long save(DatTour datTour) {
        logger.info("=== DatTourDAOImpl.save() STARTED ===");
        logger.info("Input: MaDatTour={}, KhachHangID={}, TourID={}, SoLuong={}, TongTien={}, NgayKhoihanh={}", 
            datTour.getMadattour(), datTour.getKhachhangId(), datTour.getTourId(), 
            datTour.getSoLuongNguoi(), datTour.getTongtien(), datTour.getNgayKhoihanh());
        
        String sql = "INSERT INTO DatTour (madattour, khachhang_id, tour_id, so_luong_nguoi, tongtien, ngay_khoihanh, ghichu, tinhtrang) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        logger.info("SQL: {}", sql);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            logger.info("Connection established successfully");
            
            pstmt.setString(1, datTour.getMadattour());
            pstmt.setLong(2, datTour.getKhachhangId());
            pstmt.setLong(3, datTour.getTourId());
            pstmt.setInt(4, datTour.getSoLuongNguoi());
            pstmt.setBigDecimal(5, datTour.getTongtien());
            
            if (datTour.getNgayKhoihanh() != null) {
                pstmt.setTimestamp(6, Timestamp.valueOf(datTour.getNgayKhoihanh()));
                logger.info("NgayKhoihanh set: {}", Timestamp.valueOf(datTour.getNgayKhoihanh()));
            } else {
                pstmt.setNull(6, Types.TIMESTAMP);
                logger.info("NgayKhoihanh set to NULL");
            }
            
            pstmt.setString(7, datTour.getGhichu());
            pstmt.setString(8, datTour.getTinhtrang() != null ? datTour.getTinhtrang().name() : "PENDING");
            
            logger.info("Executing INSERT query...");
            int affected = pstmt.executeUpdate();
            logger.info("Rows affected: {}", affected);
            
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    Long generatedId = rs.getLong(1);
                    logger.info("✅ INSERT THÀNH CÔNG! Generated ID: {}", generatedId);
                    return generatedId;
                } else {
                    logger.error("❌ Không lấy được generated key!");
                }
            } else {
                logger.error("❌ Không có row nào bị affected!");
            }
        } catch (SQLException e) {
            logger.error("❌ SQLException khi thêm đặt tour:", e);
            logger.error("SQL State: {}", e.getSQLState());
            logger.error("Error Code: {}", e.getErrorCode());
            logger.error("Message: {}", e.getMessage());
        } catch (Exception e) {
            logger.error("❌ Exception khác khi thêm đặt tour:", e);
        }
        
        logger.error("=== DatTourDAOImpl.save() FAILED - returning NULL ===");
        return null;
    }

    @Override
    public boolean update(DatTour datTour) {
        String sql = "UPDATE DatTour SET tinhtrang = ?, ngay_khoihanh = ?, ghichu = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, datTour.getTinhtrang().name());
            
            if (datTour.getNgayKhoihanh() != null) {
                pstmt.setTimestamp(2, Timestamp.valueOf(datTour.getNgayKhoihanh()));
            } else {
                pstmt.setNull(2, Types.TIMESTAMP);
            }
            
            pstmt.setString(3, datTour.getGhichu());
            pstmt.setLong(4, datTour.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật đặt tour ID: {}", datTour.getId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM DatTour WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi xóa đặt tour ID: {}", id, e);
        }
        return false;
    }

    @Override
    public Optional<DatTour> findByMaDatTour(String madattour) {
        String sql = "SELECT * FROM DatTour WHERE madattour = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, madattour);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm đặt tour theo mã: {}", madattour, e);
        }
        return Optional.empty();
    }

    @Override
    public List<DatTour> findByTrangThai(DatTour.TinhTrang tinhtrang) {
        String sql = "SELECT * FROM DatTour WHERE tinhtrang = ? ORDER BY created_at DESC";
        List<DatTour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tinhtrang.name());
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy đặt tour theo tình trạng: {}", tinhtrang, e);
        }
        return list;
    }

    @Override
    public List<DatTour> findByKhachHangIdAndTrangThai(Long khachhangId, DatTour.TinhTrang tinhtrang) {
        String sql = "SELECT * FROM DatTour WHERE khachhang_id = ? AND tinhtrang = ? ORDER BY created_at DESC";
        List<DatTour> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, khachhangId);
            pstmt.setString(2, tinhtrang.name());
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy đặt tour theo khách hàng và tình trạng", e);
        }
        return list;
    }

    @Override
    public boolean updateTrangThai(Long id, DatTour.TinhTrang tinhtrang) {
        String sql = "UPDATE DatTour SET tinhtrang = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tinhtrang.name());
            pstmt.setLong(2, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật tình trạng đặt tour ID: {}", id, e);
        }
        return false;
    }

    @Override
    public boolean updateDaThanhToan(Long id, Boolean dathanhtoan) {
        String sql = "UPDATE DatTour SET dathanhtoan = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, dathanhtoan != null ? dathanhtoan : false);
            pstmt.setLong(2, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật trạng thái thanh toán đặt tour ID: {}", id, e);
        }
        return false;
    }

    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM DatTour";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Lỗi đếm đặt tour", e);
        }
        return 0;
    }

    @Override
    public long countByTrangThai(DatTour.TinhTrang tinhtrang) {
        String sql = "SELECT COUNT(*) FROM DatTour WHERE tinhtrang = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tinhtrang.name());
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Lỗi đếm đặt tour theo tình trạng: {}", tinhtrang, e);
        }
        return 0;
    }
    
    @Override
    public java.math.BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(tongtien), 0) FROM DatTour WHERE dathanhtoan = true";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            logger.error("Lỗi tính doanh thu", e);
        }
        return java.math.BigDecimal.ZERO;
    }

    private DatTour mapResultSetToEntity(ResultSet rs) throws SQLException {
        DatTour datTour = new DatTour();
        datTour.setId(rs.getLong("id"));
        datTour.setMadattour(rs.getString("madattour"));
        datTour.setKhachhangId(rs.getLong("khachhang_id"));
        datTour.setTourId(rs.getLong("tour_id"));
        datTour.setSoLuongNguoi(rs.getInt("so_luong_nguoi"));
        datTour.setTongtien(rs.getBigDecimal("tongtien"));
        
        Timestamp ngayKhoihanh = rs.getTimestamp("ngay_khoihanh");
        if (ngayKhoihanh != null) {
            datTour.setNgayKhoihanh(ngayKhoihanh.toLocalDateTime());
        }
        
        datTour.setGhichu(rs.getString("ghichu"));
        
        String tinhTrangStr = rs.getString("tinhtrang");
        if (tinhTrangStr != null) {
            datTour.setTinhtrang(DatTour.TinhTrang.valueOf(tinhTrangStr));
        }
        

        try {
            Boolean dathanhtoan = rs.getBoolean("dathanhtoan");
            if (!rs.wasNull()) {
                datTour.setDathanhtoan(dathanhtoan);
            }
        } catch (SQLException e) {

            datTour.setDathanhtoan(false);
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            datTour.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            datTour.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return datTour;
    }
}

