USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    table_name, table_rows
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_SCHEMA = 'imdb';



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_nulls,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_nulls,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_nulls,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_nulls,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_nulls,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_nulls,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worldwide_gross_income_nulls,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS language_nulls,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_nulls
FROM
    movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Part one of the question
SELECT 
    Year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;

-- Part two of the question
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS count_2019_India_Usa
FROM
    movie
WHERE
    (country LIKE '%USA%'
        OR country LIKE '%India%')
        AND year = 2019;
	

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT
    (g.genre) AS unique_genre
FROM
    movie AS m
        JOIN
    genre AS g ON m.id = g.movie_id
ORDER BY g.genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    COUNT(movie_id) AS No_of_movies, genre
FROM
    movie AS m
        JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY genre;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with count_of_genres as
(
select movie_id, count(genre) as num_of_genres
from genre
group by movie_id
having num_of_genres = 1
)
select count(*) as Movies_with_one_genre
from count_of_genres;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre AS Genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie AS m
        JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY genre;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT g.genre as genre, COUNT(g.movie_id) as movie_count,
RANK() OVER(
    ORDER BY 
    COUNT(g.movie_id) desc 
    ) genre_rank
FROM movie as m
INNER JOIN genre as g
ON m.id = g.movie_id
 GROUP BY genre;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select m.title as title, avg_rating,
rank () over(order by avg_rating desc) as movie_rank
from movie as m
join ratings as r
on m.id = r.movie_id
group by movie_id 
limit 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC;




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT(r.movie_id) as movie_count,
RANK() OVER(
    ORDER BY 
    COUNT(r.movie_id) desc 
    ) prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE r.avg_rating > 8 and production_company is not null
GROUP BY production_company;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, COUNT(id) AS movie_count
FROM
    movie AS m
        JOIN
    genre AS g ON m.id = g.movie_id
        JOIN
    ratings AS r ON g.movie_id = r.movie_id
WHERE
    Year = 2017
        AND MONTH(date_published) = 03
        AND country LIKE '%usa%'
        AND total_votes > 1000
GROUP BY genre;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    movie AS m
        JOIN
    genre AS g ON m.id = g.movie_id
        JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    r.avg_rating > 8 AND m.title LIKE 'The%'
GROUP BY title;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(title) AS movie_count
FROM
    movie AS m
        LEFT JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND median_rating = 8;



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
    m.languages, SUM(r.total_votes)
FROM
    movie AS m
        JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.languages LIKE '%german%'
        OR m.languages LIKE '%italian%'
GROUP BY m.languages;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with genre_ranks as
(
select g.genre, count(g.movie_id) as movie_count, dense_rank() over(order by count(g.movie_id) desc) as genre_rank
from genre as g
inner join ratings as r
on g.movie_id=r.movie_id
where r.avg_rating>8
group by g.genre
order by movie_count desc
limit 3
),
directors as
(
select n.name, count(g.movie_id) from names as n
inner join director_mapping as d
on n.id=d.name_id
inner join ratings as r
on d.movie_id=r.movie_id
inner join genre as g
on r.movie_id=g.movie_id, genre_ranks
where r.avg_rating>8 and g.genre in (genre_ranks.genre)
group by n.name
order by count(g.movie_id) desc
limit 3
)
select * from directors;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    n.name AS actor_name, COUNT(r.movie_id) AS movie_count
FROM
    names AS n
        INNER JOIN
    role_mapping AS rm ON n.id = rm.name_id
        INNER JOIN
    movie AS m ON m.id = rm.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    r.median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company| vote_count			|	prod_comp_rank     |
+------------------+--------------------+---------------------+
| The Archers	   |		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.production_company, sum(total_votes) as vote_count,
RANK() OVER(
    ORDER BY 
    sum(total_votes) desc
    ) prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
#WHERE production_company is not null
GROUP BY production_company 
limit 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select names.name as actor_name,
	sum(ratings.total_votes) as total_votes,
	count(movie.id) as movie_count,
	round(sum(ratings.avg_rating * ratings.total_votes )/sum(ratings.total_votes),2) as actor_avg_rating,
dense_rank() over (order by ratings.avg_rating desc, sum(ratings.total_votes) desc) as actor_rank
from movie movie join ratings ratings
on movie.id = ratings.movie_id
join role_mapping role_mapping on movie.id = role_mapping.movie_id
join names names on role_mapping.name_id = names.id
where movie.country like '%India%' AND category = 'actor'
group by names.name having count(movie.id) >= 5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name, sum(r.total_votes) as total_votes, count(r.movie_id) as movie_count, 
	round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as average_rating, 
	dense_rank() over(order by round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) desc) as actress_ranking
from names as n
inner join role_mapping as rm 
on n.id=rm.name_id
inner join movie as m 
on rm.movie_id=m.id
inner join ratings as r
on m.id=r.movie_id
where rm.category='actress' and m.country = 'India' and m.languages like '%hindi%'
group by n.name
having movie_count>=3
limit 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with thriller_movies as 
(
select title,
		avg_rating
from genre g inner join movie m on
g.movie_id= m.id inner join ratings r on
m.id= r.movie_id
where genre= 'thriller'
)
select *,
		(case
        when avg_rating >=8 then 'Superhit movie'
        when avg_rating >= 7 and avg_rating <8 then 'Hit movie'
        when avg_rating >= 5.0 and avg_rating < 7 then 'One-time-watch movies'
        when avg_rating < 5.0 then 'Flop movies'
    end) as 'Rating'
from thriller_movies;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select genre, 
round(avg(duration),2) as avg_duration, 
sum(round(avg(duration),2)) over (order by genre rows unbounded preceding) as running_total_duration, 
avg(round(avg(duration),2)) over(order by genre rows 13 preceding) as moving_avg_duration
from movie m inner join genre g on 
m.id = g.movie_id
group by genre
order by genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- Analysed the worlwide_gross_income are in '$' and 'INR'. So it should be in same scale so I convert 'INR' to '$' by dividing 73.60 

with worlwide_gross_income_in_doller as (
select 
	m.id,
	m.year,
    m.title as movie_name,
	concat('$ ', round(SUBSTRING_INDEX(m.worlwide_gross_income,' ',-1)/73.60)) as worlwide_gross_income
from movie m
where m.worlwide_gross_income not like '%$%'
union
select 
	m.id,
	m.year,
    m.title as movie_name,
	m.worlwide_gross_income as worlwide_gross_income 
from movie m
where worlwide_gross_income like '%$%'
),
movie_rank_gross_income as
(
select
	g.genre,
	gid.year,
    gid.movie_name,
    gid.worlwide_gross_income,
	ROW_NUMBER() over(
		partition by year
		order by 
			year desc,
            length(gid.worlwide_gross_income) desc,
            gid.worlwide_gross_income desc) 
					as movie_rank
from worlwide_gross_income_in_doller gid
inner join genre g
	on gid.id=g.movie_id
where g.genre in ('Drama','Comedy','Thriller')
)
select * from movie_rank_gross_income 
where movie_rank <=5;
-- and from the above analyses we had found that the top 3 Genres based on most number of movies are 'Drama','Comedy','Thriller'


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT(r.movie_id) as movie_count,
RANK() OVER(
    ORDER BY 
    COUNT(id) DESC
    ) prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE r.median_rating >= 8 and production_company is not null and POSITION(',' IN languages)>0
GROUP BY production_company
limit 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actress_name, SUM(total_votes) AS total_votes,
			COUNT(m.id) AS movie_count,
            ROUND(SUM(r.avg_rating*r.total_votes)/ SUM(r.total_votes),2) AS actress_avg_rating,
			DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS actress_rank
	FROM genre AS g
    INNER JOIN movie AS m
		ON g.movie_id = m.id
    INNER JOIN ratings AS r
		ON m.id = r.movie_id
	INNER JOIN role_mapping AS rm
		ON m.id = rm.movie_id
	INNER JOIN names AS n
		ON rm.name_id = n.id
	WHERE genre = 'drama' AND category = 'actress'
    AND avg_rating>=8
    GROUP BY name
    LIMIT 3;

/* Q29.Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH a2 AS
(
	WITH a1 AS
	(
		SELECT dm.name_id AS director_id, 
			   n.name AS director_name, 
               date_published, 
			   LEAD(date_published ,1) OVER (PARTITION BY dm.name_id ORDER BY date_published) AS next_date
		FROM names AS n, 
			 director_mapping AS dm, 
             movie AS m  
		where n.id = dm.name_id and dm.movie_id = m.id 
) 
SELECT * 
FROM a1 
WHERE next_date IS NOT NULL
)
SELECT director_id, director_name, 
	   COUNT(DISTINCT(m.id)) AS number_of_movies, 
       ROUND(AVG(datediff(next_date, a.date_published))) AS avg_inter_movie_days,
	   ROUND(AVG(avg_rating),2) AS avg_rating, 
       SUM(DISTINCT(total_votes)) AS total_votes, 
       MIN(avg_rating) AS min_rating,  
       MAX(avg_rating) AS max_rating, 
	   SUM(DISTINCT(duration)) AS total_duration  
FROM a2 AS a, 
	movie AS m , 
    director_mapping AS dm, 
    ratings AS r 
WHERE a.director_id = dm.name_id AND dm.movie_id = m.id AND m.id= r.movie_id 
GROUP BY director_id 
ORDER BY COUNT(m.id) DESC, ROUND(AVG(avg_rating),2) DESC 
LIMIT 9;


