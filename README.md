# 🌍 Global COVID-19 Data Analysis & Visualization with SQL Server + Tableau  

![SQL](https://img.shields.io/badge/SQL_Server-Data_Analysis-blue?logo=microsoftsqlserver)
![ETL](https://img.shields.io/badge/ETL-Data_Transformation-orange)
![Visualization](https://img.shields.io/badge/Tableau-Dashboard-yellow?logo=tableau)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🧠 Overview  
This project explores **global COVID-19 trends** using **SQL Server** for data transformation and **Tableau** for visual analytics.  
The dataset combines case, death, and vaccination data to provide insights into infection rates, mortality ratios, and vaccination progress across continents and countries.  

The project demonstrates the use of **window functions**, **CTEs**, and **aggregations** to extract key metrics — later visualized in Tableau to tell a clear data-driven story.

---

## 🎯 Objective  
To quantify and visualize the global impact of COVID-19 by analyzing:  
- Total and daily cases/deaths across time and geography  
- Rolling vaccination progress  
- Infection and mortality rates per population  
- Continent-level comparisons and trends  

---

## 📊 Dataset  

| Property | Description |
|-----------|-------------|
| **Source** | [Our World in Data – COVID-19 Dataset](https://ourworldindata.org/covid-deaths) |
| **Size** | ~85,000 rows × 20 columns |
| **Tables Used** | `CovidDeaths`, `CovidVaccinations` |
| **Key Fields** | `location`, `date`, `population`, `new_cases`, `new_deaths`, `new_vaccinations` |
| **Timeframe** | 2020 – 2024 |

---

## ⚙️ Tools & Technologies  

| Tool | Purpose |
|------|----------|
| **Microsoft SQL Server** | Data cleaning, aggregation, and KPI computation |
| **CTE / Window Functions** | Rolling calculations and trend analysis |
| **Power BI / Tableau** | Dashboard visualization and storytelling |
| **Joins & Aggregations** | Combining case and vaccination datasets |

---

## 🧩 Approach  

### 1️⃣ Data Loading  
- Imported `CovidDeaths.csv` and `CovidVaccinations.csv` datasets into SQL Server using **Import & Export Wizard**.  
- Created two relational tables with identical `location` and `date` keys for JOIN operations.  

---

### 2️⃣ Cleaning & Standardization  
- Removed null and continent-level aggregates to focus on country data.  
- Casted numerical fields properly to ensure arithmetic consistency.

```sql
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

### 3⃣ KPI Calculation — Total Cases, Deaths & Mortality Rate


### 5⃣ Infection Rate Per Population

### 6⃣ Vaccination Progress Using Window Functions

### 7⃣ Creating Views for Tableau


---

### ✅ Recommended Folder Structure
