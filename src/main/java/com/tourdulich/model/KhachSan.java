package com.tourdulich.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class KhachSan {
    private Long id;
    private String makhachsan;
    private String tenkhachsan;
    private BigDecimal gia;
    private String diachi;
    private String chatluong;
    private String hinhanh;
    private TrangThai trangthai;
    private LocalDate ngayden;
    
    public enum TrangThai {
        CON_PHONG,
        HET_PHONG
    }


    public KhachSan() {
        this.trangthai = TrangThai.CON_PHONG;
    }

    public KhachSan(String makhachsan, String tenkhachsan, BigDecimal gia, String diachi, String chatluong) {
        this.makhachsan = makhachsan;
        this.tenkhachsan = tenkhachsan;
        this.gia = gia;
        this.diachi = diachi;
        this.chatluong = chatluong;
        this.trangthai = TrangThai.CON_PHONG;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMakhachsan() {
        return makhachsan;
    }

    public void setMakhachsan(String makhachsan) {
        this.makhachsan = makhachsan;
    }

    public String getTenkhachsan() {
        return tenkhachsan;
    }

    public void setTenkhachsan(String tenkhachsan) {
        this.tenkhachsan = tenkhachsan;
    }

    public BigDecimal getGia() {
        return gia;
    }

    public void setGia(BigDecimal gia) {
        this.gia = gia;
    }

    public String getDiachi() {
        return diachi;
    }

    public void setDiachi(String diachi) {
        this.diachi = diachi;
    }

    public String getChatluong() {
        return chatluong;
    }

    public void setChatluong(String chatluong) {
        this.chatluong = chatluong;
    }

    public String getHinhanh() {
        return hinhanh;
    }

    public void setHinhanh(String hinhanh) {
        this.hinhanh = hinhanh;
    }

    public TrangThai getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(TrangThai trangthai) {
        this.trangthai = trangthai;
    }

    public LocalDate getNgayden() {
        return ngayden;
    }

    public void setNgayden(LocalDate ngayden) {
        this.ngayden = ngayden;
    }

    @Override
    public String toString() {
        return "KhachSan{" +
                "id=" + id +
                ", makhachsan='" + makhachsan + '\'' +
                ", tenkhachsan='" + tenkhachsan + '\'' +
                ", chatluong='" + chatluong + '\'' +
                ", trangthai=" + trangthai +
                ", gia=" + gia +
                '}';
    }
}
