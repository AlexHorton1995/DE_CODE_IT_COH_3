use pubs

/*
Author ID
Author's Full Name
Address
City
State
Zip
Whether or not the author is under contract or not.
*/

select au_id, au_fname, au_lname, address, city, state, zip, contract from authors where state = 'CA'

