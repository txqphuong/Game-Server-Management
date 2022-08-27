use GAMESURVIVAL
go

select * from CLAN
select * from TÀI_KHOẢN
select * from PHIẾU_THÔNG_TIN
select * from KHO_TÀI_NGUYÊN
select * from CỬA_HÀNG
select * from LỊCH_SỬ_GIAO_DỊCH
select * from ĐẤU_GIÁ

--Câu 1. Tạo bảng ảo lưu trữ tài khoản người dùng (Mã_TK, Họ_tên)
CREATE VIEW BANGAO AS SELECT Mã_TK, Họ_tên FROM TÀI_KHOẢN

--Câu 2. Tìm thông tin CLAN do họ tên tài khoản '[Akỉa]' sáng lập.
select TÀI_KHOẢN.* from CLAN, TÀI_KHOẢN
where CLAN.Mã_NSL = TÀI_KHOẢN.Mã_TK and TÀI_KHOẢN.Họ_tên = N'[Akỉa]'

--Câu 3. Update tên vật phẩm thành Cây phóng lợn tại vật phẩm có mã vật phẩm là VP006
UPDATE CỬA_HÀNG SET Tên_vật_phẩm ='Cây phóng lợn' WHERE Mã_vật_phẩm='VP006'

--Câu 4. Tìm những người chơi chưa gia nhập CLAN.
select * from TÀI_KHOẢN
where Mã_CLAN is null

--Câu 5. Tìm thông tin về Phiếu thông tin của những người chơi đã gia nhập CLAN.
select PHIẾU_THÔNG_TIN.* from PHIẾU_THÔNG_TIN, TÀI_KHOẢN
where PHIẾU_THÔNG_TIN.Mã_TK = TÀI_KHOẢN.Mã_TK and TÀI_KHOẢN.Mã_CLAN is not null

--Câu 6. Tìm những người chơi mua vật phẩm với số lượng >= 10.
select TÀI_KHOẢN.* from TÀI_KHOẢN, LỊCH_SỬ_GIAO_DỊCH
where LỊCH_SỬ_GIAO_DỊCH.Mã_TK = TÀI_KHOẢN.Mã_TK and LỊCH_SỬ_GIAO_DỊCH.Số_lượng >= 10

--Câu 7. Tìm những người chơi mua vật phẩm 'Đuốc'.
select TÀI_KHOẢN.* from TÀI_KHOẢN, CỬA_HÀNG, LỊCH_SỬ_GIAO_DỊCH
where TÀI_KHOẢN.Mã_TK = LỊCH_SỬ_GIAO_DỊCH.Mã_TK and CỬA_HÀNG.Mã_vật_phẩm = LỊCH_SỬ_GIAO_DỊCH.Mã_vật_phẩm
	and CỬA_HÀNG.Tên_vật_phẩm = N'Đuốc'

--Câu 8. Tìm lịch sử giao dịch của những thành viên CLAN 'Golden Fish'.
select LỊCH_SỬ_GIAO_DỊCH.* from LỊCH_SỬ_GIAO_DỊCH, CLAN, TÀI_KHOẢN
where CLAN.Mã_CLAN = TÀI_KHOẢN.Mã_CLAN and LỊCH_SỬ_GIAO_DỊCH.Mã_TK = TÀI_KHOẢN.Mã_TK
	and CLAN.Tên_CLAN = N'Golden Fish'

--Câu 9. Tìm người chơi mua vật phẩm 'Xương cá mập'.
select TÀI_KHOẢN.* from TÀI_KHOẢN, ĐẤU_GIÁ
where TÀI_KHOẢN.Mã_TK = ĐẤU_GIÁ.Mã_TK_người_mua and ĐẤU_GIÁ.Tên_VP = N'Xương cá mập'

--Câu 10. Tìm những phiếu thông tin của người chơi tham gia mua trong đấu giá.
select PHIẾU_THÔNG_TIN.* from PHIẾU_THÔNG_TIN, TÀI_KHOẢN, ĐẤU_GIÁ
where TÀI_KHOẢN.Mã_TK = ĐẤU_GIÁ.Mã_TK_người_mua and TÀI_KHOẢN.Mã_TK = PHIẾU_THÔNG_TIN.Mã_TK
group by ĐẤU_GIÁ.Mã_TK_người_mua, PHIẾU_THÔNG_TIN.Mã_TK, PHIẾU_THÔNG_TIN.CCCD, PHIẾU_THÔNG_TIN.SĐT, PHIẾU_THÔNG_TIN.Năm_sinh

--Câu 11. Tìm thông tin những thành viên của CLAN 'CLAN01' và 'CLAN03' với Email có đuôi là 'gmail.com'
select * from TÀI_KHOẢN
where (TÀI_KHOẢN.Mã_CLAN = 'CLAN01' or TÀI_KHOẢN.Mã_CLAN = 'CLAN03') and TÀI_KHOẢN.Email like '%gmail.com'

--Câu 12. Hãy cho biết mỗi CLAN (Mã_CLAN, Tên_CLAN, Số_thành_viên) có bao nhiêu thành viên
select CLAN.Mã_CLAN, CLAN.Tên_CLAN, count(*) as Số_thành_viên from TÀI_KHOẢN, CLAN
where TÀI_KHOẢN.Mã_CLAN = CLAN.Mã_CLAN
group by TÀI_KHOẢN.Mã_CLAN, CLAN.Mã_CLAN, CLAN.Tên_CLAN

--Câu 13. Thống kê thông tin giao dịch của người chơi mua hàng trong cửa hàng (Tên_TK, Tên_vật_phẩm, Số_lượng, Gỗ, Vàng, Đá)
select TÀI_KHOẢN.Tên_TK, CỬA_HÀNG.Tên_vật_phẩm, LỊCH_SỬ_GIAO_DỊCH.Số_lượng,
	CỬA_HÀNG.Gỗ * LỊCH_SỬ_GIAO_DỊCH.Số_lượng as Gỗ,
	CỬA_HÀNG.Vàng * LỊCH_SỬ_GIAO_DỊCH.Số_lượng as Vàng,
	CỬA_HÀNG.Đá * LỊCH_SỬ_GIAO_DỊCH.Số_lượng as Đá
from LỊCH_SỬ_GIAO_DỊCH, TÀI_KHOẢN, CỬA_HÀNG
where LỊCH_SỬ_GIAO_DỊCH.Mã_TK = TÀI_KHOẢN.Mã_TK and LỊCH_SỬ_GIAO_DỊCH.Mã_vật_phẩm = CỬA_HÀNG.Mã_vật_phẩm

--Câu 14. Thống kê số vàng của mỗi CLAN (Mã_CLAN, Tên_CLAN, Số_vàng) biết số vàng mỗi CLAN là tổng số vàng của các thành viên.
select CLAN.Mã_CLAN, CLAN.Tên_CLAN, sum(KHO_TÀI_NGUYÊN.Vàng) as Số_vàng from KHO_TÀI_NGUYÊN, CLAN, TÀI_KHOẢN
where KHO_TÀI_NGUYÊN.Mã_TK = TÀI_KHOẢN.Mã_TK and TÀI_KHOẢN.Mã_CLAN = CLAN.Mã_CLAN
group by CLAN.Mã_CLAN, CLAN.Tên_CLAN

--Câu 15. Thống kê lượng tài sản của người chơi (Mã_TK, Tên_TK, Gỗ, Vàng, Đá).
select KHO_TÀI_NGUYÊN.Mã_TK, TÀI_KHOẢN.Họ_tên, sum(KHO_TÀI_NGUYÊN.Gỗ) as Gỗ, sum(KHO_TÀI_NGUYÊN.Vàng) as Vàng, sum(KHO_TÀI_NGUYÊN.Đá) as Đá
from KHO_TÀI_NGUYÊN, TÀI_KHOẢN
where TÀI_KHOẢN.Mã_TK = KHO_TÀI_NGUYÊN.Mã_TK
group by KHO_TÀI_NGUYÊN.Mã_TK, TÀI_KHOẢN.Họ_tên

--Câu 16. Cho biết mỗi người chơi ở những CLAN nào, nếu người chơi không có CLAN thì thông báo 'Không có CLAN' (Mã_TK, Họ_tên, Mã_CLAN, Tên_CLAN)
select Mã_TK, Họ_tên,
(case when CLAN.Mã_CLAN is null then N'Không có CLAN' else CLAN.Mã_CLAN end) as N'Mã CLAN',
(case when CLAN.Tên_CLAN is null then N'Không có CLAN' else CLAN.Tên_CLAN end) as N'Tên CLAN'
from TÀI_KHOẢN
left join CLAN on TÀI_KHOẢN.Mã_CLAN = CLAN.Mã_CLAN

--Câu 17. Thống kê số lượng các vật phẩm được mua trong Cửa hàng (Mã_vật_phẩm, Tên_vật_phẩm, Số_lượng)
select CỬA_HÀNG.Mã_vật_phẩm as N'Mã vật phẩm', CỬA_HÀNG.Tên_vật_phẩm as N'Tên vật phẩm',
sum(case when LỊCH_SỬ_GIAO_DỊCH.Số_lượng is null then 0 else LỊCH_SỬ_GIAO_DỊCH.Số_lượng end) as N'Số lượng'
from CỬA_HÀNG
left join LỊCH_SỬ_GIAO_DỊCH on CỬA_HÀNG.Mã_vật_phẩm = LỊCH_SỬ_GIAO_DỊCH.Mã_vật_phẩm
group by CỬA_HÀNG.Mã_vật_phẩm, CỬA_HÀNG.Tên_vật_phẩm

--Câu 18. Tìm thông tin người chơi có tham gia đấu giá ( bán hoặc mua )
select * from TÀI_KHOẢN
where Mã_TK in(
	select Mã_TK_người_bán from ĐẤU_GIÁ
	union
	select Mã_TK_người_mua from ĐẤU_GIÁ
	where Mã_TK_người_mua is not null
)

--Câu 19. Tìm thông tin người chơi có tham gia bán mà không mua trong đấu giá.
select * from TÀI_KHOẢN
where Mã_TK in(
	select Mã_TK_người_bán from ĐẤU_GIÁ
	except
	select Mã_TK_người_mua from ĐẤU_GIÁ
)

--Câu 20. Tìm thông tin người chơi có họ là Áp
select * from TÀI_KHOẢN where Họ_tên like N'Áp%'

--Câu 21. Cho biết họ tên, số điện thoại người chơi sắp xếp tăng dần theo năm sinh
select Họ_tên, SĐT, year(Năm_sinh) 'NAM SINH' from TÀI_KHOẢN, PHIẾU_THÔNG_TIN 
where TÀI_KHOẢN.Mã_TK = PHIẾU_THÔNG_TIN.Mã_TK
order by year(Năm_sinh) ASC

--Câu 22. Kết hợp thông tin bảng TÀI_KHOẢN và bảng CLAN thành một kết quả
select Mã_TK,Họ_tên from TÀI_KHOẢN
union
select Mã_NSL, Tên_CLAN from CLAN

--Câu 23. Cho biết Mã_TK của người chơi có bán hàng trong bảng ĐẤU_GIÁ
select Mã_TK from TÀI_KHOẢN
intersect
select Mã_TK_người_bán from ĐẤU_GIÁ

--Câu 24. Hãy cho biết vật phẩm (Mã_vật_phẩm) chưa có người mua (chưa có trong LỊCH_SỬ_GIAO_DỊCH)
select Mã_vật_phẩm from CỬA_HÀNG
except
select Mã_vật_phẩm from LỊCH_SỬ_GIAO_DỊCH

