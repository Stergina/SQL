/* Question 1a */

/* Designate MOVIE as the default database */
use MOVIE
 
/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Activate statistics */
set statistics io on;

/* Run Query Batch Without Index */
go
select title from movies where pyear between 1990 and 2000
select pyear, title from movies where pyear between 1990 and 2000
select title, pyear from movies where pyear between 1990 and 2000
order by pyear, title
go

/* Cleans buffers */
checkpoint
dbcc dropcleanbuffers

/* Creates index */
create index title_year
on movies(title,pyear);

/* Run Query Batch With Index */
go
select title from movies where pyear between 1990 and 2000
select pyear, title from movies where pyear between 1990 and 2000
select title, pyear from movies where pyear between 1990 and 2000
order by pyear, title
go

/* Drops index */
drop index movies.title_year;

/* Cleans buffers */
checkpoint
dbcc dropcleanbuffers



/* Question 1b */

/* Run Query Batch Without Index */
go
select mid, count(rating)
from user_movies group by mid order by mid
select userid, count(rating)
from user_movies group by userid order by userid
go

/* Cleans buffers */
checkpoint
dbcc dropcleanbuffers

/* Creates index */
create index mid_user_rate
on user_movies(mid,userid,rating);

/* Run Query Batch With Index */
go
select mid, count(rating)
from user_movies group by mid order by mid
select userid, count(rating)
from user_movies group by userid order by userid
go

/* Drops index */
drop index user_movies.mid_user_rate;

/* Cleans buffers */
checkpoint
dbcc dropcleanbuffers



/* Question 3a */

/* Query 1 */

/* Designate MOVIE as the default database */
use MOVIE
 
/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Activate statistics */
set statistics io on;

/* Run Query Batch Without Index */
go
select title, mrank
from directors, movies, movie_directors
where movies.mid = movie_directors.mid and directors.did = movie_directors.did and directors.lastname = 'Tarantino'
order by mrank desc
go


/* Query 2 */
 
/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Activate statistics */
set statistics io on;

/* Run Query Batch Without Index */
go
select genre, count(*) as count
from movies, movies_genre
where movies.mid = movies_genre.mid and movies.pyear = '1992'
group by genre
go

/* Cleans buffers */
checkpoint
dbcc dropcleanbuffers


/* Question 3b */

/* Query 1 */

/* Creates indexes */
create index mrank_idx on movies(mrank);
create index dir_idx on directors(did, lastname);
create index mdir_idx on movie_directors(mid, did);

/* Run Query Batch With Index */
go
select title, mrank
from directors, movies, movie_directors
where movies.mid = movie_directors.mid and directors.did = movie_directors.did and directors.lastname = 'Tarantino'
order by mrank desc
go

/* Drops indexes */
drop index mrank_idx on movies;
drop index dir_idx on directors;
drop index mdir_idx on movie_directors;


/* Query 2 */
 
/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Activate statistics */
set statistics io on;

/* Creates indexes */
create index genre_idx on movies_genre(genre);
create index mid_pyear_idx on movies(mid, pyear);

/* Run Query Batch With Index */
go
select genre, count(*) as count
from movies, movies_genre
where movies.mid = movies_genre.mid and movies.pyear = '1992'
group by genre
go

/* Cleans buffers */
checkpoint
dbcc dropcleanbuffers

/* Drops indexes */
drop index genre_idx on movies_genre;
drop index mid_pyear_idx on movies;


/* Question 2b */

/* Query 1 */

/* Run Query 1 Batch Without Index */
go
select title
from actors, movies, roles
where actors.aid = roles.aid and roles.mid = movies.mid and actors.gender = 'M'
group by gender, title
having sum(case when gender = 'F' then 1 else 0 end) = 0
go

/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Creates indexes */
create index aid_idx on actors(aid);
create index mid_title_idx on movies(mid, title);
create index mid_aid_idx on roles(mid, aid);

/* Run Query 1 Batch With Index */
go
select title
from actors, movies, roles
where actors.aid = roles.aid and roles.mid = movies.mid and actors.gender = 'M'
group by gender, title
having sum(case when gender = 'F' then 1 else 0 end) = 0
go

/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Drops indexes */
drop index aid_idx on actors;
drop index mid_title_idx on movies;
drop index mid_aid_idx on roles;

/* Clean buffers */
checkpoint
dbcc dropcleanbuffers


/* Query 2 */

/* Run Query 2 Batch Without Index */
select title
from movies m
join roles r on m.mid = r.mid 
join actors a on r.aid = a.aid
group by gender, title
having sum(case when gender = 'F' then 1 else 0 end) = 0 and 
(case when gender = 'M' then 1 else 0 end) > 0

/* Clean buffers */
checkpoint
dbcc dropcleanbuffers

/* Creates indexes */
create index aid_idx on actors(aid);
create index mid_title_idx on movies(mid, title);
create index mid_aid_idx on roles(mid, aid);

/* Run Query 2 Batch With Index */
go
select title
from movies m
join roles r on m.mid = r.mid 
join actors a on r.aid = a.aid
group by gender, title
having sum(case when gender = 'F' then 1 else 0 end) = 0 and 
(case when gender = 'M' then 1 else 0 end) > 0
go

/* Drops indexes */
drop index aid_idx on actors;
drop index mid_title_idx on movies;
drop index mid_aid_idx on roles;

/* Clean buffers */
checkpoint
dbcc dropcleanbuffers