# HƯỚNG DẪN CHỤP ẢNH MÀN HÌNH CHO BÁO CÁO

## 📋 MỤC LỤC
1. [Chuẩn bị](#chuẩn-bị)
2. [Chức năng người dùng (User)](#chức-năng-người-dùng-user)
3. [Chức năng quản trị viên (Admin)](#chức-năng-quản-trị-viên-admin)
4. [Mẹo chụp ảnh đẹp](#mẹo-chụp-ảnh-đẹp)

---

## 🔧 CHUẨN BỊ

### Bước 1: Khởi động ứng dụng
1. Đảm bảo database đã được cấu hình và chạy
2. Khởi động server (Tomcat) - ứng dụng chạy tại: `http://localhost:8080/tour-booking`
3. Mở trình duyệt và truy cập ứng dụng

### Bước 2: Chuẩn bị tài khoản
- **Tài khoản User**: Đăng ký một tài khoản người dùng thông thường
- **Tài khoản Admin**: Đảm bảo có tài khoản admin để test các chức năng quản trị

### Bước 3: Công cụ chụp ảnh
- Windows: Sử dụng `Win + Shift + S` (Snipping Tool) hoặc `Print Screen`
- Hoặc sử dụng phần mềm: Lightshot, Greenshot, ShareX

---

## 👤 CHỨC NĂNG NGƯỜI DÙNG (USER)

### 1. TRANG CHỦ (Home Page)
**URL**: `/home` hoặc `/`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Giao diện trang chủ tổng quan (header, banner, danh sách tour nổi bật)
- ✅ **Ảnh 2**: Phần hiển thị tour nổi bật (6 tour mới nhất)
- ✅ **Ảnh 3**: Footer và thông tin liên hệ

**Cách chụp:**
1. Truy cập `http://localhost:8080/tour-booking/home`
2. Cuộn xuống để xem toàn bộ trang
3. Chụp từng phần hoặc chụp toàn màn hình

---

### 2. ĐĂNG KÝ (Register)
**URL**: `/register`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Form đăng ký trống (chưa nhập thông tin)
- ✅ **Ảnh 2**: Form đăng ký đã điền thông tin (trước khi submit)
- ✅ **Ảnh 3**: Thông báo lỗi (nếu có - ví dụ: email đã tồn tại)
- ✅ **Ảnh 4**: Thông báo đăng ký thành công (nếu có)

**Cách chụp:**
1. Click vào nút "Đăng ký" trên header
2. Chụp form đăng ký
3. Điền thông tin và chụp lại
4. Submit và chụp kết quả

---

### 3. ĐĂNG NHẬP (Login)
**URL**: `/login`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Form đăng nhập
- ✅ **Ảnh 2**: Đăng nhập với thông tin sai (hiển thị lỗi)
- ✅ **Ảnh 3**: Đăng nhập thành công (chuyển về trang chủ, hiển thị tên người dùng)

**Cách chụp:**
1. Click "Đăng nhập" trên header
2. Chụp form đăng nhập
3. Thử đăng nhập sai để chụp thông báo lỗi
4. Đăng nhập đúng và chụp kết quả

---

### 4. TÌM KIẾM VÀ XEM DANH SÁCH TOUR (Search/Tour Listing)
**URL**: `/search`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trang tìm kiếm tour (danh sách tất cả tour)
- ✅ **Ảnh 2**: Kết quả tìm kiếm theo từ khóa
- ✅ **Ảnh 3**: Kết quả tìm kiếm theo địa điểm
- ✅ **Ảnh 4**: Kết quả tìm kiếm không có tour nào (nếu có)

**Cách chụp:**
1. Click "Tour" trên menu hoặc truy cập `/search`
2. Chụp danh sách tour
3. Thử tìm kiếm với từ khóa và chụp kết quả
4. Thử tìm kiếm theo địa điểm và chụp kết quả

---

### 5. CHI TIẾT TOUR (Tour Detail)
**URL**: `/tour-detail?id={tour_id}`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trang chi tiết tour (thông tin tour, hình ảnh, giá)
- ✅ **Ảnh 2**: Phần mô tả tour (mô tả chi tiết, điểm tham quan)
- ✅ **Ảnh 3**: Phần đánh giá tour (nếu có)
- ✅ **Ảnh 4**: Nút "Đặt tour" và thông tin giá

**Cách chụp:**
1. Từ trang danh sách tour, click vào một tour
2. Chụp toàn bộ trang chi tiết
3. Cuộn xuống để chụp các phần khác nhau

---

### 6. ĐẶT TOUR (Booking)
**URL**: `/booking?tourId={tour_id}`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Form đặt tour (thông tin tour, form nhập thông tin)
- ✅ **Ảnh 2**: Form đã điền thông tin (số lượng người, thông tin liên hệ)
- ✅ **Ảnh 3**: Thông báo lỗi validation (nếu có)
- ✅ **Ảnh 4**: Xác nhận đặt tour (trước khi submit)

**Cách chụp:**
1. Từ trang chi tiết tour, click "Đặt tour"
2. Chụp form đặt tour
3. Điền thông tin và chụp lại
4. Submit và chụp kết quả

---

### 7. ĐẶT TOUR THÀNH CÔNG (Booking Success)
**URL**: `/booking-success`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trang thông báo đặt tour thành công
- ✅ **Ảnh 2**: Thông tin đơn đặt tour (mã đơn, thông tin tour, tổng tiền)

**Cách chụp:**
1. Sau khi đặt tour thành công, tự động chuyển đến trang này
2. Chụp toàn bộ trang thông báo

---

### 8. CHI TIẾT ĐƠN ĐẶT TOUR (Booking Detail)
**URL**: `/booking-detail?id={booking_id}`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trang chi tiết đơn đặt tour
- ✅ **Ảnh 2**: Thông tin đơn hàng (mã đơn, trạng thái, thông tin tour)
- ✅ **Ảnh 3**: Thông tin khách hàng và chi tiết thanh toán

**Cách chụp:**
1. Từ profile hoặc email xác nhận, click vào link chi tiết đơn
2. Chụp toàn bộ trang chi tiết

---

### 9. HỒ SƠ NGƯỜI DÙNG (Profile)
**URL**: `/profile`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trang profile (thông tin cá nhân)
- ✅ **Ảnh 2**: Danh sách đơn đặt tour của người dùng
- ✅ **Ảnh 3**: Form chỉnh sửa thông tin (nếu có)
- ✅ **Ảnh 4**: Sau khi cập nhật thông tin thành công

**Cách chụp:**
1. Click vào tên người dùng trên header
2. Chụp trang profile
3. Nếu có chức năng chỉnh sửa, chụp form và kết quả

---

### 10. ĐÁNH GIÁ TOUR (Review)
**URL**: `/review?tourId={tour_id}`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Form đánh giá tour
- ✅ **Ảnh 2**: Form đã điền đánh giá (sao, nội dung đánh giá)
- ✅ **Ảnh 3**: Thông báo gửi đánh giá thành công
- ✅ **Ảnh 4**: Đánh giá hiển thị trên trang chi tiết tour

**Cách chụp:**
1. Từ trang chi tiết tour hoặc profile, click "Đánh giá"
2. Chụp form đánh giá
3. Điền và submit, chụp kết quả
4. Quay lại trang chi tiết tour để chụp đánh giá đã hiển thị

---

### 11. ĐĂNG XUẤT (Logout)
**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trước khi đăng xuất (header hiển thị tên người dùng)
- ✅ **Ảnh 2**: Sau khi đăng xuất (header hiển thị nút Đăng nhập/Đăng ký)

**Cách chụp:**
1. Chụp header khi đã đăng nhập
2. Click "Đăng xuất"
3. Chụp header sau khi đăng xuất

---

## 👨‍💼 CHỨC NĂNG QUẢN TRỊ VIÊN (ADMIN)

**Lưu ý**: Cần đăng nhập bằng tài khoản ADMIN để truy cập các chức năng này.

### 1. DASHBOARD (Bảng điều khiển)
**URL**: `/admin/dashboard`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Trang dashboard tổng quan
- ✅ **Ảnh 2**: Thống kê tổng quan (số tour, số đơn đặt, số người dùng, doanh thu)
- ✅ **Ảnh 3**: Biểu đồ thống kê (nếu có)
- ✅ **Ảnh 4**: Danh sách đơn đặt mới nhất

**Cách chụp:**
1. Đăng nhập bằng tài khoản admin
2. Click "Quản trị" trên menu hoặc truy cập `/admin/dashboard`
3. Chụp toàn bộ dashboard
4. Cuộn xuống để chụp các phần khác nhau

---

### 2. QUẢN LÝ TOUR (Tour Management)
**URL**: `/admin/tours`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Danh sách tất cả tour
- ✅ **Ảnh 2**: Form thêm tour mới
- ✅ **Ảnh 3**: Form đã điền thông tin tour
- ✅ **Ảnh 4**: Thông báo thêm tour thành công
- ✅ **Ảnh 5**: Form chỉnh sửa tour
- ✅ **Ảnh 6**: Thông báo cập nhật tour thành công
- ✅ **Ảnh 7**: Xác nhận xóa tour
- ✅ **Ảnh 8**: Thông báo xóa tour thành công
- ✅ **Ảnh 9**: Tìm kiếm tour trong admin

**Cách chụp:**
1. Truy cập `/admin/tours`
2. Chụp danh sách tour
3. Click "Thêm tour mới", điền form và chụp
4. Submit và chụp kết quả
5. Click "Sửa" trên một tour, chụp form và kết quả
6. Click "Xóa" và chụp xác nhận + kết quả
7. Thử tìm kiếm tour và chụp kết quả

---

### 3. QUẢN LÝ ĐƠN ĐẶT TOUR (Booking Management)
**URL**: `/admin/bookings`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Danh sách tất cả đơn đặt tour
- ✅ **Ảnh 2**: Chi tiết một đơn đặt tour
- ✅ **Ảnh 3**: Form cập nhật trạng thái đơn (Đã xác nhận, Đã hủy, v.v.)
- ✅ **Ảnh 4**: Lọc đơn theo trạng thái
- ✅ **Ảnh 5**: Tìm kiếm đơn theo mã đơn hoặc tên khách hàng

**Cách chụp:**
1. Truy cập `/admin/bookings`
2. Chụp danh sách đơn đặt
3. Click vào một đơn để xem chi tiết và chụp
4. Thử cập nhật trạng thái và chụp kết quả
5. Thử lọc và tìm kiếm, chụp kết quả

---

### 4. QUẢN LÝ KHÁCH SẠN (Hotel Management)
**URL**: `/admin/hotels`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Danh sách tất cả khách sạn
- ✅ **Ảnh 2**: Form thêm khách sạn mới
- ✅ **Ảnh 3**: Form đã điền thông tin khách sạn
- ✅ **Ảnh 4**: Thông báo thêm khách sạn thành công
- ✅ **Ảnh 5**: Form chỉnh sửa khách sạn
- ✅ **Ảnh 6**: Thông báo cập nhật khách sạn thành công
- ✅ **Ảnh 7**: Xác nhận xóa khách sạn
- ✅ **Ảnh 8**: Tìm kiếm khách sạn

**Cách chụp:**
1. Truy cập `/admin/hotels`
2. Chụp danh sách khách sạn
3. Thực hiện các thao tác CRUD (Create, Read, Update, Delete) và chụp từng bước
4. Thử tìm kiếm và chụp kết quả

---

### 5. QUẢN LÝ NGƯỜI DÙNG (User Management)
**URL**: `/admin/users`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Danh sách tất cả người dùng
- ✅ **Ảnh 2**: Form thêm người dùng mới (nếu có)
- ✅ **Ảnh 3**: Form chỉnh sửa thông tin người dùng
- ✅ **Ảnh 4**: Thông báo cập nhật thành công
- ✅ **Ảnh 5**: Khóa/Mở khóa tài khoản người dùng
- ✅ **Ảnh 6**: Thay đổi quyền người dùng (USER/ADMIN)
- ✅ **Ảnh 7**: Tìm kiếm người dùng

**Cách chụp:**
1. Truy cập `/admin/users`
2. Chụp danh sách người dùng
3. Thực hiện các thao tác quản lý và chụp từng bước
4. Thử tìm kiếm và chụp kết quả

---

### 6. QUẢN LÝ ĐÁNH GIÁ (Review Management)
**URL**: `/admin/reviews`

**Các ảnh cần chụp:**
- ✅ **Ảnh 1**: Danh sách tất cả đánh giá
- ✅ **Ảnh 2**: Chi tiết một đánh giá
- ✅ **Ảnh 3**: Xóa đánh giá (xác nhận và kết quả)
- ✅ **Ảnh 4**: Duyệt/Ẩn đánh giá (nếu có)
- ✅ **Ảnh 5**: Lọc đánh giá theo tour
- ✅ **Ảnh 6**: Tìm kiếm đánh giá

**Cách chụp:**
1. Truy cập `/admin/reviews`
2. Chụp danh sách đánh giá
3. Click vào một đánh giá để xem chi tiết
4. Thử xóa, duyệt/ẩn đánh giá và chụp kết quả
5. Thử lọc và tìm kiếm, chụp kết quả

---

## 📸 MẸO CHỤP ẢNH ĐẸP

### 1. Chuẩn bị dữ liệu
- ✅ Đảm bảo có dữ liệu mẫu đầy đủ (tour, đơn đặt, người dùng, đánh giá)
- ✅ Dữ liệu nên có nội dung thực tế, không phải test data rỗng

### 2. Giao diện
- ✅ Sử dụng trình duyệt Chrome/Firefox với độ phân giải 1920x1080 hoặc cao hơn
- ✅ Ẩn thanh bookmark và toolbar để giao diện gọn gàng
- ✅ Đảm bảo cửa sổ trình duyệt đầy đủ, không bị thu nhỏ

### 3. Kỹ thuật chụp
- ✅ Chụp toàn màn hình cho các trang tổng quan
- ✅ Chụp từng phần cụ thể cho các form và thông báo
- ✅ Đảm bảo ảnh rõ nét, không bị mờ
- ✅ Chụp cả trạng thái trước và sau khi thực hiện hành động

### 4. Đặt tên file
- ✅ Đặt tên file theo quy tắc: `[Chức năng]_[Mô tả]_[Số thứ tự].png`
- ✅ Ví dụ: `01_TrangChu_TongQuan.png`, `02_DangKy_Form.png`, `03_Admin_Tour_DanhSach.png`

### 5. Tổ chức thư mục
```
📁 Screenshots/
  📁 01_User/
    📁 01_TrangChu/
    📁 02_DangKy/
    📁 03_DangNhap/
    📁 04_TimKiemTour/
    📁 05_ChiTietTour/
    📁 06_DatTour/
    📁 07_Profile/
    📁 08_DanhGia/
  📁 02_Admin/
    📁 01_Dashboard/
    📁 02_QuanLyTour/
    📁 03_QuanLyDonDat/
    📁 04_QuanLyKhachSan/
    📁 05_QuanLyNguoiDung/
    📁 06_QuanLyDanhGia/
```

---

## ✅ CHECKLIST HOÀN THÀNH

### Chức năng User
- [ ] Trang chủ
- [ ] Đăng ký
- [ ] Đăng nhập
- [ ] Tìm kiếm tour
- [ ] Chi tiết tour
- [ ] Đặt tour
- [ ] Đặt tour thành công
- [ ] Chi tiết đơn đặt
- [ ] Profile
- [ ] Đánh giá tour
- [ ] Đăng xuất

### Chức năng Admin
- [ ] Dashboard
- [ ] Quản lý Tour (CRUD đầy đủ)
- [ ] Quản lý Đơn đặt tour
- [ ] Quản lý Khách sạn (CRUD đầy đủ)
- [ ] Quản lý Người dùng
- [ ] Quản lý Đánh giá

---

## 📝 GHI CHÚ

- Chụp ảnh theo thứ tự logic của luồng người dùng
- Đảm bảo mỗi ảnh có nội dung rõ ràng, dễ hiểu
- Chụp cả trường hợp thành công và thất bại (nếu có)
- Ghi chú ngắn gọn cho mỗi ảnh trong báo cáo

---

**Chúc bạn hoàn thành báo cáo tốt! 🎉**

