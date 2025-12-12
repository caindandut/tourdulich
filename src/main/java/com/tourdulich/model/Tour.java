package com.tourdulich.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Tour {
    private Long id;
    private String matour;
    private String tentour;
    private String diadiem;
    private String thoiluong;
    private BigDecimal gia;
    private String mota;
    private String hinhanh;
    private LocalDate ngaykhoihanh;
    private String phuongtienchinh;
    private Status status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum Status {
        ACTIVE, INACTIVE
    }

    public Tour() {
    }

    public Tour(String matour, String tentour, String diadiem, String thoiluong, BigDecimal gia) {
        this.matour = matour;
        this.tentour = tentour;
        this.diadiem = diadiem;
        this.thoiluong = thoiluong;
        this.gia = gia;
        this.status = Status.ACTIVE;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMatour() {
        return matour;
    }

    public void setMatour(String matour) {
        this.matour = matour;
    }

    public String getTentour() {
        return tentour;
    }

    public void setTentour(String tentour) {
        this.tentour = tentour;
    }

    public String getDiadiem() {
        return diadiem;
    }

    public void setDiadiem(String diadiem) {
        this.diadiem = diadiem;
    }

    public String getThoiluong() {
        return thoiluong;
    }

    public void setThoiluong(String thoiluong) {
        this.thoiluong = thoiluong;
    }

    public BigDecimal getGia() {
        return gia;
    }

    public void setGia(BigDecimal gia) {
        this.gia = gia;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    public String getHinhanh() {
        return hinhanh;
    }

    public void setHinhanh(String hinhanh) {
        this.hinhanh = hinhanh;
    }

    public LocalDate getNgaykhoihanh() {
        return ngaykhoihanh;
    }

    public void setNgaykhoihanh(LocalDate ngaykhoihanh) {
        this.ngaykhoihanh = ngaykhoihanh;
    }

    public String getPhuongtienchinh() {
        return phuongtienchinh;
    }

    public void setPhuongtienchinh(String phuongtienchinh) {
        this.phuongtienchinh = phuongtienchinh;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
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

    @Override
    public String toString() {
        return "Tour{" +
                "id=" + id +
                ", matour='" + matour + '\'' +
                ", tentour='" + tentour + '\'' +
                ", diadiem='" + diadiem + '\'' +
                ", gia=" + gia +
                ", status=" + status +
                '}';
    }
}



