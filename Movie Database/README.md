# Movie Database

**Objective**:  
The aim of this project is the practical application of indexing and optimizing SQL queries. The database contains information about movies.
You will first create the database and upload the data to the tables, following the instructions below. Then you will answer the questions of the job.


**Implementation**:  

- Question 1: Create a single index that speeds up the execution of all three queries below.
  *select title from movies where pyear between 1990 and 2000*
  
  *select pyear, title from movies where pyear between 1990 and 2000*
  
  *select title, pyear from movies where pyear between 1990 and 2000*
  
  *order by pyear, title*


- Question 2: The following two queries display the total number of ratings per movie code and user code respectively where the frequency of queries is the same. Assuming you can create a single index, which index would you choose to create?

  *select mid, count (rating)*
  
  *from user_movies group by mid order by mid*
  
  *select userid, count (rating)*
  
  *from user_movies group by userid order by userid*



- Question 3.1: The following question displays the titles of the movies that belong to the 'Adventure' category or to the 'Action' category or to both categories:

  *select title*
  
  *from movies, movies_genre*
  
  *where movies.mid = movies_genre.mid and genre = 'Adventure'*
  
  *UNION*
  
  *select title*
  
  *from movies, movies_genre*
  
  *where movies.mid = movies_genre.mid and genre = 'Action'*
  
  
  Write a more efficient query in SQL that gives the same results as above (the order of the results does not matter). Create an appropriate index or   indexes that speed up the execution of the query you wrote.




- Question 3.2: Consider the following question in natural language: "Show the titles of films in which only male actors participate." Write at least two different queries in SQL that answer the above question. Then create appropriate indexes to speed up query execution. The aim is to come up with a query, which in combination with appropriate indexes, you consider to be the most cost-effective (lower execution cost).
