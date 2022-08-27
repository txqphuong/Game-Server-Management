create database GAMESURVIVAL
go
use GAMESURVIVAL

--use master
--drop database GAMESURVIVAL

go
create table CLAN
(
	Mã_CLAN varchar(10) primary key,
	Tên_CLAN nvarchar(40) unique not null,
	Mã_NSL varchar(10) unique not null,
	Ngày_lập date not null,
	Điểm_thưởng int check(Điểm_thưởng >= 0) not null default 0
)

go
create table TÀI_KHOẢN
(
	Mã_TK varchar(10) primary key,
	Tên_TK varchar(10) not null,
	Email varchar(40) unique not null ,
	Họ_tên nvarchar(40) not null,
	Ngày_ĐK date not null,
	Mã_CLAN varchar(10),
	Mã_NQL varchar(10),

	foreign key (Mã_NQL) references TÀI_KHOẢN(Mã_TK)
)

go
create table PHIẾU_THÔNG_TIN
(
	Mã_TK varchar(10) unique not null,
	CCCD varchar(20) unique not null,
	SĐT varchar(20) unique not null,
	Năm_sinh date not null,

	primary key (Mã_TK, CCCD, SĐT),
	foreign key (Mã_TK) references TÀI_KHOẢN(Mã_TK)
)

go
create table KHO_TÀI_NGUYÊN
(
	Mã_kho varchar(10) primary key,
	Mã_TK varchar(10) not null,
	Gỗ int check(Gỗ >= 0) not null,
	Vàng int check(Vàng >= 0) not null,
	Đá int check(Đá >= 0) not null,

	foreign key (Mã_TK) references TÀI_KHOẢN(Mã_TK)
)

go
create table CỬA_HÀNG
(
	Mã_vật_phẩm varchar(10) primary key,
	Tên_vật_phẩm nvarchar(40) default N'Vật phẩm bí ẩn',
	Gỗ int check(Gỗ >= 0) not null,
	Vàng int check(Vàng >= 0) not null,
	Đá int check(Đá >= 0) not null
)

go
create table LỊCH_SỬ_GIAO_DỊCH
(
	STT int identity primary key,
	Mã_TK varchar(10) not null,
	Mã_vật_phẩm varchar(10) not null,
	Mã_kho varchar(10) not null,
	Số_lượng int check(Số_lượng >= 0) not null,
	Ngày_GD date not null,

	foreign key (Mã_TK) references TÀI_KHOẢN(Mã_TK),
	foreign key (Mã_vật_phẩm) references CỬA_HÀNG(Mã_vật_phẩm),
	foreign key (Mã_kho) references KHO_TÀI_NGUYÊN(Mã_kho)
)

go
create table ĐẤU_GIÁ
(
	STT int identity primary key,
	Mã_TK_người_bán varchar(10) not null,
	Tên_VP nvarchar(40) not null,
	Số_lượng int check(Số_lượng >= 0) not null,
	Gỗ int check(Gỗ >= 0) not null,
	Vàng int check(Vàng >= 0) not null,
	Đá int check(Đá >= 0) not null,
	Ngày_bán date not null,
	Mã_TK_người_mua varchar(10),
	Mã_kho_người_mua varchar(10),

	foreign key (Mã_TK_người_bán) references TÀI_KHOẢN(Mã_TK),
	foreign key (Mã_TK_người_mua) references TÀI_KHOẢN(Mã_TK),
	foreign key (Mã_kho_người_mua) references KHO_TÀI_NGUYÊN(Mã_kho),
	check(Mã_TK_người_bán != Mã_TK_người_mua)
)

go
set dateformat dmy

go
insert into CLAN
		(Mã_CLAN, Tên_CLAN, Mã_NSL, Ngày_lập, Điểm_thưởng)
values	('CLAN01', N'Chích chòe bông', 'TK003', '13/7/2021', 105),
		('CLAN02', N'Castle Lmao', 'TK007', '12/7/2021', 132),
		('CLAN03', N'Golden Fish', 'TK002', '21/7/2021', 97),
		('CLAN04', N'Captain Amẻican', 'TK010', '19/7/2021', 66),
		('CLAN05', N'Dark Mafia', 'TK006', '7/7/2021', 153)

go
insert into TÀI_KHOẢN
		(Mã_TK, Tên_TK, Email, Họ_tên, Ngày_ĐK, Mã_CLAN, Mã_NQL)
values	('TK001', 'meomay', 'meomeo@yahoo.com', N'Mèo Lỏd', '2/7/2021', null, null),
		('TK002', 'fapsu', 'china@china.com', N'[Akỉa]', '3/7/2021', 'CLAN03', 'TK002'),
		('TK003', 'donglao', 'vietnam123@gmail.com', N'Ưhat`s up', '2/7/2021', 'CLAN01', 'TK003'),
		('TK004', 'namchau', 'namchau@gmail.com', N'Năm Châu', '4/7/2021', 'CLAN03', 'TK002'),
		('TK005', 'dragonfly', 'flyfly@gmail.com', N'Chuồn Chuồn', '3/7/2021', 'CLAN05', 'TK006'),
		('TK006', 'interface', 'interface@gmail.com', N'Itẻface', '5/7/2021', 'CLAN05', 'TK006'),
		('TK007', 'giaosu', 'giaosu@gmail.com', N'Giáo sư', '2/7/2021', 'CLAN02', 'TK007'),
		('TK008', 'abstract', 'abstract@gmail.com', N'Áp trắc', '4/7/2021', 'CLAN04', 'TK010'),
		('TK009', 'chongchong', 'chongchongtre@gmail.com', N'Nô bi ta', '5/7/2021', 'CLAN03', 'TK002'),
		('TK010', 'computer', 'computer@yahoo.com', N'Còmputơ', '3/7/2021', 'CLAN04', 'TK010')

go
alter table CLAN add foreign key (Mã_NSL) references TÀI_KHOẢN(Mã_TK)
alter table TÀI_KHOẢN add foreign key (Mã_CLAN) references CLAN(Mã_CLAN)

go
insert into PHIẾU_THÔNG_TIN
		(Mã_TK, CCCD, SĐT, Năm_sinh)
values	('TK001', '100000001', '0935654525', '3/2/2001'),
		('TK002', '100000002', '0911111111', '6/6/2006'),
		('TK003', '100000003', '0922222222', '7/3/2003'),
		('TK004', '100000004', '0933333333', '15/9/2000'),
		('TK005', '100000005', '0946464651', '23/5/1991'),
		('TK006', '100000006', '0937516516', '19/7/1999'),
		('TK007', '100000007', '0911156897', '31/5/2004'),
		('TK008', '100000008', '0932425262', '7/6/2002'),
		('TK009', '100000009', '0911819101', '3/1/2007'),
		('TK010', '100000010', '0907664425', '11/1/2003')

go
insert into KHO_TÀI_NGUYÊN
		(Mã_kho, Mã_TK, Gỗ, Vàng, Đá)
values	('KHO01', 'TK004', 55, 32, 24),
		('KHO02', 'TK003', 64, 51, 82),
		('KHO03', 'TK002', 11, 7, 22),
		('KHO04', 'TK010', 36, 41, 15),
		('KHO05', 'TK003', 64, 52, 98),
		('KHO06', 'TK004', 101, 84, 66),
		('KHO07', 'TK008', 27, 85, 11),
		('KHO08', 'TK001', 0, 77, 25),
		('KHO09', 'TK005', 33, 49, 87),
		('KHO10', 'TK010', 82, 11, 62),
		('KHO11', 'TK006', 7, 5, 12),
		('KHO12', 'TK009', 17, 2, 11),
		('KHO13', 'TK001', 95, 61, 24),
		('KHO14', 'TK007', 72, 35, 58),
		('KHO15', 'TK002', 156, 113, 167)

go
insert into CỬA_HÀNG
		(Mã_vật_phẩm, Tên_vật_phẩm, Gỗ, Vàng, Đá)
values	('VP001', N'Đuốc', 3, 0, 0),
		('VP002', N'Ván', 5, 0, 0),
		('VP003', N'Rìu', 3, 0, 2),
		('VP004', N'Dây thừng', 0, 2, 0),
		('VP005', N'Cọc', 5, 1, 2),
		('VP006', N'Đinh', 0, 5, 1),
		('VP007', N'Búa', 3, 3, 5),
		('VP008', N'Rương', 15, 5, 3),
		('VP009', N'Thùng', 15, 5, 0),
		('VP010', N'Xe đẩy', 50, 15, 10)

go
insert into LỊCH_SỬ_GIAO_DỊCH
		(Mã_TK, Mã_vật_phẩm, Mã_kho, Số_lượng, Ngày_GD)
values	('TK002', 'VP001', 'KHO03', 15, '7/7/2021'),
		('TK002', 'VP002', 'KHO03', 20, '7/7/2021'),
		('TK003', 'VP004', 'KHO02', 5, '4/7/2021'),
		('TK002', 'VP010', 'KHO15', 2, '8/7/2021'),
		('TK006', 'VP009', 'KHO11', 3, '7/7/2021'),
		('TK007', 'VP001', 'KHO14', 5, '5/7/2021'),
		('TK010', 'VP001', 'KHO04', 10, '5/7/2021'),
		('TK008', 'VP006', 'KHO07', 8, '6/7/2021'),
		('TK001', 'VP008', 'KHO08', 1, '5/7/2021'),
		('TK005', 'VP005', 'KHO09', 15, '6/7/2021'),
		('TK002', 'VP008', 'KHO03', 4, '6/7/2021'),
		('TK002', 'VP004', 'KHO03', 30, '6/7/2021'),
		('TK003', 'VP005', 'KHO05', 10, '7/7/2021'),
		('TK006', 'VP001', 'KHO11', 35, '8/7/2021'),
		('TK010', 'VP006', 'KHO10', 12, '8/7/2021')

go
insert into ĐẤU_GIÁ
		(Mã_TK_người_bán, Tên_VP, Số_lượng, Gỗ, Vàng, Đá, Ngày_bán, Mã_TK_người_mua, Mã_kho_người_mua)
values	('TK002', N'Thuốc trừ sâu', 2, 10, 20, 0, '6/7/2021', null, null),
		('TK001', N'Hòm đinh', 1, 15, 35, 10, '8/7/2021', 'TK002', 'KHO03'),
		('TK010', N'Hạt', 22, 10, 15, 5, '6/7/2021', 'TK008', 'KHO07'),
		('TK010', N'Đầu lâu', 1, 0, 25, 0, '7/7/2021', 'TK002', 'KHO15'),
		('TK002', N'Xương cá mập', 1, 0, 50, 10, '7/7/2021', 'TK006', 'KHO11'),
		('TK007', N'Hòm bạc', 1, 50, 30, 25, '8/7/2021', null, null)