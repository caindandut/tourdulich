package com.tourdulich.model;

import java.time.LocalDateTime;

public class NguoiDung {
    private Long id;
    private String manguoidung;
    private String tendangnhap;
    private String matkhau;
    private String hotennguoidung;
    private String email;
    private String sdt;
    private Role role;
    private Status status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum Role {
        ADMIN, USER, CUSTOMER
    }

    public enum Status {
        ACTIVE, LOCKED
    }


    public NguoiDung() {
    }

    public NguoiDung(String tendangnhap, String matkhau, String hotennguoidung, String email, String sdt, Role role) {
        this.tendangnhap = tendangnhap;
        this.matkhau = matkhau;
        this.hotennguoidung = hotennguoidung;
        this.email = email;
        this.sdt = sdt;
        this.role = role;
        this.status = Status.ACTIVE;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getManguoidung() {
        return manguoidung;
    }

    public void setManguoidung(String manguoidung) {
        this.manguoidung = manguoidung;
    }

    public String getTendangnhap() {
        return tendangnhap;
    }

    public void setTendangnhap(String tendangnhap) {
        this.tendangnhap = tendangnhap;
    }

    public String getMatkhau() {
        return matkhau;
    }

    public void setMatkhau(String matkhau) {
        this.matkhau = matkhau;
    }

    public String getHotennguoidung() {
        return hotennguoidung;
    }

    public void setHotennguoidung(String hotennguoidung) {
        this.hotennguoidung = hotennguoidung;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
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
        return "NguoiDung{" +
                "id=" + id +
                ", manguoidung='" + manguoidung + '\'' +
                ", tendangnhap='" + tendangnhap + '\'' +
                ", hotennguoidung='" + hotennguoidung + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                ", status=" + status +
                '}';
    }
}

