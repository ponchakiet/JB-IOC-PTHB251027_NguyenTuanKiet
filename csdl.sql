create schema exam;
set search_path to exam;
-- PHẦN 1: Thao tác với dữ liệu các bảng
-- 1. Tạo bảng (10 điểm) Tạo 4 bảng Customer, Room, Booking, Payment với cấu trúc và kiểu dữ liệu hợp lý. Đảm bảo có các
-- khóa chính (PK) và khóa ngoại (FK) để liên kết các bảng.
create table Customer
(
    customer_id        varchar(5) primary key,
    customer_full_name varchar(100) not null,
    customer_email     varchar(100) not null unique,
    customer_phone     varchar(15)  not null,
    customer_address   varchar(255) not null
);

create table Room
(
    room_id     varchar(5) primary key,
    room_type   varchar(50)    not null,
    room_price  decimal(10, 2) not null,
    room_status varchar(20)    not null,
    room_area   int
);

create table Booking
(
    booking_id     serial primary key,
    customer_id    varchar(5) not null,
    room_id        varchar(5) not null,
    check_in_date  date       not null,
    check_out_date date       not null,
    total_amount   decimal(10, 2),
    foreign key (customer_id) references Customer (customer_id),
    foreign key (room_id) references Room (room_id)
);

create table Payment
(
    payment_id     serial primary key,
    booking_id     int            not null,
    payment_method varchar(50)    not null,
    payment_date   date           not null,
    payment_amount decimal(10, 2) not null,
    foreign key (booking_id) references Booking (booking_id)
);

-- 2. Chèn dữ liệu (8 điểm) Thêm dữ liệu vào 4 bảng đã tạo:
insert into customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
values ('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
       ('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
       ('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
       ('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
       ('C005', 'Vu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam');

insert into room (room_id, room_type, room_price, room_status, room_area)
values ('R001', 'Single', 100.0, 'Available', 25),
       ('R002', 'Double', 150.0, 'Booked', 40),
       ('R003', 'Suite', 250.0, 'Available', 60),
       ('R004', 'Single', 120.0, 'Booked', 30),
       ('R005', 'Double', 160.0, 'Available', 35);

insert into booking (customer_id, room_id, check_in_date, check_out_date, total_amount)
values ('C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
       ('C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
       ('C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
       ('C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
       ('C005', 'R005', '2025-03-05', '2025-03-09', 800.0);

insert into payment (booking_id, payment_method, payment_date, payment_amount)
values (1, 'Cash', '2025-03-05', 400.0),
       (2, 'Credit Card', '2025-03-06', 600.0),
       (3, 'Bank Transfer', '2025-03-07', 1000.0),
       (4, 'Cash', '2025-03-08', 480.0),
       (5, 'Credit Card', '2025-03-09', 800.0);

-- 3. Cập nhật dữ liệu (6 điểm) Viết câu lệnh UPDATE để cập nhật lại total_amount trong bảng Booking theo công thức:
-- total_amount = total_amount * 0.9 cho những bản ghi có ngày check_in trước ngày 3/3/2025.
update booking
set total_amount = total_amount * 0.9
where check_in_date < '2025-03-03';

-- 4. Xóa dữ liệu (6 điểm) Viết câu lệnh DELETE để xóa các thanh toán trong bảng Payment nếu:
-- - Phương thức thanh toán (payment_method) là "Cash".
-- - Và tổng tiền thanh toán (payment_amount) nhỏ hơn 500.
delete
from payment
where payment_method = 'Cash'
  and payment_amount < 500;

-- PHẦN 2: Truy vấn dữ liệu
-- 5. (3 điểm) Lấy thông tin khách hàng gồm: mã khách hàng, họ tên, email, số điện thoại được sắp xếp theo họ tên khách hàng giảm dần.
select customer_id, customer_full_name, customer_email, customer_phone
from customer
order by customer_full_name desc;

-- 6. (3 điểm) Lấy thông tin các phòng khách sạn gồm: mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo
-- diện tích phòng tăng dần.
select room_id, room_type, room_price, room_area
from room
order by room_area;

-- 7. (3 điểm) Lấy thông tin khách hàng và phòng khách sạn đã đặt gồm: họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_full_name, r.room_id, b.check_in_date, b.check_out_date
from customer c
    join booking b on c.customer_id = b.customer_id
    join room r on r.room_id = b.room_id;

-- 8. (3 điểm) Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng,
-- phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán tăng dần.
select c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
from customer c
         join booking b on c.customer_id = b.customer_id
         join payment p on b.booking_id = p.booking_id
order by p.payment_amount;

-- 9. (3 điểm) Lấy tất cả thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng (Z-A).
select *
from customer
order by customer_full_name desc
limit 3 offset 1;

-- 10. (5 điểm) Lấy danh sách khách hàng đã đặt ít nhất 2 phòng gồm : mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
select c.customer_id, c.customer_full_name, count(b.room_id) as room_count
from customer c
         join booking b on c.customer_id = b.customer_id
group by c.customer_id, c.customer_full_name
having count(b.room_id) >= 2;

-- 11. (5 điểm) Lấy danh sách các phòng từng có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và số lần đã đặt.
select r.room_id, r.room_type, r.room_price, count(b.customer_id) as count_customer
from room r
         join booking b on r.room_id = b.room_id
group by r.room_id, r.room_type, r.room_price
having count(b.customer_id) >= 3;

-- 12. (5 điểm) Lấy danh sách các khách hàng có tổng số tiền đã thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách
-- hàng, mã phòng, tổng số tiền đã thanh toán.
select c.customer_id, c.customer_full_name, b.room_id, sum(p.payment_amount) as sum_amount
from customer c
         join booking b on c.customer_id = b.customer_id
         join payment p on b.booking_id = p.booking_id
group by c.customer_id, c.customer_full_name, b.room_id
having sum(p.payment_amount) > 1000;

-- 13. (6 điểm) Lấy danh sách các khách hàng gồm : mã KH, Họ tên, email, sđt có họ tên chứa chữ "Minh" hoặc địa chỉ ở "Hanoi".
-- Sắp xếp kết quả theo họ tên tăng dần.
select customer_id, customer_full_name, customer_email, customer_phone
from customer
where customer_full_name ilike '%Minh%'
   or customer_address ilike '%Hanoi%'
order by customer_full_name;

-- 14. (4 điểm)  Lấy danh sách thông tin các phòng gồm : mã phòng, loại phòng, giá , sắp xếp theo giá phòng giảm dần.Chỉ
-- lấy 5 phòng và bỏ qua 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
select room_id, room_type, room_price
from room
order by room_price desc
limit 5 offset 5;

-- PHẦN 3: Tạo View
-- 15. (5 điểm) Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn
-- ngày 2025-03-04. Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
create view room_customer as
select r.room_id, r.room_type, c.customer_id, c.customer_full_name
from customer c
         join booking b on c.customer_id = b.customer_id
         join room r on b.room_id = r.room_id
where b.check_in_date < '2025-03-04';

select *
from room_customer;

-- 16. (5 điểm) Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m².
-- Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng, Ngày nhận phòng
create view customer_room_area as
select c.customer_id, c.customer_full_name, r.room_id, r.room_area, b.check_in_date
from customer c
         join booking b on c.customer_id = b.customer_id
         join room r on b.room_id = r.room_id
where r.room_area > 30;

select *
from customer_room_area;

-- PHẦN 4: Tạo Trigger
-- 17. (5 điểm) Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu
-- ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !”
-- và hủy thao tác chèn dữ liệu vào bảng.
create function trg1()
    returns trigger
as
$$
begin
    if new.check_in_date > new.check_out_date then
        raise exception 'Ngày đặt phòng không thể sau ngày trả phòng được';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger check_insert_booking
    before insert
    on booking
    for each row
execute function trg1();

-- 18. (5 điểm) Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành
-- "Booked" khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
create or replace function trg2()
    returns trigger
as
$$
begin
    update examination.room
    set room_status = 'Booked'
    where room_id = new.room_id;
    return new;
end;
$$ language plpgsql;

create or replace trigger update_room_status_on_booking
    after insert
    on booking
    for each row
execute function trg2();

-- PHẦN 5: Tạo Store Procedure
-- 19. (5 điểm) Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
create or replace procedure add_customer(p_customer_id varchar(5), p_customer_full_name varchar(100),
                                         p_customer_email varchar(100),
                                         p_customer_phone varchar(15), p_customer_address varchar(255))
    language plpgsql
as
$$
begin
    if exists(select 1 from customer where customer_id=p_customer_id) then
        raise exception 'Mã khách hàng này đã có rồi';
    end if;
    insert into customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
    values (p_customer_id, p_customer_full_name, p_customer_email, p_customer_phone, p_customer_address);
end;
$$;

call add_customer('C006', 'Nguyen Tuan Kiet', 'tuankiet3459@gmail.com', '0383796521', 'Ho Chi Minh, Vietnam');

-- 20. (5 điểm) Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
-- Procedure này nhận các tham số đầu vào:
-- - p_booking_id: Mã đặt phòng (booking_id).
-- - p_payment_method: Phương thức thanh toán (payment_method).
-- - p_payment_amount: Số tiền thanh toán (payment_amount).
-- - p_payment_date: Ngày thanh toán (payment_date).
create or replace procedure add_payment(p_booking_id int, p_payment_method varchar(50), p_payment_amount decimal(10, 2),
                                        p_payment_date date)
    language plpgsql
as
$$
begin
    if exists (select 1 from booking where booking_id = p_booking_id) then
        raise exception 'Mã đặt phòng này đã thanh toán rồi';
    end if;
    insert into payment (booking_id, payment_method, payment_date, payment_amount)
    values (p_booking_id, p_payment_method, p_payment_date, p_payment_amount);
end;
$$;

call add_payment(2, 'Cash', 1500.0, '2025-03-19');
