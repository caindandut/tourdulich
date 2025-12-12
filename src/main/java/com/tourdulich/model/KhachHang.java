package com.tourdulich.model;

public class KhachHang {
    private Long id;
    private String makhachhang;
    private Long nguoidungId;
    private String diachi;
    private String attribute1;
    

    private NguoiDung nguoiDung;


    public KhachHang() {
    }

    public KhachHang(Long nguoidungId, String diachi) {
        this.nguoidungId = nguoidungId;
        this.diachi = diachi;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMakhachhang() {
        return makhachhang;
    }

    public void setMakhachhang(String makhachhang) {
        this.makhachhang = makhachhang;
    }

    public Long getNguoidungId() {
        return nguoidungId;
    }

    public void setNguoidungId(Long nguoidungId) {
        this.nguoidungId = nguoidungId;
    }

    public String getDiachi() {
        return diachi;
    }

    public void setDiachi(String diachi) {
        this.diachi = diachi;
    }

    public String getAttribute1() {
        return attribute1;
    }

    public void setAttribute1(String attribute1) {
        this.attribute1 = attribute1;
    }

    public NguoiDung getNguoiDung() {
        return nguoiDung;
    }

    public void setNguoiDung(NguoiDung nguoiDung) {
        this.nguoiDung = nguoiDung;
    }

    @Override
    public String toString() {
        return "KhachHang{" +
                "id=" + id +
                ", makhachhang='" + makhachhang + '\'' +
                ", nguoidungId=" + nguoidungId +
                ", diachi='" + diachi + '\'' +
                '}';
    }
}



