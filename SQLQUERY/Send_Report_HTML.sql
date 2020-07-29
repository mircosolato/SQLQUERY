DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<p>' +
    N'<H1>TITLE</H1>' +
    N'</p>' +
    N'<p>' +
    N'<div>' +
    N'<table border="1">' +
    N'<tr>' +
	N'<th>[COL1]</th>' + 
	N'<th>[COL2]</th>' +
	N'<th>[COL3]</th>' +
	N'</tr>' +
    CAST ( ( SELECT 
					td = [COL1],		'',
					td = [COL2],			'',
					td = [COL3]
              FROM <TABLE>
              WHERE 1 = 1
              ORDER BY 1
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' +     
	N'</div>' +
    N'</p>' +
    N'<p>' +
	N'<img width="70" height="35" src="data:image/png;base64,">' + 
    N'</p>' +
	N'<br/>';

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name = 'Notifications',
	@recipients='email@email.com',
    @subject = 'TITLE',
    @body = @tableHTML,
    @body_format = 'HTML' ;







--EXEC msdb.dbo.sp_send_dbmail
--@profile_name = 'Notifications',
--@recipients = 'mirco.solato@reflexallen.com',
--@query = '' ,
--@subject = 'Test email',
--@attach_query_result_as_file = 1,
--@query_attachment_filename='filename.xlsx',
--@query_result_separator='	' -- tab


