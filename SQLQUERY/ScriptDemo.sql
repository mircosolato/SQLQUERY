CREATE TABLE dbo.TableA (
 uqid INT UNIQUE,
 someVal FLOAT )
CREATE TABLE dbo.TableB (
 uqid INT UNIQUE,
 someVal FLOAT )
DECLARE @cnt INT
SET @cnt = 1
DECLARE @rnd FLOAT
WHILE @cnt <= 100000
BEGIN
 SET @rnd = ROUND((RAND() * 100),3)
 INSERT INTO dbo.TableA (uqid, someVal) VALUES (@cnt, @rnd)
 SET @rnd = ROUND((RAND() * 100),3)
 INSERT INTO dbo.TableB (uqid, someVal) VALUES (@cnt, @rnd)
 SET @cnt = @cnt + 1
END
SELECT a.uqid [a_key], b.uqid [b_key], a.someVal [matching_val]
FROM dbo.TableA a INNER JOIN dbo.TableB b ON a.someVal = b.someVal
