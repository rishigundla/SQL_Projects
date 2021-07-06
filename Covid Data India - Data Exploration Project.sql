/*
COVID 19 India Data Exploration 
This Dataset Contains data until 5th July 2021
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


/* How is the overall stats of India looks like:- */
SELECT 
	MAX(total_cases) as total_cases, 
	MAX(total_deaths) as total_deaths, 
    population,
    MAX(total_cases)/population as overall_infection_rate,
    MAX(total_deaths)/MAX(total_cases) as overall_death_rate
FROM covid_death;

/* Selecting the data that I will work on */
SELECT date, total_cases, new_cases, total_deaths, population
FROM covid_death
ORDER BY date;

/* Calulating the Death Percentage */
SELECT date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
FROM covid_death
ORDER BY date;

/* Which Day the Death Percentage was highest */
SELECT date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
FROM covid_death
ORDER BY death_percentage DESC;

/* Which Day the Death Percentage was highest for year 2020 */
SELECT date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
FROM covid_death
WHERE date between '2020-01-01' AND '2020-12-31'
ORDER BY death_percentage DESC;

/* Which Day the Death Percentage was highest for year 2021 */
SELECT date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
FROM covid_death
WHERE date between '2021-01-01' AND '2021-12-31'
ORDER BY death_percentage DESC;

/* Calulating Infection Rate per Day */
SELECT date, total_cases, population, (total_cases/population)*100 as infection_rate
FROM covid_death
ORDER BY date;

/* Joining Covid Death Table and Covid Vaccination Table */
SELECT *
FROM covid_death 
JOIN covid_vaccination 
	USING(date);

/* Calulating Running Total of New Vaccinated*/
SELECT cd.date, 
	   cd.total_cases, 
       cd.total_deaths, 
       cv.new_vaccinations,
       SUM(cv.new_vaccinations) OVER (order by cd.date) AS rolling_total_vaccination,
       ((SUM(cv.new_vaccinations) OVER (order by cd.date))/population)*100 AS running_vaccination_rate
FROM covid_death cd
JOIN covid_vaccination cv
	USING(date);
    

/* Calulating Running Vaccination Rate*/
SELECT cd.date, 
	   cd.total_cases, 
       cd.total_deaths, 
       cv.new_vaccinations,
       SUM(cv.new_vaccinations) OVER (order by cd.date) AS rolling_total_vaccination,
       ((SUM(cv.new_vaccinations) OVER (order by cd.date))/population)*100 AS running_vaccination_rate
FROM covid_death cd
JOIN covid_vaccination cv
	USING(date);
    
/* Calulating Test per Cases*/
SELECT cd.date, 
	   cv.total_tests, 
       cd.total_cases, 
	   (cv.total_tests/cd.total_cases) AS test_per_cases
FROM covid_death cd
JOIN covid_vaccination cv
	USING(date);
    


