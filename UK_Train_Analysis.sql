SELECT * FROM uk_train.railway;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                 -- CREATE DUPLICATE TABLE FOR DATA CLEANING AND EDA --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE rail_dup 
LIKE railway;

INSERT INTO rail_dup
SELECT *
FROM railway;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
												 -- CHECKING FOR DUPLICATE ROWS IN THE NEW TABLE CREATED--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *,
	ROW_NUMBER() OVER(
    PARTITION BY `Transaction ID`, `Date of Purchase`,`Time of Purchase`,`Purchase Type`,`Payment Method`,`Railcard`,`Ticket Class`,`Ticket Type`, Price,
    `Departure Station`, `Arrival Destination`, `Date of Journey`, `Departure Time`,`Arrival Time`,`Actual Arrival Time`,`Journey Status`,`Reason for Delay`,
    `Refund Request`) AS Row_Num
FROM rail_dup;


WITH CTE_train_dup AS
(
SELECT *,
	ROW_NUMBER() OVER(
    PARTITION BY `Transaction ID`, `Date of Purchase`,`Time of Purchase`,`Purchase Type`,`Payment Method`,`Railcard`,`Ticket Class`,`Ticket Type`, Price,
    `Departure Station`, `Arrival Destination`, `Date of Journey`, `Departure Time`,`Arrival Time`,`Actual Arrival Time`,`Journey Status`,`Reason for Delay`,
    `Refund Request`) AS Row_Num
FROM rail_dup
)

SELECT *
FROM CTE_train_dup
WHERE Row_Num > 1;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
												-- FORMAT DATE AND TME DATA FROM TEXT INTO DATE AND TIME --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE rail_dup
MODIFY `Date of Purchase` DATE;

ALTER TABLE rail_dup
MODIFY `Time of Purchase` TIME;

ALTER TABLE rail_dup
MODIFY COLUMN `Date of Journey` DATE;

ALTER TABLE rail_dup
MODIFY COLUMN `Departure Time` TIME;

ALTER TABLE rail_dup
MODIFY COLUMN `Arrival Time` TIME;

ALTER TABLE rail_dup
MODIFY COLUMN `Actual Arrival Time` TIME;



------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                 -- PURCHASE DATE RANGE --
------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	MIN(`Date of Purchase`) AS Start_Purchase_Date, 
	MAX(`Date of Purchase`) AS End_Purchase_Date
FROM rail_dup;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
												     -- CHECKING EMPTY VALUES --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM rail_dup
WHERE `Transaction ID` = '';

SELECT *
FROM rail_dup
WHERE `Refund Request` = '';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- UPDATE THE REASON FOR THE REASON FOR DELAY COLUMN --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT `Reason For Delay`,
	COUNT(`Reason For Delay`) AS Total_Reasons
FROM rail_dup
	WHERE `Journey Status` = 'Delayed'
	GROUP BY `Reason For Delay`
    ORDER BY Total_Reasons DESC;

UPDATE rail_dup
SET `Reason for Delay` = 'Weather Conditions'
WHERE `Reason for Delay` = 'Weather';

SELECT DISTINCT `Reason for Delay`
FROM rail_dup;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- UPDATE THE EMPTY/NULL VALUES IN REASON FOR DELAY'S COLUMN WITH 'WEATHER  --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM rail_dup
WHERE `Reason for Delay` = '';

SELECT DISTINCT  `Reason for Delay`
FROM rail_dup;

SELECT `Reason for Delay`,
  COUNT(`Reason for Delay`) AS Tot
FROM rail_dup
	GROUP BY `Reason for Delay`
	ORDER BY Tot DESC;
    
UPDATE rail_dup
SET `Reason For Delay` = 'Weather'
WHERE `Reason For Delay` = '';
    

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- UPDATE THE EMPTY/NULL VALUES IN ACTUAL ARRIVAL TIME'S COLUMN --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM rail_dup
WHERE `Actual Arrival Time` = '';

SELECT `Actual Arrival Time`,
  COUNT(`Actual Arrival Time`) AS Tot
FROM rail_dup
	GROUP BY `Actual Arrival Time`
	ORDER BY Tot DESC;
    
UPDATE rail_dup
SET `Reason For Delay` = 'Weather'
WHERE `Reason For Delay` = '';
    

SELECT MAX(`Actual Arrival Time`)
FROM rail_dup;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECK DIFFERENT PURSHASE TYPE --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT COUNT(`Purchase Type`)
	FROM rail_dup;

SELECT DISTINCT `Purchase Type`
FROM rail_dup;

SELECT `Purchase Type`,
	COUNT(`Purchase Type`) AS Total_Purchase_Type
FROM rail_dup
	GROUP BY `Purchase Type`;
    

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING THE MOST COMMON PAYMENT METHOD --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Payment Method`
FROM rail_dup;

SELECT `Payment Method`,
	COUNT(`Payment Method`) AS Total_Payment_Method
FROM rail_dup
	GROUP BY `Payment Method` 
    ORDER BY Total_Payment_Method DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING THE COMMUTTER RAIL CARD --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Railcard`
FROM rail_dup;

SELECT `Railcard`,
	COUNT(`Railcard`) AS Total_RailCard
FROM rail_dup
	GROUP BY `Railcard` 
    ORDER BY Total_Railcard DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING DIFFERENT TYPES OF TICKET CLASS --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Ticket Class`
FROM rail_dup;

SELECT `Ticket Class`,
	COUNT(`Ticket Class`) AS Total_Ticket_Class
FROM rail_dup
	GROUP BY `Ticket Class` 
    ORDER BY Total_Ticket_Class DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING DIFFERENT TICKET TYPES --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Ticket Type`
FROM rail_dup;

SELECT `Ticket Type`,
	COUNT(`Ticket Type`) AS Total_Ticket_Type
FROM rail_dup
	GROUP BY `Ticket Type` 
    ORDER BY Total_Ticket_Type DESC;
    
    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING THE POPULAR STATION WHERE COMMUTTERS BOARD TRAIN --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Departure Station`
FROM rail_dup;

SELECT `Departure Station`,
	COUNT(`Departure Station`) AS Total_Purchase
FROM rail_dup
	GROUP BY `Departure Station` 
    ORDER BY Total_Purchase DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING THE POPULAR STATIONS WHERE COMMUTTERS TRAVEL TO MOST --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Arrival Destination`
FROM rail_dup;

SELECT `Arrival Destination`,
	COUNT(`Departure Station`) AS Total_Arrival_Destination
FROM rail_dup
	GROUP BY `Arrival Destination` 
    ORDER BY Total_Arrival_Destination DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CATEGORIZING HOURS TIME INTO TIME OF THE DAY --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	`Departure Time`,
	(CASE
	WHEN `Departure Time` BETWEEN '06:00:00' AND '11:59:00' THEN 'Morning'
	WHEN `Departure Time` BETWEEN '12:00:00' AND '15:59:00' THEN 'Afternoon'
	WHEN `Departure Time` BETWEEN '16:00:00' AND '23:59:00' THEN 'Evening'
	ELSE 'Mid-Night'
    END
	)
    AS `Day Session`
FROM rail_dup;
         
ALTER TABLE rail_dup
ADD COLUMN `Day Session` VARCHAR(15);

UPDATE rail_dup
SET `Day Session` = ( CASE
	WHEN `Departure Time` BETWEEN '06:00:00' AND '11:59:00' THEN 'Morning'
	WHEN `Departure Time` BETWEEN '12:00:00' AND '15:59:00' THEN 'Afternoon'
	WHEN `Departure Time` BETWEEN '16:00:00' AND '23:59:00' THEN 'Evening'
	ELSE 'Mid-Night'
    END
);

SELECT *
FROM rail_dup;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING THE PEAK TRAVELING TIME --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT `Day Session`,
	COUNT(`Transaction ID`) AS Total_Purchase
FROM rail_dup
	GROUP BY `Day Session`
    ORDER BY Total_Purchase DESC;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- CHECKING THE PEAK TRAVELING DAY --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE rail_dup
ADD COLUMN Dayname TEXT;

UPDATE rail_dup
SET Dayname = DAYNAME(`Date of Journey`);

SELECT `Date of Journey`,
DAYNAME(`Date of Journey`) AS DayName
FROM rail_dup;

SELECT Dayname,
	COUNT(Dayname) AS Total_Day
FROM rail_dup
	GROUP BY Dayname
    ORDER BY Total_Day DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- EXPLORE THE TOTAL REVENUE GENERATED --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SUM(Price)
FROM rail_dup;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									     -- EXPLORE THE TOTAL REVENUE GENERATED BY TICKET TYPES AND CLASSEES --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT `Ticket Class`,
	SUM(Price) AS Total_Revenue
FROM rail_dup
	GROUP BY `Ticket Class`
    ORDER BY Total_Revenue DESC;


SELECT `Ticket Type`,
	SUM(Price) AS Total_Revenue
FROM rail_dup
	GROUP BY `Ticket Type`
    ORDER BY Total_Revenue DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									          -- EXPLORE THE JOURNEY STATUS --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT `Journey Status` FROM rail_dup;

SELECT `Journey Status`,
	COUNT(`Journey Status`) AS Total_Journey_Status
FROM rail_dup
	GROUP BY `Journey Status`
    ORDER BY Total_Journey_Status DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									          -- EXPLORE REASONS FOR THR DELAY IN JOURNEY --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT COUNT(`Reason For Delay`) AS Total_Reasons
FROM rail_dup
WHERE `Journey Status` = 'Delayed';

SELECT `Reason For Delay`,
	COUNT(`Reason For Delay`) AS Total_Reasons
FROM rail_dup
	WHERE `Journey Status` = 'Delayed'
	GROUP BY `Reason For Delay`
    ORDER BY Total_Reasons DESC;
    
    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									          -- EXPLORE REASONS FOR THR ON TIME PERFORMANCE --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT `Ticket Class`, 
    COUNT(`Ticket Class`) AS Total_Class
FROM rail_dup
	WHERE `Journey Status` = 'On Time'
    GROUP BY `Ticket Class`
    ORDER BY Total_Class DESC;
    
SELECT `Ticket Type`, 
    COUNT(`Ticket Type`) AS Total_Type
FROM rail_dup
	WHERE `Journey Status` = 'On Time'
    GROUP BY `Ticket Type`
    ORDER BY Total_Type DESC;
    
SELECT `Payment Method`, 
    COUNT(`Payment Method`) AS Total_Pay
FROM rail_dup
	WHERE `Journey Status` = 'On Time'
    GROUP BY `Payment Method`
    ORDER BY Total_Pay DESC;

SELECT `Purchase Type`, 
    COUNT(`Purchase Type`) AS Total_Type
FROM rail_dup
	WHERE `Journey Status` = 'On Time'
    GROUP BY `Purchase Type`
    ORDER BY Total_Type DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																-- END --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

