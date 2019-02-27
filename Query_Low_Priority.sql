/*
Riferimento
https://www.sqlservercentral.com/Forums/Topic1854036-392-1.aspx
*/

SET DEADLOCK_PRIORITY LOW;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT a, b, c FROM MyView WHERE z = 123;

--It is also possible to enable READ UNCOMMITTED using the NOLOCK query hint like so:
SELECT a, b, c FROM MyTable (NOLOCK);
