# Productivity Growth and the Road to Net Zero

## Internalising Greenhouse Gas Emissions in Productivity Growth Analysis — OECD Manufacturing & Construction Sectors (2010–2017)
Evaluating the Impact of Internalising Undesirable Outputs (GHG) in the Productivity Growth and Efficiency of the Manufacturing & Construction Sectors, using Econometric approach on Panel Data from 21 OECD Countries.

## Abstract
In this study the manufacturing and construction sector in 21 OECD countries are considered between the years 2010 – 2017. The project aims to evaluate the impact of internalizing greenhouse gas (GHG) emissions on the productivity growth of the sector,
using econometric approaches to analyse a suitable panel data. Also, the project intends to formulate a methodology for internalizing GHG emissions in a production function for effectively analysing efficiency and productivity growth of the sector. The data is collated from the OECD STAN and OECD.Stat databases, using gross capital stock, labour total hours worked, and gross value added as standard measures. GHG emissions specifically for the sector are also obtained for the time period being considered. The project then applies econometric approaches to select a functional form that is Cobb-Douglas and applies this function in selecting two estimators.

The Pooled COLS and Random Effects estimators are then applied to internalize GHG emissions into the production function, using a formulated factor known as Environmental Profitability Requirement (EPR). An output aggregation method is also tested using a Carbon Price of US $60 per tCO2e as a mechanism for aggregating with the gross value added, based on the midpoint of 2020 average carbon prices US $40-80, by the IPCC. Aligned with reservations in literature, the carbon price aggregation is seen to have almost no effect in the model. While the EPR method successfully depicted the effect of environmental constraints versus output sustainability in the production system. The final model is then used to estimate Total Factor Productivity (TFP) growth, comparing a real case where GHG emissions were not internalized in the years 2010 – 2017 (Case 1) with another case where GHG emissions are internalized during those years using the EPR factor (Case 2). The result shows that EPR is negatively correlated with the output (value added), and each unit of EPR increase will cause a reduction of a unit output by -3.8%. However, despite the negative effect of EPR on output, TFP growth is seen to be impacted positively with an additional growth rate of 0.8% per annum due to internalizing GHG emissions, which is essentially a 19% faster TFP growth compared to Case 1. The main source of this TFP growth is seen to be technical change (TC) growing 28% faster than the TC in Case 1.  However, this technical change growth is slightly upset by a lower scale efficiency change (SC) of -15% and technical efficiency change (EC) of -7% compared to Case 1. These results are comprehensively discussed in the project report.

---

## Objective
To formulate and empirically test a methodology for **internalising greenhouse gas emissions** in productivity and efficiency analysis, using an econometric production function framework for OECD manufacturing and construction sectors.

---

## Data Sources
- **OECD STAN Database** — Structural Analysis dataset for capital stock, labour, and value added  
- **OECD.Stat** — Environmental indicators and GHG emissions by industry  
- **Time Period:** 2010–2017  
- **Countries:** 21 OECD member states  

---

## Methodology
- **Language:** Stata  
- **Functional Form:** Cobb–Douglas production function  
- **Estimators Used:**  
  - Pooled Corrected Ordinary Least Squares (COLS)  
  - Random Effects (RE)  
- **Key Analytical Steps:**  
  1. Data cleaning and normalisation of sectoral data across 21 OECD countries  
  2. Testing of functional forms (log-linear vs translog) for suitability  
  3. Development of the Environmental Profitability Requirement (EPR) factor  
  4. Estimation of production functions with and without internalised emissions  
  5. Decomposition of TFP growth into Technical Change (TC), Efficiency Change (EC), and Scale Change (SC)  

---

## Key Results
| Indicator | Case 2 (Internalised via EPR) | % Change |
|------------|-------------------------------|----------|
| Output (Value Added) | ↓ 3.8% per unit EPR | -3.8% |
| Total Factor Productivity (TFP) Growth | +0.8% per annum | +19% |
| Technical Change (TC) | +28% | +28% |
| Scale Efficiency Change (SC) | -15% | -15% |
| Technical Efficiency Change (EC) | -7% | -7% |

These results confirm that internalising emissions through the EPR framework enhances long-term productivity growth by incentivising technical progress, despite short-term reductions in output efficiency.

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

