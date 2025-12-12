package com.tourdulich.service.impl;

import com.tourdulich.dao.ChiTietDatTourDAO;
import com.tourdulich.dao.DatTourDAO;
import com.tourdulich.dao.impl.ChiTietDatTourDAOImpl;
import com.tourdulich.dao.impl.DatTourDAOImpl;
import com.tourdulich.model.ChiTietDatTour;
import com.tourdulich.model.DatTour;
import com.tourdulich.model.Tour;
import com.tourdulich.service.BookingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class BookingServiceImpl implements BookingService {
    
    private static final Logger logger = LoggerFactory.getLogger(BookingServiceImpl.class);
    
    private final DatTourDAO datTourDAO = new DatTourDAOImpl();
    private final ChiTietDatTourDAO chiTietDAO = new ChiTietDatTourDAOImpl();
    
    @Override
    public Long createBooking(DatTour datTour, Tour tour) {
        logger.info("=== BookingServiceImpl.createBooking() STARTED ===");
        logger.info("Input DatTour: KhachHangID={}, TourID={}, SoLuong={}, TongTien={}", 
            datTour.getKhachhangId(), datTour.getTourId(), datTour.getSoLuongNguoi(), datTour.getTongtien());
        logger.info("Input Tour: ID={}, Ten={}, Gia={}", tour.getId(), tour.getTentour(), tour.getGia());
        
        try {

            String madattour = "DT" + System.currentTimeMillis();
            datTour.setMadattour(madattour);
            logger.info("Generated MaDatTour: {}", madattour);
            

            logger.info("Đang gọi datTourDAO.save()...");
            Long bookingId = datTourDAO.save(datTour);
            logger.info("datTourDAO.save() returned: {}", bookingId);
            
            if (bookingId != null) {
                logger.info("✅ BookingID được tạo: {}", bookingId);
                

                ChiTietDatTour chiTiet = new ChiTietDatTour();
                chiTiet.setDattourId(bookingId);
                chiTiet.setTourId(tour.getId());
                chiTiet.setTentour(tour.getTentour());
                chiTiet.setGiatour(tour.getGia());
                
                if (datTour.getNgayKhoihanh() != null) {
                    chiTiet.setNgaykhoihanh(datTour.getNgayKhoihanh().toLocalDate());
                }
                
                logger.info("Đang lưu ChiTietDatTour...");
                Long chiTietId = chiTietDAO.save(chiTiet);
                logger.info("ChiTietDatTour saved with ID: {}", chiTietId);
                
                logger.info("✅ Đã tạo đơn đặt tour THÀNH CÔNG: {} cho khách hàng: {}", madattour, datTour.getKhachhangId());
                return bookingId;
            } else {
                logger.error("❌ datTourDAO.save() trả về NULL! Không thể lưu DatTour!");
            }
            
        } catch (Exception e) {
            logger.error("❌ LỖI KHI TẠO ĐƠN ĐẶT TOUR:", e);
            logger.error("Exception class: {}", e.getClass().getName());
            logger.error("Exception message: {}", e.getMessage());
            e.printStackTrace();
        }
        
        logger.error("=== BookingServiceImpl.createBooking() FAILED ===");
        return null;
    }
    
    @Override
    public List<DatTour> getBookingsByKhachHang(Long khachhangId) {
        return datTourDAO.findByKhachHangId(khachhangId);
    }
    
    @Override
    public Optional<DatTour> getBookingById(Long id) {
        return datTourDAO.findById(id);
    }
    
    @Override
    public boolean cancelBooking(Long bookingId, Long khachhangId) {
        Optional<DatTour> bookingOpt = datTourDAO.findById(bookingId);
        
        if (bookingOpt.isPresent()) {
            DatTour booking = bookingOpt.get();
            

            if (!booking.getKhachhangId().equals(khachhangId)) {
                logger.warn("Khách hàng {} không có quyền hủy đơn {}", khachhangId, bookingId);
                return false;
            }
            

            if (booking.getTinhtrang() == DatTour.TinhTrang.PENDING) {
                booking.setTinhtrang(DatTour.TinhTrang.CANCELLED);
                return datTourDAO.update(booking);
            }
        }
        
        return false;
    }
    
    @Override
    public boolean confirmBooking(Long bookingId) {
        Optional<DatTour> bookingOpt = datTourDAO.findById(bookingId);
        
        if (bookingOpt.isPresent()) {
            DatTour booking = bookingOpt.get();
            
            if (booking.getTinhtrang() == DatTour.TinhTrang.PENDING) {
                booking.setTinhtrang(DatTour.TinhTrang.CONFIRMED);
                return datTourDAO.update(booking);
            }
        }
        
        return false;
    }
    
    @Override
    public List<DatTour> getAllBookings() {
        return datTourDAO.findAll();
    }
}

