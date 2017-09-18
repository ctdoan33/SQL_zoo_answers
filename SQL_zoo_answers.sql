-- SELECT basics
-- 1
SELECT population FROM world
WHERE name = 'Germany'
-- 2
SELECT name, population FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');
-- 3
SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000

-- SELECT from world
-- 1
SELECT name, continent, population FROM world
-- 2
SELECT name FROM world
WHERE population >= 200000000
-- 3
SELECT name, gdp/population AS per_capita_GDP FROM world
WHERE population > 200000000
-- 4
SELECT name, population/1000000 AS pop_in_millions FROM world
WHERE continent = 'South America'
-- 5
SELECT name, population FROM world
WHERE name IN ('France', 'Germany', 'Italy')
-- 6
SELECT name FROM world
WHERE name LIKE '%United%'
-- 7
SELECT name, population, area FROM world
WHERE population > 250000000 OR area > 3000000
-- 8
SELECT name, population, area FROM world
WHERE population > 250000000 XOR area > 3000000
-- 9
SELECT name, ROUND(population/1000000, 2) AS pop_in_millions,
ROUND(gdp/1000000000, 2) AS gdp_in_billions FROM world
WHERE continent = 'South America'
-- 10
SELECT name, ROUND(gdp/population,-3) AS per_capita_gdp FROM world
WHERE gdp > 1000000000000
-- 11
SELECT name, capital FROM world
WHERE LENGTH(name) = LENGTH(capital)
-- 12
SELECT name, capital FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1) AND name <> capital
-- 13
SELECT name FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%'
AND name LIKE '%o%' AND name LIKE '%u%' AND name NOT LIKE '% %'

-- SELECT from nobel
-- 1
SELECT yr, subject, winner FROM nobel
WHERE yr = 1950
-- 2
SELECT winner FROM nobel
WHERE yr = 1962 AND subject = 'Literature'
-- 3
SELECT yr, subject FROM nobel
WHERE winner = 'Albert Einstein'
-- 4
SELECT winner FROM nobel
WHERE subject = 'Peace' AND yr >= 2000
-- 5
SELECT * FROM nobel
WHERE subject = 'Literature' AND yr >= 1980 AND yr <= 1989
-- 6
SELECT * FROM nobel
WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama')
-- 7
SELECT winner FROM nobel
WHERE winner LIKE 'John%'
-- 8
SELECT * FROM nobel
WHERE (subject = 'Physics' AND yr = 1980) OR (subject = 'Chemistry' AND yr = 1984)
-- 9
SELECT * FROM nobel
WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine')
-- 10
SELECT * FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910) OR (subject = 'Literature' AND yr >=2004)
-- 11
SELECT * FROM nobel
WHERE winner = 'Peter Grünberg'
-- 12
SELECT * FROM nobel
WHERE winner = 'EUGENE O''NEILL'
-- 13
SELECT winner, yr, subject FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner
-- 14
SELECT winner, subject FROM nobel
WHERE yr=1984
ORDER BY (subject IN ('Physics','Chemistry')) ASC, subject, winner

-- SELECT in SELECT
-- 1
SELECT name FROM world
WHERE population > (SELECT population FROM world WHERE name='Russia')
-- 2
SELECT name FROM world
WHERE continent = 'Europe' AND gdp/population >
(SELECT gdp/population FROM world WHERE name='United Kingdom')
-- 3
SELECT name, continent FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name
-- 4
SELECT name, population FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada')
AND population < (SELECT population FROM world WHERE name = 'Poland')
-- 5
SELECT name, CONCAT(ROUND(population/
(SELECT population FROM world WHERE name = 'Germany')*100), '%') AS '%_pop_Germany' FROM world
WHERE continent = 'Europe'
-- 6
SELECT name FROM world
WHERE gdp > ALL(SELECT gdp FROM world WHERE continent = 'Europe' AND gdp > 0)
-- 7
SELECT continent, name, area FROM world x
WHERE area >= ALL(SELECT area FROM world y WHERE y.continent=x.continent AND area>0)
-- 8
SELECT continent, name FROM world x
WHERE name <= ALL(SELECT name FROM world y WHERE y.continent=x.continent)
-- 9
SELECT name, continent, population FROM world x
WHERE 25000000 >= ALL(SELECT population FROM world y WHERE y.continent=x.continent)
-- 10
SELECT name, continent FROM world x
WHERE population > ALL(SELECT population*3 FROM world y
WHERE y.continent=x.continent AND y.name <> x.name)

-- SUM and COUNT
-- 1
SELECT SUM(population) FROM worldSELECT SUM(population) AS total_population FROM world
-- 2
SELECT DISTINCT continent FROM world
-- 3
SELECT SUM(gdp) AS total_gdp FROM world
WHERE continent = 'Africa'
-- 4
SELECT COUNT(name) AS total_countries FROM world
WHERE area >= 1000000
-- 5
SELECT SUM(population) AS total_population FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')
-- 6
SELECT continent, COUNT(name) AS number_of_countries FROM world
GROUP BY continent
-- 7
SELECT continent, COUNT(name) AS number_of_countries FROM world
WHERE population >= 10000000
GROUP BY continent
-- 8
SELECT continent FROM world
GROUP BY continent HAVING SUM(population) >= 100000000

-- JOIN
-- 1
SELECT matchid, player FROM goal 
WHERE teamid = 'GER'
-- 2
SELECT id, stadium, team1, team2 FROM game
WHERE id = 1012
-- 3
SELECT player, teamid, stadium, mdate FROM game
JOIN goal ON id=matchid
WHERE teamid = 'GER'
-- 4
SELECT team1, team2, player FROM game
JOIN goal ON id=matchid
WHERE player LIKE 'Mario%'
-- 5
SELECT player, teamid, coach, gtime FROM goal
JOIN eteam ON id=teamid
WHERE gtime<=10
-- 6
SELECT mdate, teamname FROM game
JOIN eteam ON team1 = eteam.id
WHERE coach = 'Fernando Santos'
-- 7
SELECT player FROM goal
JOIN game ON id = matchid
WHERE stadium = 'National Stadium, Warsaw'
-- 8
SELECT DISTINCT player FROM goal
JOIN game ON matchid = id 
WHERE (team1='GER' OR team2='GER') AND teamid <> 'Ger'
-- 9
SELECT teamname, COUNT(*) AS total_goals FROM eteam
JOIN goal ON id=teamid
GROUP BY teamname
-- 10
SELECT stadium, COUNT(*) FROM game
JOIN goal ON id = matchid
GROUP BY stadium
-- 11
SELECT matchid, mdate, COUNT(*) FROM game
JOIN goal ON matchid = id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid, mdate
-- 12
SELECT matchid, mdate, COUNT(*) FROM goal
JOIN game ON id = matchid
WHERE teamid = 'GER'
GROUP BY matchid, mdate
-- 13
SELECT mdate, team1, SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2 FROM game
LEFT JOIN goal ON matchid = id
GROUP BY mdate, matchid, team1, team2

-- More Join
-- 1
SELECT id, title FROM movie
WHERE yr=1962
-- 2
SELECT yr FROM movie
WHERE title = 'Citizen Kane'
-- 3
SELECT id, title, yr FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr
-- 4
SELECT id FROM actor
WHERE name = 'Glenn Close'
-- 5
SELECT id FROM movie
WHERE title = 'Casablanca'
-- 6
SELECT name FROM actor
JOIN casting ON id = actorid
WHERE movieid = 11768
-- 7
SELECT name FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movieid = movie.id
WHERE title = 'Alien'
-- 8
SELECT title FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movieid = movie.id
WHERE name = 'Harrison Ford'
-- 9
SELECT title FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movieid = movie.id
WHERE name = 'Harrison Ford' AND ord <> 1
-- 10
SELECT title, name FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movieid = movie.id
WHERE ord = 1 AND yr = 1962
-- 11
SELECT yr, COUNT(title) AS total_movies FROM movie
JOIN casting ON movie.id=movieid
JOIN actor ON actorid=actor.id
WHERE name = 'John Travolta'
GROUP BY yr HAVING COUNT(title) > 2
-- 12
SELECT title, name FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE ord=1 AND movie.id IN
(SELECT movieid FROM casting JOIN actor ON casting.actorid = actor.id
WHERE name = 'Julie Andrews')
-- 13
SELECT name FROM actor
JOIN casting ON actor.id = casting.actorid
WHERE ord=1
GROUP BY name HAVING COUNT(ord) >= 30
ORDER BY name;
-- 14
SELECT title, COUNT(actorid) AS total_actors FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE yr=1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title
-- 15
SELECT name FROM casting
JOIN actor ON casting.actorid = actor.id
WHERE movieid IN
(SELECT movieid FROM casting JOIN actor ON actorid=id WHERE name = 'Art Garfunkel')
AND name <> 'Art Garfunkel'

-- Using NULL
-- 1
SELECT name FROM teacher
WHERE dept IS NULL
-- 2
SELECT teacher.name, dept.name FROM teacher
INNER JOIN dept ON (teacher.dept=dept.id)
-- 3
SELECT teacher.name, dept.name FROM teacher
LEFT JOIN dept ON (teacher.dept=dept.id)
-- 4
SELECT teacher.name, dept.name FROM teacher
RIGHT JOIN dept ON (teacher.dept=dept.id)
-- 5
SELECT name, COALESCE(mobile, '07986 444 2266') FROM teacher
-- 6
SELECT teacher.name, COALESCE(dept.name, 'None') FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id
-- 7
SELECT COUNT(name), COUNT(mobile) FROM teacher
-- 8
SELECT dept.name, COUNT(teacher.id) FROM teacher
RIGHT JOIN dept ON teacher.dept = dept.id
GROUP BY dept.name
-- 9
SELECT name, CASE
WHEN dept = 1 OR dept = 2 THEN 'Sci'
ELSE 'Art' END FROM teacher
-- 10
SELECT name, CASE
WHEN dept = 1 OR dept = 2 THEN 'Sci'
WHEN dept = 3 THEN 'Art'
ELSE 'None' END FROM teacher

-- Self JOIN
-- 1
SELECT COUNT(id) AS total_stops FROM stops
-- 2
SELECT id FROM stops
WHERE name = 'Craiglockhart'
-- 3
SELECT id, name FROM stops
JOIN route ON stops.id = route.stop
WHERE num = '4' and company = 'LRT'
-- 4
SELECT company, num, COUNT(*) FROM route
WHERE stop=149 OR stop=53
GROUP BY company, num HAVING COUNT(*) = 2
-- 5
SELECT a.company, a.num, a.stop, b.stop FROM route a
JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 and b.stop=149
-- 6
SELECT a.company, a.num, stopa.name, stopb.name FROM route a
JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN stops stopa ON (a.stop=stopa.id)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'
-- 7
SELECT DISTINCT a.company, a.num FROM route a
JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 and b.stop=137
-- 8
SELECT a.company, a.num FROM route a
JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN stops stopa ON (a.stop=stopa.id)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='Tollcross'
-- 9
SELECT name, a.company, a.num FROM route a
JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN stops ON a.stop = stops.id
WHERE a.company = 'LRT' AND b.stop=53
-- 10
SELECT DISTINCT a.num, a.company, stopb.name ,  c.num,  c.company FROM route a
JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN ( route c JOIN route d ON (c.company = d.company AND c.num= d.num))
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
JOIN stops stopc ON (c.stop = stopc.id)
JOIN stops stopd ON (d.stop = stopd.id)
WHERE  stopa.name = 'Craiglockhart' AND stopd.name = 'Sighthill' AND  stopb.name = stopc.name
ORDER BY LENGTH(a.num), b.num, stopb.id, LENGTH(c.num), d.num