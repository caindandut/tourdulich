package com.tourdulich.model;

import java.time.LocalDateTime;

public class DanhGia {
    private Long id;
    private String madanhgia;
    private Long khachhangId;
    private Long tourId;
    private String noidung;
    private Integer rating;
    private TrangThai trangthai;
    private LocalDateTime thoigian;
    

    private KhachHang khachHang;
    private Tour tour;
    
    public enum TrangThai {
        HIEN_THI,
        AN
    }


    public DanhGia() {
        this.trangthai = TrangThai.HIEN_THI;
    }

    public DanhGia(Long khachhangId, Long tourId, String noidung) {
        this.khachhangId = khachhangId;
        this.tourId = tourId;
        this.noidung = noidung;
        this.thoigian = LocalDateTime.now();
        this.trangthai = TrangThai.HIEN_THI;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMadanhgia() {
        return madanhgia;
    }

    public void setMadanhgia(String madanhgia) {
        this.madanhgia = madanhgia;
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

    public String getNoidung() {
        return noidung;
    }

    public void setNoidung(String noidung) {
        this.noidung = noidung;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public TrangThai getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(TrangThai trangthai) {
        this.trangthai = trangthai;
    }

    public LocalDateTime getThoigian() {
        return thoigian;
    }

    public void setThoigian(LocalDateTime thoigian) {
        this.thoigian = thoigian;
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

    @Override
    public String toString() {
        return "DanhGia{" +
                "id=" + id +
                ", madanhgia='" + madanhgia + '\'' +
                ", khachhangId=" + khachhangId +
                ", tourId=" + tourId +
                ", trangthai=" + trangthai +
                ", thoigian=" + thoigian +
                '}';
    }
}
