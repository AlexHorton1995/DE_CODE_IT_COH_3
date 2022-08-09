use pubs

insert into titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate) values ('BU1008', 'Overcoming Blockers at Work', 'Business', '9908', '19.99', '5000.00', '10', 1000, 'How to overcome natural obstacles at your place of employment.', '2022-09-12 00:00:00.000');

insert into titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate) values ('BU1009', 'Overcoming Blockers at Work (abridged)', 'Business', '9908', '49.99', '7500.00', '10', 500, 'How to overcome natural obstacles at your place of employment. Abridged.', '2022-09-12 00:00:00.000');


update titles
set type = 'Psychology', pubdate = '2022-07-18 19:00:04.680'
where title_id = 'MC3026';