# Productivity Growth and the Road to Net Zero
## Internalising Greenhouse Gas Emissions in Productivity Growth — OECD Manufacturing & Construction Sectors (2010–2017)

Evaluating the Impact of Internalising Undesirable Outputs (i.e., GHG) in the Productivity Growth and Efficiency of the Manufacturing & Construction Sectors, using Econometric approach on Panel Data from 21 OECD Countries.

## Abstract

The study analyses the **manufacturing and construction sectors** of **21 OECD countries** between **2010 and 2017** to evaluate the impact of **internalising greenhouse gas (GHG) emissions** on productivity growth. Using econometric modelling and panel data analysis, the research develops and tests a novel methodology for incorporating environmental externalities directly into a production function.

The data were sourced from the **OECD STAN** and **OECD.Stat** databases and then combined to create a panel data set which includes key production variables, i.e., **gross capital stock**, **labour total hours worked**, **gross value added**, and **sector-specific GHG emissions**. After comparing multiple specifications, a **Cobb–Douglas functional form** was selected as the most suitable representation of the sector’s production process.

A new factor, the **Environmental Profitability Requirement (EPR)**, was formulated and introduced as a mechanism for internalising GHG emissions within the production function. The EPR represents the degree to which environmental constraints influence economic output, providing a more realistic reflection of production efficiency under sustainability pressures. The EPR method was compared with a conventional **carbon-pricing aggregation approach**, which applied a uniform price of **USD $60 per tCO₂e** — the midpoint of the IPCC’s 2020 carbon price range. Consistent with limitations observed in the literature, the carbon-pricing method showed negligible effects on productivity measurement. In contrast, the EPR framework proved significantly more effective in capturing the trade-off between environmental constraints and output sustainability.

The econometric analysis was conducted using **Pooled Corrected Ordinary Least Squares (COLS)** and **Random Effects (RE)** estimators across two scenarios:
- **Case 1:** Production function without internalised GHG emissions  
- **Case 2:** Production function with GHG emissions internalised through EPR  

Results indicate that the **EPR** is negatively correlated with output, where each unit increase in EPR reduces value added by approximately **3.8%**. Despite this short-term reduction, the internalisation of GHG emissions led to a **positive acceleration in Total Factor Productivity (TFP) growth**, averaging **0.8% per annum** — a **19% faster rate** compared to Case 1. The main contributor to this improvement was **technical change (TC)**, which increased by **28%**, though partially offset by declines in **scale efficiency change (SC)** (−15%) and **technical efficiency change (EC)** (−7%).

The analysis also segregates the 21 OECD countries into four clusters of peers based on average annual values of **hours worked, capital stock, value added,** and **GHG emissions**. The clusters are classified as **“Very Large Economies,” “Large Economies,” “Medium Economies,”** and **“Small Economies.”** Each cluster identifies the most efficient unit within its group and benchmarks other peers against it, providing insights on how economies can emulate efficient counterparts and improve performance without the confounding effect of scale size.

Overall, the **EPR framework** demonstrates a more accurate and dynamic means of assessing environmental integration in production analysis than traditional carbon-price aggregation. It provides a methodological foundation for future studies on **green productivity**, enabling policymakers and economists to quantify how sustainability-driven constraints can stimulate technological advancement and efficiency growth within industrial systems. 

---

## Research Objectives

The primary objective of this study was to examine how **internalising undesirable outputs**, such as **greenhouse gas (GHG) emissions**, affects **productivity growth** and **efficiency** within the **manufacturing and construction sectors** of **21 OECD member countries** over the period **2010–2017**.

To achieve this, the research pursued the following specific objectives:

1. **Data Construction:**  
   Built a comprehensive panel dataset from secondary sources, integrating economic and environmental indicators — including gross capital stock, labour hours worked, gross value added, and sector-specific GHG emissions — for the 21 OECD countries over an 8-year period.

2. **Econometric Analysis:**  
   Applied panel data econometric methods to estimate production functions **before and after internalising GHG emissions**, using a novel internalisation model formulated and compare outcomes against a carbon-pricing approach.

3. **Productivity Measurement:**  
   Measure and decompose **Total Factor Productivity (TFP) growth** into its components — technical change (TC), efficiency change (EC), and scale change (SC) — to assess how environmental internalisation influences sectoral performance.

4. **Efficiency Benchmarking:**  
   Classified the 21 OECD countries into **four peer clusters** (“Very Large,” “Large,” “Medium,” and “Small” Economies) based on capital, labour, emissions, and output. Identified the most efficient peer within each group and benchmarked other countries in the group to highlight pathways for improving productivity and environmental performance independent of scale size.

5. **Contextual Literature Review:**
   Conducted a critical review of current research, policy frameworks, and technological innovations supporting the **net-zero transition** and **environmental efficiency** in industrial systems.

These objectives collectively aim to establish a quantitative framework for analysing **green productivity** — demonstrating how integrating environmental constraints into traditional production analysis can yield more accurate and policy-relevant insights into sustainable economic growth.

---

## Data Sources
- **OECD STAN Database** — Structural Analysis dataset for capital stock, labour, and value added  
- **OECD.Stat** — Environmental indicators and GHG emissions by industry  
- **Time Period:** 2010–2017  
- **Countries:** 21 OECD member states  

---

## Tools and Dependencies

- **Software:**  
  Stata 17 SE

- **Econometric and Statistical Methods:**  
  - **Functional Form Selection:**  
    Compared **Cobb–Douglas** and **Translog** production functions using regression diagnostics (heteroskedasticity, multicollinearity, and misspecification tests). The Cobb–Douglas form was selected as the most parsimonious and interpretable.
  - **Deterministic Frontier Models:**  
    - **Pooled Corrected Ordinary Least Squares (COLS)**  
    - **Modified Ordinary Least Squares (MOLS)** (half-normal and exponential inefficiency assumptions)  
    Used to estimate baseline efficiency and productivity without accounting for stochastic noise.
  - **Stochastic Frontier Analysis (SFA):**  
    Conducted both **time-invariant** (`xtfrontier`) and **time-varying** (`sfpanel, model(bc95)`) panel SFA models to decompose the error term into inefficiency (u) and random error (v).  
    The **Battese and Coelli (1995)** specification was used for the time-varying model, providing insights into changes in efficiency over time.
  - **Panel Data Models:**  
    - **Fixed Effects (FE)** and **Random Effects (RE)** models (`xtreg, fe` / `xtreg, re`) were applied to capture unobserved heterogeneity across countries and over time.  
    - The RE model was preferred for efficiency ranking because it provided **time-varying inefficiency per country-year**, aligning better with the study’s objectives.
  - **Total Factor Productivity (TFP) Decomposition:**  
    Derived using the **sfbook** Stata package to separate **Technical Change (TC)**, **Scale Change (SC)**, and **Efficiency Change (EC)** components.

- **Statistical Tests and Diagnostics:**  
  - **Breusch–Pagan test (`estat hettest`)** – for heteroskedasticity  
  - **White’s test (`estat imtest, white`)** – for general heteroskedasticity  
  - **Variance Inflation Factor (VIF)** – for multicollinearity  
  - **Ramsey RESET test (`estat ovtest`)** – for model misspecification  
  - **Kernel Density and Skewness/Kurtosis tests (`kdensity`, `sktest`)** – for normality and skewness in residuals  
  - **Likelihood Ratio (LR) test** – to compare restricted and unrestricted SFA models following **Kodde and Palm (1986)**  
  - **Hausman test** – to determine whether FE or RE models were more appropriate for the panel data  
  - **Usigma ratio test** – to assess the share of inefficiency in total variance (`σᵤ² / (σᵤ² + σᵥ²)`)

- **Data Structure:**  
  - Balanced **panel data (Country × Year)**  
  - **21 OECD countries**, **8-year period (2010–2017)**  
  - Key variables: Gross Value Added, Labour Hours, Capital Stock, and GHG Emissions  

---

## Key Results
Available upon request

---

## Repository Structure
📂 OECD_NZ_Analysis/
- OECD_NZ_Analysis_Complete.do # Stata script for full econometric analysis
- MSc Business Project Dissertation- Giwa Iziomo.pdf # Project dissertation (available on request0
- data/ # (optional) placeholder for OECD datasets (available on request)
- results/ # model output tables, logs, and figures (available on request)
- README.md # project documentation (this file)

---

## Tools and Dependencies
- **Software:** Stata 17 SE  
- **Econometric Methods:** Pooled COLS, Random Effects  
- **Statistical Tests:** Hausman test, normality and multicollinearity diagnostics  
- **Data Format:** Panel data (country × year)  

---

## Manuscript in Preparation
This research is being extended into a **peer-reviewed manuscript** exploring the role of environmental internalisation in productivity measurement across industrial economies.  
The forthcoming paper will expand the econometric model and test alternative internalisation parameters and carbon price scenarios.

---

## Author
**Giwa Iziomo**  
MSc Business Analytics, Aston University  
[LinkedIn](https://www.linkedin.com/in/giwaiziomo) | [GitHub](https://github.com/IG-Reagan)

---

## Citation
If referencing this work, please cite as:  
> Iziomo, G. (2024). *Internalising Greenhouse Gas Emissions in Productivity Growth Analysis: Evidence from OECD Manufacturing and Construction Sectors (2010–2017).* MSc Dissertation, Aston University.

---

## License
This project is shared for academic and research purposes. All rights reserved. Please contact the author for permission before reproducing or extending the analysis.

