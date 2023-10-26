/**Danyl Kuzmychov**/
USE [Chinook]
GO
/*********Project - Q1*******************/
SELECT Top 10 A.Name
	,SUM(E.Total) AS Sales
FROM [dbo].[Artist] A
JOIN [dbo].[Album] B
	ON A.ArtistId = B.ArtistId
JOIN [dbo].[Track] C
	ON B.AlbumId = C.AlbumId
JOIN [dbo].[InvoiceLine] D
	ON C.TrackId = D.TrackId
JOIN [dbo].[Invoice] E
	ON D.InvoiceId = E.InvoiceId
JOIN [dbo].[MediaType] M
	ON C.MediaTypeId = M.MediaTypeId
WHERE E.InvoiceDate BETWEEN '2011-07-01' AND '2012-06-30' 
					AND M.Name NOT LIKE '%video%'
GROUP BY A.Name
ORDER BY Sales DESC

/*********Project - Q2*******************/
SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name]
	,YEAR(I.InvoiceDate) AS [Calendar Year]
	,CASE 
		WHEN MONTH(I.InvoiceDate) between '01' AND '03' THEN '1st'
		WHEN MONTH(I.InvoiceDate) between '04' AND '06' THEN '2nd'
		WHEN MONTH(I.InvoiceDate) between '07' AND '09' THEN '3rd'
		WHEN MONTH(I.InvoiceDate) between '10' AND '12' THEN '4th'
		END as SalesQuarter
	,MAX(I.Total) AS [Highest Sale]
	,COUNT(I.InvoiceID) AS [Number of Sales]
	,SUM(I.Total) AS [Total Sales]
FROM [dbo].[Invoice] I
JOIN [dbo].[Customer] C
	ON I.CustomerId = C.CustomerId
JOIN [dbo].[Employee] E
	ON C.SupportRepId = E.EmployeeId
GROUP BY E.FirstName + ' ' + E.LastName, YEAR(I.InvoiceDate) 
	,CASE 
		WHEN MONTH(I.InvoiceDate) between '01' AND '03' THEN '1st'
		WHEN MONTH(I.InvoiceDate) between '04' AND '06' THEN '2nd'
		WHEN MONTH(I.InvoiceDate) between '07' AND '09' THEN '3rd'
		WHEN MONTH(I.InvoiceDate) between '10' AND '12' THEN '4th'
		END  
ORDER BY E.FirstName + ' ' + E.LastName, YEAR(I.InvoiceDate) 
	,CASE 
		WHEN MONTH(I.InvoiceDate) between '01' AND '03' THEN '1st'
		WHEN MONTH(I.InvoiceDate) between '04' AND '06' THEN '2nd'
		WHEN MONTH(I.InvoiceDate) between '07' AND '09' THEN '3rd'
		WHEN MONTH(I.InvoiceDate) between '10' AND '12' THEN '4th'
		END 

/*********Project - Q3*******************/
SELECT t2.[Playlist Name]
,t2.[Playlist ID]
,pt. TrackId as [Track ID]
FROM
(SELECT z.[Playlist Name]
,z.[Playlist ID]
FROM
(
SELECT p.[Name] AS [Playlist Name] 
,MAX (p.[PlaylistId]) as [Playlist ID]
FROM [dbo].[Playlist] p
JOIN
(
SELECT 
	P.Name 
	,COUNT(P.Name) AS count
FROM [dbo].[Playlist] P
GROUP BY P.Name
HAVING COUNT(p.Name) >1
) x
ON p.[Name] = x.[Name]
GROUP BY p.[Name]) z
JOIN 
(
SELECT count(PlaylistId) as counts, [PlaylistId]
FROM [dbo].[PlaylistTrack]
group by [PlaylistId]
having count([PlaylistId]) >1
) t
ON z.[Playlist ID] = t.PlaylistId) t2
JOIN [dbo].[PlaylistTrack] PT
ON t2.[Playlist ID] = pt.PlaylistId


/*********Project - Q4*******************/
SELECT 
	C.Country
	,A.Name
	,COUNT(T.Name) AS [Track Count]
	,COUNT(distinct T.Name) AS [Unique Track Count]
	,COUNT(T.Name) - COUNT(distinct T.Name) AS [Count Difference]
	,IL.UnitPrice * COUNT(T.Name) AS [Total Revenue]
	,CASE
		WHEN MT.MediaTypeId = 3 THEN 'Video'
		ELSE 'Audio'
		END AS [Media Type]
FROM [dbo].[Artist] A
JOIN  [dbo].[Album] AL
	ON A.ArtistId = AL.ArtistId
JOIN [dbo].[Track] T
	ON AL.AlbumId = T.AlbumId
JOIN [dbo].[MediaType] MT
	ON T.MediaTypeId = MT.MediaTypeId
JOIN [dbo].[InvoiceLine] IL
	ON T.TrackId = IL.TrackId
JOIN [dbo].[Invoice] I
	ON IL.InvoiceId = I.InvoiceId
JOIN [dbo].[Customer] C
	ON I.CustomerId = C.CustomerId

WHERE I.InvoiceDate BETWEEN '2009-07-01' AND '2013-06-01' 

GROUP BY C.Country, A.Name, IL.UnitPrice,
	CASE
		WHEN MT.MediaTypeId = 3 THEN 'Video'
		ELSE 'Audio'
		END 

ORDER BY C.Country DESC, COUNT(T.Name) DESC, A.Name

/*********Project - Q5*******************/
SELECT 
	FirstName + ' ' + LastName AS [Full Name]
	,CONVERT(varchar, BirthDate, 101) [Birth Date]
	,REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016') AS [Birth Day 2016]
	,DATENAME(WEEKDAY, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')) AS [Birthday of Week]
	,CASE
		WHEN DATENAME(WEEKDAY, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')) LIKE 'Sa%' THEN CONVERT(varchar, DATEADD(day, 2, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')), 101)
		WHEN DATENAME(WEEKDAY, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')) LIKE 'Su%' THEN CONVERT(varchar, DATEADD(day, 1, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')), 101)
		ELSE REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')
		END AS [Celebration Date]
	,IIF(DATENAME(WEEKDAY, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')) LIKE '[M,T,W,F]%', DATENAME(WEEKDAY, REPLACE(CONVERT(varchar, BirthDate, 101),DATEPART(YEAR,BirthDate) ,'2016')), 'Monday') AS [Celebration Day of Week]
FROM [dbo].[Employee]