package com.tourdulich.dao.impl;

import com.tourdulich.dao.NguoiDungDAO;
import com.tourdulich.model.NguoiDung;
import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class NguoiDungDAOImpl implements NguoiDungDAO {
    private static final Logger logger = LoggerFactory.getLogger(NguoiDungDAOImpl.class);

    @Override
    public Optional<NguoiDung> findById(Long id) {
        String sql = "SELECT * FROM NguoiDung WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm người dùng theo ID: {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<NguoiDung> findByUsername(String tendangnhap) {
        String sql = "SELECT * FROM NguoiDung WHERE tendangnhap = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tendangnhap);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm người dùng theo username: {}", tendangnhap, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<NguoiDung> findByEmail(String email) {
        String sql = "SELECT * FROM NguoiDung WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi tìm người dùng theo email: {}", email, e);
        }
        return Optional.empty();
    }

    @Override
    public List<NguoiDung> findAll() {
        String sql = "SELECT * FROM NguoiDung ORDER BY created_at DESC";
        List<NguoiDung> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy danh sách người dùng", e);
        }
        return list;
    }

    @Override
    public List<NguoiDung> findByRole(NguoiDung.Role role) {
        String sql = "SELECT * FROM NguoiDung WHERE role = ? ORDER BY created_at DESC";
        List<NguoiDung> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, role.name());
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Lỗi lấy danh sách người dùng theo role: {}", role, e);
        }
        return list;
    }

    @Override
    public Long save(NguoiDung nguoiDung) {
        String sql = "INSERT INTO NguoiDung (manguoidung, tendangnhap, matkhau, hotennguoidung, email, sdt, role, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, nguoiDung.getManguoidung());
            pstmt.setString(2, nguoiDung.getTendangnhap());
            pstmt.setString(3, nguoiDung.getMatkhau());
            pstmt.setString(4, nguoiDung.getHotennguoidung());
            pstmt.setString(5, nguoiDung.getEmail());
            pstmt.setString(6, nguoiDung.getSdt());
            pstmt.setString(7, nguoiDung.getRole().name());
            pstmt.setString(8, nguoiDung.getStatus().name());
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Lỗi thêm người dùng", e);
        }
        return null;
    }

    @Override
    public boolean update(NguoiDung nguoiDung) {
        String sql = "UPDATE NguoiDung SET hotennguoidung = ?, email = ?, sdt = ?, role = ?, status = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, nguoiDung.getHotennguoidung());
            pstmt.setString(2, nguoiDung.getEmail());
            pstmt.setString(3, nguoiDung.getSdt());
            pstmt.setString(4, nguoiDung.getRole().name());
            pstmt.setString(5, nguoiDung.getStatus().name());
            pstmt.setLong(6, nguoiDung.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật người dùng ID: {}", nguoiDung.getId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM NguoiDung WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi xóa người dùng ID: {}", id, e);
        }
        return false;
    }

    @Override
    public boolean updateStatus(Long id, NguoiDung.Status status) {
        String sql = "UPDATE NguoiDung SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status.name());
            pstmt.setLong(2, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Lỗi cập nhật trạng thái người dùng ID: {}", id, e);
        }
        return false;
    }

    @Override
    public boolean existsByUsername(String tendangnhap) {
        String sql = "SELECT COUNT(*) FROM NguoiDung WHERE tendangnhap = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, tendangnhap);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.error("Lỗi kiểm tra tồn tại username: {}", tendangnhap, e);
        }
        return false;
    }

    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM NguoiDung WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.error("Lỗi kiểm tra tồn tại email: {}", email, e);
        }
        return false;
    }

    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM NguoiDung";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            logger.error("Lỗi đếm người dùng", e);
        }
        return 0;
    }

    private NguoiDung mapResultSetToEntity(ResultSet rs) throws SQLException {
        NguoiDung nguoiDung = new NguoiDung();
        nguoiDung.setId(rs.getLong("id"));
        nguoiDung.setManguoidung(rs.getString("manguoidung"));
        nguoiDung.setTendangnhap(rs.getString("tendangnhap"));
        nguoiDung.setMatkhau(rs.getString("matkhau"));
        nguoiDung.setHotennguoidung(rs.getString("hotennguoidung"));
        nguoiDung.setEmail(rs.getString("email"));
        nguoiDung.setSdt(rs.getString("sdt"));
        nguoiDung.setRole(NguoiDung.Role.valueOf(rs.getString("role")));
        nguoiDung.setStatus(NguoiDung.Status.valueOf(rs.getString("status")));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            nguoiDung.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            nguoiDung.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return nguoiDung;
    }
}



