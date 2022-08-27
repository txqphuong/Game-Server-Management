-- Constraint check trong đấu giá : Người bán trùng người mua trong đấu giá
insert into ĐẤU_GIÁ
		(Mã_TK_người_bán, Tên_VP, Số_lượng, Gỗ, Vàng, Đá, Ngày_bán, Mã_TK_người_mua)
values	('TK003', N'Xương heo', 2, 10, 20, 0, '6/7/2021', 'TK004')

delete ĐẤU_GIÁ where stt = 8


-- 1) Cập nhật cho người chơi tham gia CLAN : kiểm tra mã người quản lý có phải người sáng lập CLAN không
create trigger TR_join_CLAN on TÀI_KHOẢN
for update as
-- Tham gia CLAN
if (select Mã_CLAN from deleted) is null and (select Mã_NQL from deleted) is null and
	-- Kiểm tra mã người quản lý có hợp lệ với mã NSL của CLAN không
	(select Mã_NQL 'code' from inserted) = (select Mã_NSL 'code' from CLAN
										where Mã_CLAN = (select Mã_CLAN from inserted))
	begin
		print N'Gia nhập CLAN thành công !'
		commit tran
	end
else	-- Dữ liệu không hợp lệ
	begin
		print N'Gia nhập CLAN không hợp lệ !'
		rollback tran
	end

drop trigger TR_join_CLAN

-- Gia nhập CLAN thất bại
update TÀI_KHOẢN set Mã_CLAN = 'CLAN01', Mã_NQL = 'TK004'
where Mã_TK = 'TK001'

-- Gia nhập CLAN thành công
update TÀI_KHOẢN set Mã_CLAN = 'CLAN01', Mã_NQL = 'TK003'
where Mã_TK = 'TK001'

update TÀI_KHOẢN set Mã_CLAN = null, Mã_NQL = null
where Mã_TK = 'TK001'


-- 2) Xóa kho tài nguyên
-- Kiểm tra hợp lệ : mỗi người chơi phải có ít nhất một kho tài nguyên
create trigger TR_kho_tài_nguyên on KHO_TÀI_NGUYÊN
for delete as
if (select count(*) from KHO_TÀI_NGUYÊN
		where Mã_TK in (select Mã_TK from deleted)) >= 1
	commit tran
else
	begin
		print N'Mỗi người chơi phải có ít nhất một kho tài nguyên !'
		rollback tran
	end

drop trigger TR_kho_tài_nguyên

-- Xóa kho tài nguyên thành công
delete KHO_TÀI_NGUYÊN where Mã_kho = 'KHO01'

-- Xóa kho tài nguyên không thành công
delete KHO_TÀI_NGUYÊN where Mã_kho = 'KHO06'

insert into KHO_TÀI_NGUYÊN
		(Mã_kho, Mã_TK, Gỗ, Vàng, Đá)
values	('KHO01', 'TK004', 55, 32, 24)

-- 3) Khi người chơi mua một món mà chưa ai mua ở đấu giá
-- Kiểm tra mã kho hợp lệ
-- Kiểm tra đủ gỗ, vàng, đá không
-- Trừ đi gỗ, vàng, đá đã mua
create trigger TR_mua_đấu_giá on ĐẤU_GIÁ for update as
-- Trước đó đã có người mua
if (select Mã_TK_người_mua from deleted) is not null
	begin
		print N'Đã có người mua trước đó !'
		rollback tran
	end
else	-- Cập nhật không hợp lệ
if (select Mã_TK_người_mua from inserted) is null or (select Mã_kho_người_mua from inserted) is null
	begin
		print N'Không được tồn tại giá trị null !'
		rollback tran
	end
else	-- Kho tài nguyên không thuộc sở hữu người mua
if (select Mã_kho_người_mua from inserted) not in
	(select Mã_kho from KHO_TÀI_NGUYÊN
		where Mã_TK in (select Mã_TK_người_mua from inserted))
	begin
		print N'Kho không thuộc sở hữu của người mua !'
		rollback tran
	end
else	-- Kiểm tra đủ gỗ để mua
if (select Gỗ from KHO_TÀI_NGUYÊN where Mã_kho = (select Mã_kho_người_mua from inserted))
	< (select Gỗ * Số_lượng from inserted)
	begin
		print N'Không đủ gỗ để mua vật phẩm này !'
		rollback tran
	end
else	-- Kiểm tra đủ vàng để mua
if (select Vàng from KHO_TÀI_NGUYÊN where Mã_kho = (select Mã_kho_người_mua from inserted))
	< (select Vàng * Số_lượng from inserted)
	begin
		print N'Không đủ vàng để mua vật phẩm này !'
		rollback tran
	end
else	-- Kiểm tra đủ đá để mua
if (select Đá from KHO_TÀI_NGUYÊN where Mã_kho = (select Mã_kho_người_mua from inserted))
	< (select Đá * Số_lượng from inserted)
	begin
		print N'Không đủ đá để mua vật phẩm này !'
		rollback tran
	end
else	-- Mua hợp lệ, trừ tiền trong kho
	begin
		-- Trừ gỗ, vàng, đá
		update KHO_TÀI_NGUYÊN set Gỗ -= (select Gỗ * Số_lượng from inserted),
		Vàng -= (select Vàng * Số_lượng from inserted),
		Đá -= (select Đá * Số_lượng from inserted)
		where Mã_kho = (select Mã_kho_người_mua from inserted)
		commit tran
	end
-- ==========
drop trigger TR_mua_đấu_giá

-- Đã có người mua
update ĐẤU_GIÁ
set Mã_TK_người_mua = 'TK003', Mã_kho_người_mua = 'KHO02'
where stt = 2

-- Không được cập nhật giá trị null
update ĐẤU_GIÁ
set Mã_TK_người_mua = null, Mã_kho_người_mua = 'KHO02'
where stt = 1

-- Mã kho không hợp lệ
update ĐẤU_GIÁ
set Mã_TK_người_mua = 'TK003', Mã_kho_người_mua = 'KHO04'
where stt = 1

-- Không đủ gỗ
update ĐẤU_GIÁ
set Mã_TK_người_mua = 'TK001', Mã_kho_người_mua = 'KHO08'
where stt = 1

-- Không đủ vàng
update ĐẤU_GIÁ
set Mã_TK_người_mua = 'TK004', Mã_kho_người_mua = 'KHO01'
where stt = 1

-- Không đủ đá
update ĐẤU_GIÁ
set Mã_TK_người_mua = 'TK004', Mã_kho_người_mua = 'KHO01'
where stt = 6

-- Mua hàng thành công
update ĐẤU_GIÁ
set Mã_TK_người_mua = 'TK003', Mã_kho_người_mua = 'KHO05'
where stt = 6

-- 4) Khi người chơi mua một vật phẩm trong cửa hàng
-- ( là khi thêm dữ liệu vào Lịch_sử_giao_dịch : insert ) 
-- kiểm tra xem kho đó có thuộc sở hữu người chơi đó không, nếu không thì không thêm vào bảng
-- kiểm tra xem kho tương ứng đủ tài nguyên để mua không, nếu không thì không thêm vào bảng
-- nếu đủ thì trừ đi gỗ, vàng, đá trong kho đó

--	==========
create trigger TR_mua_hang on LỊCH_SỬ_GIAO_DỊCH
for insert as
-- Kiểm tra kho có thuộc sở hữu người chơi không
if (select Mã_kho from inserted) not in
	(select Mã_kho from KHO_TÀI_NGUYÊN
		where  Mã_TK = (select Mã_TK from inserted))
	begin
		print N'Mã kho không thuộc người chơi !'
		rollback tran
	end
else	-- Kiểm tra đủ gỗ để mua
if (select Gỗ from KHO_TÀI_NGUYÊN where Mã_kho = (select Mã_kho from inserted))
	< (select Gỗ from CỬA_HÀNG where Mã_vật_phẩm = (select Mã_vật_phẩm from inserted)) * (select Số_lượng from inserted)
	begin
		print N'Không đủ gỗ để mua vật phẩm này !'
		rollback tran
	end
else	-- Kiểm tra đủ vàng để mua
if (select Vàng from KHO_TÀI_NGUYÊN where Mã_kho = (select Mã_kho from inserted))
	< (select Vàng from CỬA_HÀNG where Mã_vật_phẩm = (select Mã_vật_phẩm from inserted)) * (select Số_lượng from inserted)
	begin
		print N'Không đủ vàng để mua vật phẩm này !'
		rollback tran
	end
else	-- Kiểm tra đủ đá để mua
if (select Đá from KHO_TÀI_NGUYÊN where Mã_kho = (select Mã_kho from inserted))
	< (select Đá from CỬA_HÀNG where Mã_vật_phẩm = (select Mã_vật_phẩm from inserted)) * (select Số_lượng from inserted)
	begin
		print N'Không đủ đá để mua vật phẩm này !'
		rollback tran
	end
else	-- Mua hợp lệ, trừ tiền trong kho
	begin
		-- Trừ gỗ, vàng, đá
		update KHO_TÀI_NGUYÊN set Gỗ -= (select Gỗ from CỬA_HÀNG where Mã_vật_phẩm = (select Mã_vật_phẩm from inserted)) * (select Số_lượng from inserted),
		Vàng -= (select Vàng from CỬA_HÀNG where Mã_vật_phẩm = (select Mã_vật_phẩm from inserted)) * (select Số_lượng from inserted),
		Đá -= (select Đá from CỬA_HÀNG where Mã_vật_phẩm = (select Mã_vật_phẩm from inserted)) * (select Số_lượng from inserted)
		where Mã_kho = (select Mã_kho from inserted)
		commit tran

	end
--	==========

-- Xóa trigger
drop trigger TR_mua_hang

-- Lỗi kho hàng 'KHO04' không thuộc người chơi 'TK003'
insert into LỊCH_SỬ_GIAO_DỊCH
		(Mã_TK, Mã_vật_phẩm, Mã_kho, Số_lượng, Ngày_GD)
values	('TK003', 'VP001', 'KHO04', 15, '7/7/2021')

-- Lỗi không đủ gỗ để mua
insert into LỊCH_SỬ_GIAO_DỊCH
		(Mã_TK, Mã_vật_phẩm, Mã_kho, Số_lượng, Ngày_GD)
values	('TK001', 'VP001', 'KHO08', 3, '7/7/2021')

-- Lỗi không đủ vàng để mua
insert into LỊCH_SỬ_GIAO_DỊCH
		(Mã_TK, Mã_vật_phẩm, Mã_kho, Số_lượng, Ngày_GD)
values	('TK009', 'VP006', 'KHO12', 1, '7/7/2021')

-- Lỗi không đủ đá để mua
insert into LỊCH_SỬ_GIAO_DỊCH
		(Mã_TK, Mã_vật_phẩm, Mã_kho, Số_lượng, Ngày_GD)
values	('TK008', 'VP007', 'KHO07', 3, '7/7/2021')

-- Thêm thành công
insert into LỊCH_SỬ_GIAO_DỊCH
		(Mã_TK, Mã_vật_phẩm, Mã_kho, Số_lượng, Ngày_GD)
values	('TK003', 'VP007', 'KHO05', 5, '7/7/2021')

delete LỊCH_SỬ_GIAO_DỊCH where stt = 17









