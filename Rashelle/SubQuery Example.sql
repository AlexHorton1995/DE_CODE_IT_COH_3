   use pubs
 
 select
 fname, lname, hire_date, job_id, job_desc
 from (select 
	fname, lname, hire_date, e.job_id, job_desc
from 
	employee E
	inner join jobs J on e.job_id = j.job_id
where 
	hire_date > '1993'
	) subq

order by job_id
