SELECT COUNT(language), language FROM countrylanguage GROUP BY language HAVING COUNT(language) > 4;

SELECT language, (country.population*(countrylanguage.percentage/100)) FROM country, countrylanguage WHERE country.code = countrylanguage.countrycode;

SELECT SUM(ROUND(poplanguage, 2)) AS totalspeakers, language FROM (SELECT countrylanguage.*, population, ((percentage/100)*population) AS poplanguage
FROM country, countrylanguage
WHERE country.code = countrylanguage.countrycode) AS t1
GROUP BY language;

SELECT COUNT(language), name FROM country, countrylanguage WHERE country.code = countrylanguage.countrycode GROUP BY name;

SELECT name, population FROM country 