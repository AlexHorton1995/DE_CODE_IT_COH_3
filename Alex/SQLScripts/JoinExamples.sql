use pubs

--JOINS examples :)

/*TABLES USED: authors, titleauthor, titles*/

/* --Outcome I want
Author's name (first, last)
Book Title
published book date
*/

/* INNER JOIN */
SELECT au_fname, au_lname, title, pubdate FROM authors A
INNER JOIN titleauthor TA ON A.au_id = TA.au_id
INNER JOIN titles TI ON TI.title_id = TA.title_id

/* LEFT (OUTER) JOIN */
SELECT au_fname, au_lname, title, pubdate FROM authors A
LEFT OUTER JOIN titleauthor TA ON A.au_id = TA.au_id
LEFT OUTER JOIN titles TI ON TI.title_id = TA.title_id
WHERE TI.title_id IS NOT NULL

/* RIGHT (OUTER) JOIN */
SELECT au_fname, au_lname, title, pubdate FROM authors A
RIGHT OUTER JOIN titleauthor TA ON A.au_id = TA.au_id
RIGHT OUTER JOIN titles TI ON TI.title_id = TA.title_id
WHERE a.au_id IS NOT NULL

/* FULL (OUTER) JOIN */
SELECT * FROM authors A
FULL JOIN titleauthor TA ON A.au_id = TA.au_id
FULL JOIN titles TI ON TI.title_id = TA.title_id
WHERE A.au_id IS NOT NULL AND TA.au_id is NULL

select * from titleauthor where au_id = '000-99-7843'






