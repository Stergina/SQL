# Movie Database

**Objective**:  
The aim of this project is the practical application of indexing and optimizing SQL queries. The database contains information about movies.
You will first create the database and upload the data to the tables, following the instructions below. Then you will answer the questions of the job.


**Implementation**:  

- Question 1

Create a single index that speeds up the execution of all three queries below.
  *\-select title from movies where pyear between 1990 and 2000*
  
  *\-select pyear, title from movies where pyear between 1990 and 2000*
  
  *\-select title, pyear from movies where pyear between 1990 and 2000*
  
  *\-order by pyear, title*

- Question 2

The following two queries display the total number of ratings per movie code and user code respectively where the frequency of queries is the same. Assuming you can create a single index, which index would you choose to create?
  *\-select mid, count (rating)*
  
  *\-from user_movies group by mid order by mid*
  
  *\-select userid, count (rating)*
  
  *\-from user_movies group by userid order by userid*
