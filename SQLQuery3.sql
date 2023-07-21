--Select*
--From PortfolioProject.dbo.CovidDeaths
--Where continent is not null
--Order by 3,4

--Select*
--From PortfolioProject.dbo.CovidVacinnation
--Order by 3,4


--Select Location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject.dbo.CovidDeaths
--Where continent is not null
--Order by 1,2



--Looking at Total Cases Vs Total Deaths
-- Showing the likiehood of contracting covid in U.S

--Select Location, date, total_cases, total_deaths, (CONVERT(DECIMAL(18,2), total_deaths) / CONVERT(DECIMAL(18,2), total_cases) )*100 as DeathPercentage
--From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
--and continent is not null 
--Order by 1,2

--Looking at total cases vs population
--Showing Percentage of population that got covid 

--Select Location, date,population, total_cases, ( total_cases / population )*100 as PercentagePopulationInfected
--From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
--and continent is not null 
--Order by 1,2

-- Countries with Highest Infection Rate compared to Population

--Select Location,population, Max(total_cases) as HighestInfectionCount, Max((total_cases / population)*100) as PercentagePopulationInfected
--From PortfolioProject.dbo.CovidDeaths
--Group By Location,population
--Order by PercentagePopulationInfected Desc

--Countries with Highest Death Count per Population

--Select Location,population, Max(cast(total_deaths as int)) as HighestdeathCount
--From PortfolioProject.dbo.CovidDeaths
--Where continent is not null
--Group By Location,population
--Order by HighestdeathCount Desc

--Breaking Things down by continent
-- Showing contintents with the highest death count per population

--Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--Where continent is not null 
--Group by continent
--order by TotalDeathCount desc

--Global Numbers

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
----Group By date
--order by 1,2

--Looking at Total Population vs Vaccination
--Use CTE

--With PopvsVac (Continent,Location, Date, Population, New_Vaccinations,RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,SUM(convert(bigint,vacc.new_vaccinations)) Over (Partition By dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
----(Max(RollingPeopleVaccinated)/population)
--From PortfolioProject.dbo.CovidDeaths as dea
--Join PortfolioProject.dbo.CovidVacinnation as vacc
--	on dea.location=vacc.location 
--	and dea.date=vacc.date
--Where dea.continent is not null
----Order By 1,2,3
--)

--Select*,(RollingPeopleVaccinated/Population)*100
--From PopvsVac




--Temp Table
--DROP Table if exists  #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(225),
--Location nvarchar(225),
--Date datetime,
--Population numeric,
--New_Vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--Insert into  #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,SUM(convert(bigint,vacc.new_vaccinations)) Over (Partition By dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--From PortfolioProject.dbo.CovidDeaths as dea
--Join PortfolioProject.dbo.CovidVacinnation as vacc
--	on dea.location=vacc.location 
--	and dea.date=vacc.date
--Where dea.continent is not null
----Order By 1,2,3



--Select*,(RollingPeopleVaccinated/Population)*100
--From #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,SUM(convert(bigint,vacc.new_vaccinations)) Over (Partition By dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVacinnation as vacc
	on dea.location=vacc.location 
	and dea.date=vacc.date
Where dea.continent is not null
--Order By 1,2,3
