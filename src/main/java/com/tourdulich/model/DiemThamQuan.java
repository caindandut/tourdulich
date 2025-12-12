package com.tourdulich.model;

public class DiemThamQuan {
    private Long id;
    private String madiadiem;
    private String tendiadiem;
    private String mota;


    public DiemThamQuan() {
    }

    public DiemThamQuan(String madiadiem, String tendiadiem, String mota) {
        this.madiadiem = madiadiem;
        this.tendiadiem = tendiadiem;
        this.mota = mota;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMadiadiem() {
        return madiadiem;
    }

    public void setMadiadiem(String madiadiem) {
        this.madiadiem = madiadiem;
    }

    public String getTendiadiem() {
        return tendiadiem;
    }

    public void setTendiadiem(String tendiadiem) {
        this.tendiadiem = tendiadiem;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    @Override
    public String toString() {
        return "DiemThamQuan{" +
                "id=" + id +
                ", madiadiem='" + madiadiem + '\'' +
                ", tendiadiem='" + tendiadiem + '\'' +
                '}';
    }
}



