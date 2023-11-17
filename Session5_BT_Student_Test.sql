create database Student_Test;
use Student_Test;

create table Students (
rn int primary key auto_increment,
sName varchar(20),
sAge tinyint
);

insert into Students (sName, sAge)
values
('Nguyen Hong Ha', 20),
('Truong Ngoc Anh',30),
('Tuan Minh', 25),
('Dan Truong', 22);

create table  Tests (
testID int primary key auto_increment,
tName varchar(20)
);

insert into Tests (tName)
values
('EPC'), ('DWMX'), ('SQL1'), ('SQL2');

create table StudentTests (
rn int,
foreign key (rn) references Students(rn),
testID int,
foreign key (testID) references Tests(testID),
tDate datetime,
mark float
);

insert into StudentTests (rn, testID, tDate, mark)
values
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

-- Sử dụng alter để sửa đổi
-- a. Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
alter table  Students add constraint chk_age check(sAge between 15 and 55)

-- b. Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
alter table StudentTests alter mark set default 0

-- c. Thêm khóa chính cho bảng studenttest là (RN,TestID)
alter table StudentTests add constraint add_primary_key primary key(RN,TestID)

-- d. Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table Tests add constraint add_uni_tests unique(tName)

-- e. Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table Tests drop constraint add_uni_tests

-- Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các 
-- học viên đó, điểm thi và ngày thi giống như hình sau:
select Students.sName as 'Student Name',Tests.tName as 'Test Name' , StudentTests.Mark as Mark, StudentTests.tDate as Date from Students
join StudentTests on StudentTests.RN = Students.RN
join Tests on StudentTests.TestID =Tests.testID 

-- Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau
select Students.rn as 'RN', Students.sName as 'Name' , Students.sAge as 'Age' from students
left join StudentTests on Students.rn = StudentTests.rn
where StudentTests.rn is null

select Students.rn as 'RN', Students.sName as 'Name', Students.sAge as 'Age' from Students
 where Students.rn not in (select distinct StudentTests.rn from StudentTests);

-- Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) 

select Students.sName as 'Student Name' , Tests.tName as 'Test Name', format(StudentTests.Mark,1) as Mark,StudentTests.tDate from Students
join StudentTests on StudentTests.rn = Students.rn
join Tests on Tests.testID = StudentTests.testID 
where Tests.testID >1 and StudentTests.mark < 5;

-- Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần
select Students.sName as 'Student Name',  avg(StudentTests.Mark) as Average from Students
join StudentTests on StudentTests.rn = Students.rn

group by Students.sName
order by Average desc;

SELECT 
    Students.sName AS 'Student Name', 
    AVG(StudentTests.Mark) AS Average,
    CASE
        WHEN AVG(StudentTests.Mark) < 5 THEN 'Hoc luc yeu'
        WHEN AVG(StudentTests.Mark) >= 5 AND AVG(StudentTests.Mark) < 7 THEN 'Hoc luc tb'
        WHEN AVG(StudentTests.Mark) >= 7 AND AVG(StudentTests.Mark) < 8 THEN 'Hoc luc kha'
        WHEN AVG(StudentTests.Mark) >= 8 THEN 'Hoc luc gioi'
    END AS Status
FROM Students
JOIN StudentTests ON StudentTests.rn = Students.rn
GROUP BY Students.sName
ORDER BY Average DESC;

-- Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
select Students.sName as 'Student Name',  avg(StudentTests.Mark) as Average from Students
join StudentTests on StudentTests.rn = Students.rn
group by Students.sName
order by Average desc
limit 1

-- Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:
select Tests.tName as 'Test Name', max(StudentTests.mark) as 'Max Mark' from Tests 
join StudentTests on Tests.testID = StudentTests.testID 
group by(Tests.testID) 
order by Tests.tName;

-- Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null như sau:
select Students.sName as 'Student Name',Tests.tName as 'Test Name' from Students
left join StudentTests on Students.rn = StudentTests.rn 
left join Tests on Tests.testID = StudentTests.testID ;

-- Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update Students
set s.Age =s.Age + 1;

-- 11.Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table Students
add column Status Varchar(10);

-- Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp còn lại nhận giá trị ‘Old’
UPDATE Students
SET Status = CASE
    WHEN sAge < 30 THEN 'Young'
    ELSE 'Old'
END;
select rn as RN , sName as Name, sAge as Age , Status from Students;

-- Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi
select Students.sName as 'Student Name',Tests.tName as 'Test Name', format(StudentTests.Mark,1) as Mark, StudentTests.tDate from Students
join StudentTests on StudentTests.rn = Students.rn
join Tests on Tests.testID = StudentTests.testID
order by StudentTests.tDate asc
-- Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select Students.sName as 'Student Name',Students.sAge as 'Student Age', avg(StudentTests.mark) from Students
join StudentTests on StudentTests.rn = Students.rn
 group by StudentTests.rn 
 having Students.sName like 'T%' and avg(StudentTests.mark) > 4.5;

-- Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng). Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1.
select Students.rn as RN,Students.sName as 'Student Name',Students.sAge as 'Student Age', avg(StudentTests.mark) as DTB, dense_rank() over (order by avg(StudentTests.mark) desc) as 'Xếp hạng' from Students
join StudentTests on Students.rn = StudentTests.rn 
group by Students.rn, Students.sName, Students.sAge 
order by avg(StudentTests.mark);

-- Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
alter table Students
modify sName nvarchar(6323);

-- Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
-- a. Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
-- b. Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)

update Students
set sName = if(sAge > 20 , concat('Old ', sName),concat('Young ', sName));
set sName = case when sAge > 20 then concat('Old ', sName) else concat('Young ', sName) end;

# Xóa tất cả các môn học chưa có bát kỳ sinh viên nào thi
delete from Tests where testID not in (select distinct testID from StudentTests);

# Xóa thông tin điểm thi của sinh viên có điểm < 5
delete from StudentTests where mark < 5;