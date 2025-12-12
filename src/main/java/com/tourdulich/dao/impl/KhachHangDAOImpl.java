package com.tourdulich.dao.impl;

import com.tourdulich.dao.KhachHangDAO;
import com.tourdulich.model.KhachHang;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class KhachHangDAOImpl implements KhachHangDAO {
    private static final Logger logger = LoggerFactory.getLogger(KhachHangDAOImpl.class);

    @Override
    public Optional<KhachHang> findById(Long id) {
        String sql = "SELECT * FROM KhachHang WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm khách hàng theo ID: {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<KhachHang> findByNguoiDungId(Long nguoidungId) {
        String sql = "SELECT * FROM KhachHang WHERE nguoidung_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, nguoidungId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm khách hàng theo nguoidung_id: {}", nguoidungId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<KhachHang> findAll() {
        String sql = "SELECT * FROM KhachHang ORDER BY id DESC";
        List<KhachHang> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy danh sách khách hàng", e);
        }
        return list;
    }

    @Override
    public Long save(KhachHang khachHang) {
        String sql = "INSERT INTO KhachHang (makhachhang, nguoidung_id, diachi, attribute1) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, khachHang.getMakhachhang());
            pstmt.setLong(2, khachHang.getNguoidungId());
            pstmt.setString(3, khachHang.getDiachi());
            pstmt.setString(4, khachHang.getAttribute1());
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Lỗi thêm khách hàng", e);
        }
        return null;
    }

    @Override
    public boolean update(KhachHang khachHang) {
        String sql = "UPDATE KhachHang SET diachi = ?, attribute1 = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, khachHang.getDiachi());
            pstmt.setString(2, khachHang.getAttribute1());
            pstmt.setLong(3, khachHang.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật khách hàng ID: {}", khachHang.getId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM KhachHang WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi xóa khách hàng ID: {}", id, e);
        }
        return false;
    }

    private KhachHang mapResultSetToEntity(ResultSet rs) throws SQLException {
        KhachHang khachHang = new KhachHang();
        khachHang.setId(rs.getLong("id"));
        khachHang.setMakhachhang(rs.getString("makhachhang"));
        khachHang.setNguoidungId(rs.getLong("nguoidung_id"));
        khachHang.setDiachi(rs.getString("diachi"));
        khachHang.setAttribute1(rs.getString("attribute1"));
        return khachHang;
    }
}



