package com.tourdulich.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ChiTietDatTour {
    private Long id;
    private Long dattourId;
    private Long tourId;
    private String tentour;
    private String tenkhachhang;
    private LocalDate ngaykhoihanh;
    private BigDecimal giatour;
    private Integer soluong;
    private BigDecimal thanhtien;
    

    private Tour tour;


    public ChiTietDatTour() {
    }

    public ChiTietDatTour(Long dattourId, Long tourId, String tentour, String tenkhachhang, 
                          LocalDate ngaykhoihanh, BigDecimal giatour, Integer soluong, BigDecimal thanhtien) {
        this.dattourId = dattourId;
        this.tourId = tourId;
        this.tentour = tentour;
        this.tenkhachhang = tenkhachhang;
        this.ngaykhoihanh = ngaykhoihanh;
        this.giatour = giatour;
        this.soluong = soluong;
        this.thanhtien = thanhtien;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getDattourId() {
        return dattourId;
    }

    public void setDattourId(Long dattourId) {
        this.dattourId = dattourId;
    }

    public Long getTourId() {
        return tourId;
    }

    public void setTourId(Long tourId) {
        this.tourId = tourId;
    }

    public String getTentour() {
        return tentour;
    }

    public void setTentour(String tentour) {
        this.tentour = tentour;
    }

    public String getTenkhachhang() {
        return tenkhachhang;
    }

    public void setTenkhachhang(String tenkhachhang) {
        this.tenkhachhang = tenkhachhang;
    }

    public LocalDate getNgaykhoihanh() {
        return ngaykhoihanh;
    }

    public void setNgaykhoihanh(LocalDate ngaykhoihanh) {
        this.ngaykhoihanh = ngaykhoihanh;
    }

    public BigDecimal getGiatour() {
        return giatour;
    }

    public void setGiatour(BigDecimal giatour) {
        this.giatour = giatour;
    }

    public Integer getSoluong() {
        return soluong;
    }

    public void setSoluong(Integer soluong) {
        this.soluong = soluong;
    }

    public BigDecimal getThanhtien() {
        return thanhtien;
    }

    public void setThanhtien(BigDecimal thanhtien) {
        this.thanhtien = thanhtien;
    }

    public Tour getTour() {
        return tour;
    }

    public void setTour(Tour tour) {
        this.tour = tour;
    }

    @Override
    public String toString() {
        return "ChiTietDatTour{" +
                "id=" + id +
                ", dattourId=" + dattourId +
                ", tourId=" + tourId +
                ", tentour='" + tentour + '\'' +
                ", soluong=" + soluong +
                ", thanhtien=" + thanhtien +
                '}';
    }
}



