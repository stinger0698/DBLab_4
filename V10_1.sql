-- TASK A
CREATE TABLE Sales.SalesReasonHst
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	[Action] NVARCHAR(6) NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	SourceID INT REFERENCES Sales.SalesReason(SalesReasonID),
	UserName NVARCHAR(50) NOT NULL
);

--TASK B
CREATE TRIGGER SalesReasonInsert ON Sales.SalesReason
AFTER INSERT AS
INSERT INTO Sales.SalesReasonHst
VALUES  ('INSERT',GETDATE(),USER_NAME());

CREATE TRIGGER SalesReasonUpdate ON Sales.SalesReason
AFTER UPDATE AS
INSERT INTO Sales.SalesReasonHst
VALUES  ('UPDATE',GETDATE(),USER_NAME());

CREATE TRIGGER SalesReasonDelete ON Sales.SalesReason
AFTER DELETE AS
INSERT INTO Sales.SalesReasonHst
VALUES  ('DELETE',GETDATE(),USER_NAME());
--DROP VIEW view_SalesReason
--TASK C
CREATE VIEW view_SalesReason AS
SELECT * FROM Sales.SalesReason

--TASK D
INSERT INTO view_SalesReason
VALUES ('Alex','Check',GETDATE());
UPDATE view_SalesReason
SET Name = 'Oleg'
WHERE ReasonType = 'Check';
DELETE FROM view_SalesReason
WHERE ReasonType = 'Check';