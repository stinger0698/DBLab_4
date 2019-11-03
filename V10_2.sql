--TASK A
--drop view view_SalesReasons
CREATE VIEW view_SalesReasons 
WITH SCHEMABINDING AS 
SELECT Reason.SalesReasonID,Name,ReasonType,Reason.ModifiedDate,OrderHeader.SalesOrderID,CustomerID 
FROM Sales.SalesReason AS Reason
JOIN SALES.SalesOrderHeaderSalesReason AS ReasonHeader ON Reason.SalesReasonID = ReasonHeader.SalesReasonID
JOIN Sales.SalesOrderHeader AS OrderHeader ON OrderHeader.SalesOrderID = ReasonHeader.SalesOrderID

CREATE UNIQUE CLUSTERED INDEX idx_ID
ON view_SalesReasons(SalesReasonID,SalesOrderID)

--TASK B 
CREATE TRIGGER ReasonsInstedInsert
ON view_SalesReasons
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO Sales.SalesReason
	SELECT Name, ReasonType, ModifiedDate
	FROM INSERTED	
	INSERT INTO Sales.SalesOrderHeaderSalesReason
END

CREATE TRIGGER ReasonsInstedUpdate
ON view_SalesReasons
INSTEAD OF UPDATE AS
BEGIN
	UPDATE Sales.SalesReason
	SET Name = INSERTED.Name , ReasonType = INSERTED.ReasonType, ModifiedDate = INSERTED.ModifiedDate
	FROM INSERTED
	WHERE Sales.SalesReason.SalesReasonID = INSERTED.SalesReasonID
	UPDATE Sales.SalesOrderHeader
	SET CustomerID = INSERTED.CustomerID
	FROM INSERTED
	WHERE Sales.SalesOrderHeader.CustomerID = INSERTED.CustomerID
END

CREATE TRIGGER ReasonsInstedDelete
ON view_SalesReasons
INSTEAD OF DELETE AS
BEGIN
	IF (SELECT SalesReasonID from deleted)  NOT IN (SELECT SalesReasonID FROM Sales.SalesOrderHeaderSalesReason)
		DELETE FROM Sales.SalesReason
		WHERE SalesReasonID = (SELECT SalesReasonID from deleted)
	DELETE FROM Sales.SalesOrderHeaderSalesReason
	WHERE Sales.SalesOrderHeaderSalesReason.SalesOrderID = (SELECT SalesOrderID FROM deleted)
	DELETE FROM Sales.SalesOrderHeader
	WHERE Sales.SalesOrderHeader.SalesOrderID = (SELECT SalesOrderID FROM deleted)
END

--TASK C