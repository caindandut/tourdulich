package com.tourdulich.model;

public class PhuongTien {
    private Long id;
    private String maphuongtien;
    private String tenphuongtien;
    private Integer sochongoi;


    public PhuongTien() {
    }

    public PhuongTien(String maphuongtien, String tenphuongtien, Integer sochongoi) {
        this.maphuongtien = maphuongtien;
        this.tenphuongtien = tenphuongtien;
        this.sochongoi = sochongoi;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMaphuongtien() {
        return maphuongtien;
    }

    public void setMaphuongtien(String maphuongtien) {
        this.maphuongtien = maphuongtien;
    }

    public String getTenphuongtien() {
        return tenphuongtien;
    }

    public void setTenphuongtien(String tenphuongtien) {
        this.tenphuongtien = tenphuongtien;
    }

    public Integer getSochongoi() {
        return sochongoi;
    }

    public void setSochongoi(Integer sochongoi) {
        this.sochongoi = sochongoi;
    }

    @Override
    public String toString() {
        return "PhuongTien{" +
                "id=" + id +
                ", maphuongtien='" + maphuongtien + '\'' +
                ", tenphuongtien='" + tenphuongtien + '\'' +
                ", sochongoi=" + sochongoi +
                '}';
    }
}



