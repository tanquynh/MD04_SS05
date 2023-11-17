CREATE DATABASE NCQLSV;
USE NCQLSV;

CREATE TABLE Subject (
    SubJectID INT PRIMARY KEY AUTO_INCREMENT,
    SubjectName NVARCHAR(50)
);
CREATE TABLE Classes (
    ClassID INT PRIMARY KEY AUTO_INCREMENT,
    ClassName NVARCHAR(50)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(50),
    Age INT,
    Email VARCHAR(100)
);
CREATE TABLE ClassStudent (
    ClassID INT,
    FOREIGN KEY (ClassID)
        REFERENCES Classes (ClassID),
    StudentID INT,
    FOREIGN KEY (StudentID)
        REFERENCES Students (StudentID)
);
CREATE TABLE Marks (
    Mark INT,
    SubJectID INT,
    FOREIGN KEY (SubJectID)
        REFERENCES Subject (SubJectID),
    StudentID INT,
    FOREIGN KEY (StudentID)
        REFERENCES Students (StudentID)
);

INSERT INTO `ncqlsv`.`students` (`StudentID`, `StudentName`, `Age`) VALUES ('2', 'Nguyen Quang An', '18');
INSERT INTO `ncqlsv`.`students` (`StudentID`, `StudentName`, `Age`) VALUES ('2', 'Nguyen Cong Vinh', '20');
INSERT INTO `ncqlsv`.`students` (`StudentID`, `StudentName`, `Age`) VALUES ('3', 'Nguyen Van Quyen', '19');
INSERT INTO `ncqlsv`.`students` (`StudentID`, `StudentName`, `Age`) VALUES ('4', 'Phan Thanh Binh', '25');
INSERT INTO `ncqlsv`.`students` (`StudentID`, `StudentName`, `Age`) VALUES ('5', 'Nguyen Van Tai Em', '30');

INSERT INTO `ncqlsv`.`classes` (`ClassID`, `ClassName`) VALUES ('1', 'C0607L');
INSERT INTO `ncqlsv`.`classes` (`ClassID`, `ClassName`) VALUES ('2', 'C0708G');

INSERT INTO `ncqlsv`.`classstudent` (`StudentID`, `ClassID`) VALUES ('1', '1');
INSERT INTO `ncqlsv`.`classstudent` (`StudentID`, `ClassID`) VALUES ('2', '1');
INSERT INTO `ncqlsv`.`classstudent` (`StudentID`, `ClassID`) VALUES ('3', '2');
INSERT INTO `ncqlsv`.`classstudent` (`StudentID`, `ClassID`) VALUES ('4', '2');
INSERT INTO `ncqlsv`.`classstudent` (`StudentID`, `ClassID`) VALUES ('5', '2');

INSERT INTO `ncqlsv`.`subject` (`SubJectID`, `SubjectName`) VALUES ('1', 'SQL');
INSERT INTO `ncqlsv`.`subject` (`SubJectID`, `SubjectName`) VALUES ('2', 'Java');
INSERT INTO `ncqlsv`.`subject` (`SubJectID`, `SubjectName`) VALUES ('3', 'C');
INSERT INTO `ncqlsv`.`subject` (`SubJectID`, `SubjectName`) VALUES ('4', 'Visual Basic');

INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('8', '1', '1');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('4', '2', '1');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('9', '1', '1');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('7', '1', '3');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('3', '1', '4');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('5', '2', '5');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('8', '3', '3');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('1', '3', '5');
INSERT INTO `ncqlsv`.`marks` (`Mark`, `SubJectID`, `StudentID`) VALUES ('3', '2', '4');

-- Hien thi danh sach tat ca cac hoc vien
SELECT 
    *
FROM
    students;

-- Hien thi danh sach tat ca cac mon hoc
SELECT 
    *
FROM
    Subject;

-- Tinh diem trung binh
SELECT 
    Students.StudentID,
    Students.StudentName,
    Students.Age,
    AVG(Marks.Mark) AS DTB
FROM
    Students
        JOIN
    Marks ON Marks.StudentID = Students.StudentID
GROUP BY Students.StudentID , Students.StudentName , Students.Age;

-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT 
    Subject.SubJectID,
    Subject.SubjectName,
    MAX(Marks.Mark) AS DiemCaoNhat,
    Students.StudentName
FROM
    Subject
        JOIN
    Marks ON Marks.SubjectID = Subject.SubJectID
        JOIN
    Students ON Marks.StudentID = Students.StudentID
GROUP BY Subject.SubJectID , Subject.SubjectName , Students.StudentName;

-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT Subject.SubJectID, Subject.SubjectName , Marks.Mark As DiemCaoNhat , Students.StudentName from Subject
join Marks on Marks.SubjectID = Subject.SubJectID
join Students on Marks.StudentID = Students.StudentID
where Marks.Mark = (select Max(Marks.Mark) from Marks WHERE Marks.SubjectID = Subject.SubJectID); 

-- Danh so thu tu cua diem theo chieu giam
select Students.StudentName as 'Student Name', avg(Marks.mark) as DTB, dense_rank() over (order by avg(Marks.mark) desc) as 'Xếp hạng' from Students
left join Marks on Marks.StudentID = Students.StudentID
group by Students.StudentName
order by avg(Marks.mark);

-- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
alter table Subject
modify SubjectName nvarchar(6323);

-- Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
update Subject
set SubjectName = concat('« Day la mon hoc «', SubjectName);

-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
ALTER TABLE Students
ADD CONSTRAINT CHK_StudentAge CHECK (Age > 15 AND Age < 50);

-- Loai bo tat ca quan he giua cac bang
ALTER TABLE ClassStudent
drop foreign key classstudent_ibfk_2;

ALTER TABLE Marks
drop foreign key marks_ibfk_2;
-- Xoa hoc vien co StudentID la 1
DELETE FROM Students
WHERE StudentID = 1;

-- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table Students
add column Status  BIT default 1;

select * from Students;
-- Cap nhap gia tri Status trong bang Student thanh 0
update  Students
set Status = 0