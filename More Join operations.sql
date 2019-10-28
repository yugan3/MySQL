
More JOIN operations

This tutorial introduces the notion of a join. The database consists of three tables movie , actor and casting .

movie
id	title	yr	director	budget	gross 

actor
id	name 

casting
movieid	actorid	ord



1.
List the films where the yr is 1962 [Show id, title]

SELECT id, title FROM movie  WHERE yr=1962

2.
Give year of 'Citizen Kane'.

select yr from movie where title = 'Citizen Kane'

3.
List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

select id, title, yr from movie where title like '%Star Trek%' order by yr

4.
What id number does the actor 'Glenn Close' have?

select id from actor where name = 'Glenn Close'

5.
What is the id of the film 'Casablanca'

select id from movie where title = 'Casablanca'

6.
Obtain the cast list for 'Casablanca'.
what is a cast list?
Use movieid=11768, (or whatever value you got from the previous question)

select name from actor join casting on id = actorid where movieid = 11768

7.
Obtain the cast list for the film 'Alien'

select name from actor join casting on id = actorid where movieid = (select id from movie where title = 'Alien')

8.
List the films in which 'Harrison Ford' has appeared

select title from movie join casting on id = movieid where actorid = (select id from actor where name = 'Harrison Ford')

9.
List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select title from movie join casting on id = movieid where actorid = (select id from actor where name = 'Harrison Ford') and ord!=1

10.
List the films together with the leading star for all 1962 films.

select m.title, a.name from casting c
join movie m on c.movieid = m.id 
join actor a on c.actorid = a.id where c.ord = 1 and m.yr = 1962

11.
Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

12.
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
Did you get "Little Miss Marker twice"?

select title, name from casting c 
join movie m on c.movieid = m.id 
join actor a on a.id = c.actorid where c.ord = 1 and c.movieid in (select movieid from casting join actor on actorid = id where name = 'Julie Andrews')

13.
Obtain a list, in alphabetical order, of actors who have had at least 30 starring roles.

select name from actor join (select ord, actorid from casting where ord =1) j on id = j.actorid group by name having count(j.ord)>=30 order by name

14.
List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

select title, count(actorid) from movie join casting on id = movieid  where yr = 1978 group by title order by count(actorid) desc,title

15.
List all the people who have worked with 'Art Garfunkel'.

select distinct name from casting c 
join actor a on c.actorid = a.id
where movieid in (select c.movieid from casting c 
join actor a on c.actorid = a.id
join movie m on m.id = c.movieid where a.name = 'Art Garfunkel') and
name != 'Art Garfunkel'  



