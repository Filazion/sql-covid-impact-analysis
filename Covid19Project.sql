--select * 
--from Covid19Project..CovidDeaths
--order by 3,4

--select * 
--from Covid19Project..CovidVaccinations
--order by 3,4

--select location, date, total_cases, total_deaths, (total_cases/population) * 100 as deathPercentage
--from Covid19Project..CovidDeaths
--where location like '%Canada%'
--order by 1,2

---total covid cases.


--- countries with highest infection rate campared to their respective population 

select location, population, MAX(total_cases) as highestInfectionCount, max((total_cases/population)) * 100 as maxInfectionRate
from Covid19Project..CovidDeaths
group by location, population
order by maxInfectionRate desc 

select location, population, date, MAX(total_cases) as highestInfectionCount, max((total_cases/population)) * 100 as maxInfectionRate
from Covid19Project..CovidDeaths
group by location, population, date
order by maxInfectionRate desc 

--- countries with highest death rate per calculation.

select location, MAX(cast(total_deaths as int)) as highestDeaths
from Covid19Project..CovidDeaths
where continent is not null
group by location, population
order by highestDeaths desc 

--- calculating the sum of total cases

select continent, SUM(cast(new_deaths as int)) as TotalDeathCount
from Covid19Project..CovidDeaths
where continent is not null
and location not in ('World', 'International', 'European Union')
group by continent
order by TotalDeathCount desc 

select location, MAX(cast(total_deaths as int)) as totalDeathCount
from Covid19Project..CovidDeaths
where continent is null
and location not in ('World', 'High-income countries', 'Upper-middle-income countries', 'European Union (27)', 'Lower-middle-income countries' , 'Low-income countries')
group by location
order by totalDeathCount desc 

select location, sum(cast(total_deaths as bigint)) as totalDeathCount
from Covid19Project..CovidDeaths
where continent is null
and location not in ('World', 'High-income countries', 'Upper-middle-income countries', 'European Union (27)', 'Lower-middle-income countries' , 'Low-income countries')
group by location
order by totalDeathCount desc 

--select continent, MAX(cast(total_deaths as int)) as totalDeathCount
--from Covid19Project..CovidDeaths
--where continent is not null
--group by continent
--order by totalDeathCount desc 

-- calculating the total number of new cases and new deaths globally

select --date, 
	sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, 
	sum(new_cases)/sum(cast(new_deaths as int)) * 100 as DeathPercentage
from Covid19Project..CovidDeaths
where continent is not null and new_deaths != 0
--group by date
order by DeathPercentage desc

select --date, 
	sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths, 
	sum(new_deaths)/sum(cast(new_cases as bigint)) * 100 as DeathPercentage
from Covid19Project..CovidDeaths
where continent is not null and total_cases != 0
--group by date
order by DeathPercentage desc


select top 10 * 
from Covid19Project..CovidVaccinations 
-- you can't just use limit in sql server
--limit 10;

---- joining the death and vaccination

select top 10 * 
from Covid19Project..CovidDeaths as death
join Covid19Project..CovidVaccinations as vac
on death.location = vac.location
and death.date = vac.date

-- getting total number population who got vaccinated. 

select death.continent, death.location, death.date, death.population, vac.new_vaccinations
from Covid19Project..CovidDeaths as death
join Covid19Project..CovidVaccinations as vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null and vac.new_vaccinations is not null
order by 1,2,3 


select death.continent, death.location, death.date, death.population, vac.new_vaccinations
--,sum(convert(int, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
,sum(cast(vac.new_vaccinations as bigint)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/death.population) * 100
from Covid19Project..CovidDeaths as death
join Covid19Project..CovidVaccinations as vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null and vac.new_vaccinations is not null
order by 2,3 


--- applying CTE (Common Table Expression) 
--- a temporary, named result set defined within the scope of a single Select, insert, update, delete, or merge statement

with PopvsVac (Continent, Location, Date, Population, NewVaccination, RollingPeopleVaccinated)
as (
select death.continent, death.location, death.date, death.population, vac.new_vaccinations
--,sum(convert(int, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
,sum(cast(vac.new_vaccinations as bigint)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/death.population) * 100
from Covid19Project..CovidDeaths as death
join Covid19Project..CovidVaccinations as vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null and vac.new_vaccinations is not null
--order by 2,3 
)
select *, (RollingPeopleVaccinated/Population) * 100 as RollingPeopleVaccinatedRate
from PopvsVac


---Creating Temporary table....

DROP Table if exists #PercentPopulationVaccinated
CREATE table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
select death.continent, death.location, death.date, death.population, vac.new_vaccinations
--,sum(convert(int, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
,sum(cast(vac.new_vaccinations as bigint)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/death.population) * 100
from Covid19Project..CovidDeaths as death
join Covid19Project..CovidVaccinations as vac
on death.location = vac.location
and death.date = vac.date
--where death.continent is not null and vac.new_vaccinations is not null
--order by 2,3 

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--- creating an SQL View for visualization

Create View PercentPopulationVaccinated as
select death.continent, death.location, death.date, death.population, vac.new_vaccinations
--,sum(convert(int, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
,sum(cast(vac.new_vaccinations as bigint)) over (partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/death.population) * 100
from Covid19Project..CovidDeaths as death
join Covid19Project..CovidVaccinations as vac
on death.location = vac.location
and death.date = vac.date
--where death.continent is not null and vac.new_vaccinations is not null
--order by 2,3

Select * from PercentPopulationVaccinated