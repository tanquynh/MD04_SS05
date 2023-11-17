CREATE DATABASE Lab4;
USE Lab4;
create table Customer(
cID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cName VARCHAR(20) NOT NULL,
cAge TINYINT 
);

create table Orders(
oID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cID INT,
FOREIGN KEY(CID) REFERENCES Customer(cID),
oDate DATETIME,
oTotalPrice INT
);

create table Product(
pID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
pName VARCHAR(20) NOT NULL,
pPrice FLOAT

);

create table OrderDetail(
oID INT ,
FOREIGN KEY(oID) REFERENCES Orders(oID),
pID INT,
FOREIGN KEY(pID) REFERENCES Product(pID),
odQTY INT
);

-- --customer
INSERT INTO `lab4`.`customer` (`cID`, `cName`, `cAge`) VALUES ('1', 'Minh Quan', '10');
INSERT INTO `lab4`.`customer` (`cID`, `cName`, `cAge`) VALUES ('2', 'Ngoc Oanh', '20');
INSERT INTO `lab4`.`customer` (`cID`, `cName`, `cAge`) VALUES ('3', 'Hong Ha', '30');
-- Orders
INSERT INTO `lab4`.`orders` (`oID`, `cID`, `oDate`) VALUES ('1', '1', '2006/3/21');
INSERT INTO `lab4`.`orders` (`oID`, `cID`, `oDate`) VALUES ('2', '2', '2006/3/23');
INSERT INTO `lab4`.`orders` (`oID`, `cID`, `oDate`) VALUES ('3', '1', '2006/3/16');

-- product
INSERT INTO `lab4`.`product` (`pID`, `pName`, `pPrice`) VALUES ('1', 'May Giat', '3');
INSERT INTO `lab4`.`product` (`pID`, `pName`, `pPrice`) VALUES ('2', 'Tu Lanh', '5');
INSERT INTO `lab4`.`product` (`pID`, `pName`, `pPrice`) VALUES ('3', 'Dieu Hoa', '7');
INSERT INTO `lab4`.`product` (`pID`, `pName`, `pPrice`) VALUES ('4', 'Quat', '1');
INSERT INTO `lab4`.`product` (`pID`, `pName`, `pPrice`) VALUES ('5', 'Bep Dien', '2');

-- --OrderDetail 
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('1', '1', '3');
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('1', '3', '7');
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('1', '4', '2');
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('2', '1', '1');
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('3', '1', '8');
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('2', '5', '4');
INSERT INTO `lab4`.`orderdetail` (`oID`, `pID`, `odQTY`) VALUES ('2', '3', '3');

SELECT * from orders
-- Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau 

SELECT  pName, pPrice FROM product
where pPrice = (select max(pPrice) from product)

-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
SELECT cName , pName from OrderDetail
join Product on Product.pId= OrderDetail.pID 
join Orders on Orders.oID =  OrderDetail.oID 
join Customer on Customer.cID = Orders.cID

-- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sa
SELECT cName  from Customer 
left join Orders on Orders.cID =  Customer.cID 
where Orders.oID is null

-- Hiển thị chi tiết của từng hóa đơn
SELECT Orders.oID, Orders.oDate, OrderDetail.odQTY, Product.pName, Product.pPrice FROM Orders
JOIN OrderDetail ON OrderDetail.oID = Orders.oID
JOIN Product ON OrderDetail.pID = Product.pID

-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn

SELECT Orders.oID, Orders.oDate, sum(Product.pPrice * OrderDetail.odQTY) as ToTal FROM Orders
JOIN OrderDetail ON OrderDetail.oID = Orders.oID
JOIN Product ON OrderDetail.pID = Product.pID
group by  Orders.oID, Orders.oDate
