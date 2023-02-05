select * 
from PortfolioProject..CovidDeaths$

--select * 
--from PortfolioProject..CovidVaccinations$



--Select data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject..CovidDeaths$
order by 1,2


--Looking at total cases vs total death and death percentage 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 As DeathPercentage  
from PortfolioProject..CovidDeaths$
order by 1,2


--Looking at total cases vs total death and death percentage for united states 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 As DeathPercentage  
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at total cases vs population for Us country 
select location,date,total_cases,population,(total_cases/population)*100 As TotalCasesPercentage
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at countries with highest Infection rate compared to population 
select location,population,max(total_cases)as Highest_Infected_Count,max((total_cases/population)*100) as HighestInfectedPercentage
from PortfolioProject..CovidDeaths$
--where location like '%states%'
Group by location,population
order by HighestInfectedPercentage desc


--showing countries with highest death count as per population 

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null 
Group by location
order by TotalDeathCount desc

--showing world in above query 
select * 
from PortfolioProject..CovidDeaths$
where continent is not null 

--Lets break thing down by continent
---showing continent with highest death count per location 

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null 
Group by continent
order by TotalDeathCount desc


---Global Numbers
select date,sum(total_cases) as TotalCases,sum(cast(total_deaths as int)) as TotalDeath, (sum(cast(total_deaths as int))/sum(total_cases))*100
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

--overall number
select sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeath, (sum(cast(new_deaths as int))/sum(new_cases))*100 as deathpercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1,2


--Join Looking at total populations vs vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(INT,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) AS ROLLING_VACCINATION 
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location and dea.date= vac.date
where dea.continent is not null
order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_vaccination
--, (rolling_vaccination/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
-- order by 2,3

----CTE

with popvsvac (continent,location,date,population,new_vaccinations)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, (rolling_vaccination/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 1,2 
)

select * from popvsvac


---CREATE TEMP TABLE 

create table #percentpopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric
)

insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, (rolling_vaccination/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 1,2 

Select * from #percentpopulationvaccinated