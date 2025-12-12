package com.tourdulich.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class DatTour {
    private Long id;
    private String madattour;
    private Long khachhangId;
    private Long tourId;
    private int soLuongNguoi;
    private BigDecimal tongtien;
    private LocalDateTime ngayKhoihanh;
    private String ghichu;
    private String pttt;
    private TinhTrang tinhtrang;
    private Boolean dathanhtoan;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    

    private KhachHang khachHang;
    private Tour tour;
    private LocalDateTime ngaydat;

    public enum TinhTrang {
        PENDING, CONFIRMED, CANCELLED
    }


    public DatTour() {
    }

    public DatTour(Long khachhangId, BigDecimal tongtien, LocalDateTime ngaykhoihanh, String pttt) {
        this.khachhangId = khachhangId;
        this.tongtien = tongtien;
        this.ngayKhoihanh = ngaykhoihanh;
        this.pttt = pttt;
        this.tinhtrang = TinhTrang.PENDING;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMadattour() {
        return madattour;
    }

    public void setMadattour(String madattour) {
        this.madattour = madattour;
    }

    public Long getKhachhangId() {
        return khachhangId;
    }

    public void setKhachhangId(Long khachhangId) {
        this.khachhangId = khachhangId;
    }

    public Long getTourId() {
        return tourId;
    }

    public void setTourId(Long tourId) {
        this.tourId = tourId;
    }

    public int getSoLuongNguoi() {
        return soLuongNguoi;
    }

    public void setSoLuongNguoi(int soLuongNguoi) {
        this.soLuongNguoi = soLuongNguoi;
    }

    public BigDecimal getTongtien() {
        return tongtien;
    }

    public void setTongtien(BigDecimal tongtien) {
        this.tongtien = tongtien;
    }

    public LocalDateTime getNgayKhoihanh() {
        return ngayKhoihanh;
    }

    public void setNgayKhoihanh(LocalDateTime ngayKhoihanh) {
        this.ngayKhoihanh = ngayKhoihanh;
    }

    public String getGhichu() {
        return ghichu;
    }

    public void setGhichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public String getPttt() {
        return pttt;
    }

    public void setPttt(String pttt) {
        this.pttt = pttt;
    }

    public Boolean getDathanhtoan() {
        return dathanhtoan != null ? dathanhtoan : false;
    }

    public void setDathanhtoan(Boolean dathanhtoan) {
        this.dathanhtoan = dathanhtoan;
    }

    public TinhTrang getTinhtrang() {
        return tinhtrang;
    }

    public void setTinhtrang(TinhTrang tinhtrang) {
        this.tinhtrang = tinhtrang;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public KhachHang getKhachHang() {
        return khachHang;
    }

    public void setKhachHang(KhachHang khachHang) {
        this.khachHang = khachHang;
    }
    
    public Tour getTour() {
        return tour;
    }
    
    public void setTour(Tour tour) {
        this.tour = tour;
    }
    
    public LocalDateTime getNgaydat() {
        return ngaydat;
    }
    
    public void setNgaydat(LocalDateTime ngaydat) {
        this.ngaydat = ngaydat;
    }

    @Override
    public String toString() {
        return "DatTour{" +
                "id=" + id +
                ", madattour='" + madattour + '\'' +
                ", khachhangId=" + khachhangId +
                ", tongtien=" + tongtien +
                ", tinhtrang=" + tinhtrang +
                ", createdAt=" + createdAt +
                '}';
    }
}

