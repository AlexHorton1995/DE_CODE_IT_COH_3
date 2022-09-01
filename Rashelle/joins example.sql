use pubs
/* INNER JOIN EXAMPLE */
select * from authors A
inner join titleauthor TA on A.au_id = TA.au_id
INNER JOIN TITLES TI ON TI.title_id = TA.title_id

/* LEFT OUTER JOIN */
select * from authors A
LEFT join titleauthor TA on A.au_id = TA.au_id
LEFT JOIN TITLES TI ON TI.title_id = TA.title_id
WHERE TI.title_id IS NOT NULL

/* RIGHT OUTER JOIN */
select * from authors A
RIGHT OUTER join titleauthor TA on A.au_id = TA.au_id
RIGHT OUTER JOIN TITLES TI ON TI.title_id = TA.title_id
WHERE A.AU_id IS NOT NULL

/* FULL OUTER JOIN */
select * from authors A
FULL join titleauthor TA on A.au_id = TA.au_id
FULL JOIN TITLES TI ON TI.title_id = TA.title_id
WHERE A.AU_id IS NOT NULL AND TA.au_id IS NOT NULL


