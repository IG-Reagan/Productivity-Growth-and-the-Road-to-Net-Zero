**************************************************************
*Production Function:
*21 OECD countries' Manufacturing & Construction Sector
*Impact of inernalizing GHG emissions on productivity growth
**************************************************************
**************************************************************

*Contents in this script
*************************
*Selection of Cobb-Douglas or Tranlog Functional form
*Pooled COLS and MOLS efficiency estimations (Model 1 & 2)  	/* Model selection process */
*Testing for possibility of Pooled SFA applicability
*Testing for Panel SFA applicability
*Time-invariant and Time-varying Panel SFA models (Model 1 & 2) /* Model selection process */
*Fixed and Random Effects models								/* Model selection process */
*Selecting a GHG internalization method (i.e. carbon price aggregation or use of an exogenous factor EPR)
*Calculating TFP growth (impact of internalizing GHG)			/* install sfbook package from link below*/


*https://sites.google.com/site/sfbook2014/home/for-stata-v12-v13-v14/sfbook_ado_v4%2827Oct2019%29.zip?attredirects=0
*Direct Stata to the directory where sfbook is saved on your PC. Use: adopath ++ c:\myado\
*Import the dataset

*Function Desc & Variables
****************************
*Type of Function: Production Function
*Dependent Variable: Gross Value Added (in million USD, current prices)
*Independent Variables:
*		1. Labour: Hours Worked (in million hours)
*		2. Gross Capital Stock (in million USD)
*Data Type: Panel Data (Year 2010 - 2017)

***********************
* Variable generation*
***********************
*Generate Cobb-Douglas (CD) variables:
gen lnVA =ln(value_added)
gen lnVA_CP = ln(value_added_agg)
gen lnlab =ln(labour)
gen lncap =ln(capital)


*Rename year and exogenous factors:
rename year yr
rename VA_GHG_ratio EPR 			/* A ratio of Value Added to GHG emission normalized */
rename time_point t					/* Year number starting from 1 - 8 i.e., 2010 = 1, 2011 = 2...2017 = 8 */

*Generate translog (TL) variables:
gen lnlab2 =0.5*lnlab^2	
gen lncap2 =0.5*lncap^2	
gen yr2 = 0.5*yr^2

gen lnlab_lncap =lnlab*lncap
gen lnlab_yr = lnlab*yr
gen lncap_yr = lncap*yr

***********************
* Model Preparation*
***********************
*Setting Initial Parameters for Panel Data SFA:
xtset id yr 						/* Specifies that data is a panel data */
ssc install sfpanel 				/* Install sfpanel command */
ssc install sfcross					/* Install sfcross command */

*Initial Checks:
sum value_added labour capital_stock GHG EPR value_added_CP yr t	/* Summarize Data */
sum lnVA lnlab lncap yr												/* Summarize Cobb-Douglas variables Data */
corr lnVA lnlab lncap lnVA_CP EPR yr								/* Check Cobb-Douglas correlation */
corr lnVA lnlab lncap yr lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr lncap_yr /* Translogg correlation */

*Select an Appropriate Functional Form between cd & tl: 
*Cobb-Douglas (cd) functional form
******************************
reg lnVA lnlab lncap yr				/* Most parsimonuous model after cd regression */
global xvar_cd lnlab lncap yr		/* Set indepvar list for most parsimonuous function */

*Post-regression tests:
estat hettest						/* Breusch-Pagan test for heteroskedasticity */
estat imtest, white					/* White's test for heteroskedasticity */
vif									/* Multicollinearity test */
estat ovtest						/* Misspecification - Ramsey RESET powers of the fitted values of lnVA*/
estat ovtest, rhs					/* Misspecification - Ramsey RESET powers of the independent variables */
rvfplot								/* Graph of residuals to check outliers */
avplots								/* Check fitting of the independent variables */

*Translog (tl) functional form
******************************
reg lnVA lnlab lncap yr lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr lncap_yr
reg lnVA lnlab lncap lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr lncap_yr 	/* yr removed */
reg lnVA lnlab lncap lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr 			/* lncap_yr removed */
reg lnVA lnlab lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr 					/* lncap removed */
reg lnVA lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr 						/* lncap removed  - Most parsimonuous */
global xvar_tl lnlab2 lncap2 yr2 lnlab_lncap lnlab_yr					/* Set indepvar list for most parsimonuous function */


*Post-regression tests:
estat hettest						/* Breusch-Pagan test for heteroskedasticity */
estat imtest, white					/* White's test for heteroskedasticity */
vif									/* Multicollinearity test */
estat ovtest						/* Misspecification - Ramsey RESET powers of the fitted values of lnVA*/
estat ovtest, rhs					/* Misspecification - Ramsey RESET powers of the independent variables */
rvfplot								/* Graph of residuals to check outliers */
avplots								/* Check fitting of the independent variables */

/*
Both functional forms perform poorly on heteroskedasticity, but the Cobb-Douglas passed the BP test at least.
Also as expected the Cobb-Douglas form performed better in the vif multicollinearity test (5.51 < 10) compared to the translog with 3358. 
Finally, both functional forms failed the misspecification tests, rejecting the null hypothesis that assumes 'no missing variables'.
Cobb-Douglas functional form is selected since it performed slightly better, it is the simpler function, and no multicollinearity issues.
*/

/*
We shall also test the situation of elasticity of scale to understand if the entire manufacturing and construction sector is behaving in:
a CRS or VRS and whether is increasing or decreasing returns to scale.
*/

reg lnVA $xvar_cd, beta				/* beta regression of Cobb-Douglas Function to obtain elasticities */
test lnlab+lncap+yr=1				/* Aditional test for scale elasticity */


* Estimating the Deterministic Frontiers using Pooled COLS and MOLS
********************************************************************
*Model 1: COLS
******
reg lnVA $xvar_cd 					/* regress the Cobb-Douglas Function */
predict res, r						/* extract the residuals */

*Calculate the estimate of E(u)
egen maxres=max(res)				/* generate the maximum residuals */	
sum maxres
gen lnE_cols= maxres-res			/* calculate inefficiency */
gen TE_cols= exp(-lnE_cols)			/* calculate technical efficiency */
sum TE_cols
sum TE_cols, detail
twoway (hist TE_cols)				/* plot a histogram of the technical efficiency distribution */

egen Eff_Ranking1 = rank(TE_cols), field
sort Eff_Ranking1
*List the top 20 efficient records
list id country Eff_Ranking1 yr TE_cols in 1/20

*Model 2: MOLS
******
reg lnVA $xvar_cd 						/* regress the Cobb-Douglas Function */
gen rmse=e(rmse)						/* extract MSE */
gen eu_exp = rmse						/* calculate E(u) assuming exponentially distributed efficiency */
gen eu_hn = rmse*((2/_pi))^(1/2)		/* calculate E(u) assuming half-normally distributed efficiency */
gen lnE_mols_exp = eu_exp - res 		/* calculate inefficiency (exponential) */
gen lnE_mols_hn = eu_hn - res 			/* calculate inefficiency (half-normal) */
gen TE_mols_exp = exp(-lnE_mols_exp)	/* calculate technical efficiency (exponential */
gen TE_mols_hn = exp(-lnE_mols_hn)		/* calculate technical efficiency (half-normal */
sum  TE_mols_hn TE_mols_exp, detail

*Correct the efficiency scores of the units with score of over 100%
replace TE_mols_exp=1 if TE_mols_exp>1		/* corrected technical efficiency (exponential */
replace TE_mols_hn=1 if TE_mols_hn>1		/* corrected technical efficiency (half-normal */

sum TE_mols_hn TE_mols_exp TE_cols
sum TE_mols_hn TE_mols_exp TE_cols, detail
twoway (hist TE_mols_hn, fcolor(teal)) (hist TE_mols_exp)	/* histogram of both TE */

egen Eff_Ranking2 = rank(TE_mols_exp), field
sort Eff_Ranking2
*List the top 20 efficient records
list id country Eff_Ranking2 yr TE_mols_hn TE_mols_exp in 1/20

*Compare Deterministic
sum TE_mols_hn TE_mols_exp TE_cols
corr TE_mols_hn TE_mols_exp TE_cols


************************************
* Stochastic Frontier Analysis (SFA)
************************************
*Tests to check if Pooled SFA analysis will be able to decompose the error term.
reg lnVA $xvar_cd

*Test for the skewness of the OLS residuals
kdensity res, normal				/* kernel density estimate graph to check skewness */
sum res, detail						/* residual summary to see max/min residuals */
sktest res							/* Skewness/Kurtosis tests for Normality */
frontier lnVA $xvar_cd
frontier lnVA $xvar_cd, dist(e)


/*
The sktest rejects the null hypothesis of normality, meaning that there is skewness.
However the other 2 tests show that the skewness is to the right-hand which is the wrong direction for a Production Function.
This means that a Pooled SFA would not be useful in decomposing the error term. Based on this we will try Panel SFA.
*/

*Descriptive Statistics for Panel Data
xtsum lnVA lnlab lncap yr			/*Summarize Panel Data */


*Tests to check if an SFA panel data model will be able to decompose the error term:
************************************************************************************
*Perform some tests of the SFA panel data models have better performance than a deterministic model that used log likelihood

glm lnVA $xvar_cd			 			/* OLS mmodel: generalized linear model that fits using quasi or maximum likelihood) */
xtfrontier lnVA $xvar_cd, ti			/* SF time-invariant model. Option tvd (time-varying decay model) could not complete iteration */
sfpanel lnVA $xvar_cd, model(bc95)		/* ML random-effects time-varying inefficiency effects model (Battese andCoelli, 1995) */

/*
Following tests were performed to compare the SFA models vs. glm model:
Test 1: Likelihood Ratio test as recommended by Kumbhakar, Wang and Homcastle (2015).
-2[L(Ho) - L(H1)]:
where:	Ho is the log likelihood of the restricted model
		H1 is the log likelihood of the unrestricted model.
The result will be tested against critical values reported by (Kodde and Palm, 1986).
Results: Models A, B & C gave 466, 468, 466 respectively, far higher than critical value 5.412 at 1% confidence in Kodde and Palm (1986).
Conclusion: Stochastic Frontier Analysis is necessary.

Test 2: Calculate the ratio of ineficiency to the total error term derived from a stochastic frontier.
This will enable us to determine if the inefficiency component is relevant enough for an SFA (Aigner, et al. 1977).
sigma_u^2/(sigma_u^2 + sigma_v^2)
where:	sigma_u^2 is technical ineficiencies
		sigma_v is random errors
		sigma^2 = (sigma_u^2 + sigma_v^2) which is the total error term.

Conclusion:
Time invariant seem able to decompose the error because it returned 466 in the Kodde and Palm (1986) tests - vs 5.412 
Time varying model failed the Kodde and Palm (1986) tests with a score of 0.
usigma ratio test for Time-invariant model is 99% while Time-varying model is 23%.
*/

*SFA Panel Data Models for technical efficiency estimation
***********************************************************
*Model 3: Time Invariant Panel SFA Model
xtfrontier lnVA $xvar_cd, ti			/* SFA time-invariant model. Option tvd (time-varying decay model) could not complete iteration */
predict lnE_PS_TI, u
gen TE_PS_TI=exp(-lnE_PS_TI)
sum  TE_PS_TI, detail
sum  TE_PS_TI
twoway (hist TE_PS_TI)

egen Eff_Ranking3 = rank(TE_PS_TI), field
sort Eff_Ranking3
*List the top 20 efficient records
list id country yr Eff_Ranking3 TE_PS_TI in 1/20


*Model 4: Time-Varying Panel SFA model (Battese and Coelli, 1995)
sfpanel lnVA $xvar_cd, model(bc95)		/* ML random-effects time-varying inefficiency effects model (Battese andCoelli, 1995)) */
predict te_PS_TV, jlms
egen maxte_PS_TV=max(te_PS_TV)
generate TE_PS_TV=te_PS_TV/maxte_PS_TV	/* corrected technical efficiency */
sum TE_PS_TV
sum TE_PS_TV, detail
twoway (hist TE_PS_TV)

egen Eff_Ranking4 = rank(TE_PS_TV), field
sort Eff_Ranking4
*List the top 20 efficient records
list id country yr Eff_Ranking4 TE_PS_TV in 1/20

*Summarize all Panel SFA Models
sum TE_PS_TI TE_PS_TV
corr TE_PS_TI TE_PS_TV

*Model 5: Fixed effects model
xtreg lnVA $xvar_cd, fe
predict fe, u /* fixed effect */
quietly summarize fe
generate double u_star = r(max)-fe
generate TE_fe = exp(-u_star)
summ TE_fe
summ TE_fe, detail
twoway (hist TE_fe)

egen Eff_Ranking5 = rank(TE_fe), field
sort Eff_Ranking5
*List the top 20 efficient records
list id country yr Eff_Ranking5 TE_fe in 1/20  

*Model 6: Random Rffects model using Generalized Least Squares (GLS)
xtreg lnVA $xvar_cd, re
matrix bre =e(b)
predict ue, ue 									/* overall error */
sort id
generate ahat = (ue - _b[_cons])
quietly summarize ahat
generate double u_star_re = r(max)-ahat
generate double TE_re = exp(-u_star_re)
summarize TE_re									/* overall Technical Efficiency */
summarize TE_re, detail
twoway (hist TE_re)

egen Eff_Ranking6 = rank(TE_re), field
sort Eff_Ranking6
*List the top 20 efficient records
list id country yr Eff_Ranking6 TE_re in 1/20

*Effects Model Summary
sum TE_fe TE_re
corr TE_fe TE_re
 
*********************************
***Effects Post Estimation Tests
*********************************
*a. Hausman Test: to choose between FE or RE
xtreg lnVA $xvar_cd, fe
estimate store fe
xtreg lnVA $xvar_cd, re
estimate store re

hausman fe re
/*
If the hausman test statistic is insignificant (>0.05), use re model because it's efficient
If the hausman test statistic is significant (< 0.05), use fe because it's consistent
Conclusion: Choose RE (Hausman). 
*/

*b. Breusch and Pagan Lagrangian multiplier (LM) test: to choose between RE and a Pooled OLS model  
xtreg lnVA $xvar_cd, re
xttest0
/*
If significant (< 0.05) then choose with RE
Conclusion: Choose RE
*/

sum TE_cols TE_mols_hn TE_mols_exp TE_PS_TI TE_PS_TV TE_fe TE_re	/* comparing efficiency of all models so far */
corr TE_cols TE_mols_hn TE_mols_exp TE_PS_TI TE_PS_TV TE_fe TE_re

*Graphs comparing the different efficiency distributions.
*Pooled Cols and Mols
label variable TE_cols "Model 1: TE COLS"
hist TE_cols, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_cols, replace)

label variable TE_mols_hn "Model 2a: TE MOLS Half-normal"
hist TE_mols_hn, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_mols_hn, replace)

graph combine panel_TE_cols.gph panel_TE_mols_hn.gph, col(2) scale(1) xcommon ycommon


*Panel SFA models

label variable TE_mols_exp "Model 2b: TE MOLS Exponential"
hist TE_mols_exp, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_mols_exp, replace)

label variable TE_PS_TI "Model 3: TE Panel SFA Time-Invariant"
hist TE_PS_TI, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_PS_TI, replace)

graph combine panel_TE_PS_TI.gph panel_TE_mols_exp.gph, col(2) scale(1) xcommon ycommon


*Effects models
label variable TE_fe "Model 5: TE Fixed Effects"
hist TE_fe, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_fe, replace)

label variable TE_re "Model 6: TE Random Effects"
hist TE_re, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_re, replace)

graph combine panel_TE_fe.gph panel_TE_re.gph, col(2) scale(1) xcommon ycommon

*****************************************************************************************
label variable TE_cols "Model 1: TE COLS"
hist TE_cols, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_cols, replace)

label variable TE_mols_hn "Model 2a: TE MOLS Half-normal"
hist TE_mols_hn, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_mols_hn, replace)

label variable TE_mols_exp "Model 2b: TE MOLS Exponential"
hist TE_mols_exp, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_mols_exp, replace)

label variable TE_PS_TI "Model 3: TE Panel SFA Time-Invariant"
hist TE_PS_TI, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_PS_TI, replace)

label variable TE_fe "Model 5: TE Fixed Effects"
hist TE_fe, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_fe, replace)

label variable TE_re "Model 6: TE Random Effects"
hist TE_re, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_re, replace)

graph combine panel_TE_cols.gph panel_TE_mols_hn.gph panel_TE_PS_TI.gph panel_TE_mols_exp.gph panel_TE_fe.gph panel_TE_re.gph, col(2) scale(1) xcommon ycommon


*************************************************
*Internalizing Undesired Outputs - GHG Emissions
*************************************************

*Method 1: Output Aggregation based on carbon price
****************************************************

*Model 1: COLS_CP
******
reg lnVA_CP $xvar_cd 					/* regress the Cobb-Douglas Function */
predict res_CP, r						/* extract the residuals */

*Calculate the estimate of E(u)
egen maxres_CP=max(res_CP)				/* generate the maximum residuals */	
sum maxres_CP
gen lnE_cols_CP= maxres_CP-res_CP		/* calculate inefficiency */
gen TE_colCP= exp(-lnE_cols_CP)			/* calculate technical efficiency */
sum TE_cols TE_colCP
sum TE_colCP, detail
twoway (hist TE_colCP)					/* plot a histogram of the technical efficiency distribution */

gen PrevRank = Eff_Ranking1
egen NewRank = rank(TE_colCP), field
sort NewRank
*List the top 20 efficient records
list id country yr NewRank TE_colCP PrevRank TE_cols in 1/20


*Model 6: random effects model using Generalized Least Squares (GLS)_CP
*Dependent variable: Natural log of the aggregate value added (lnVA_CP)
xtreg lnVA_CP $xvar_cd, re
matrix bre =e(b)
predict ue_CP, ue										/* overall error */
sort id
generate ahat_CP = (ue_CP - _b[_cons]) 					/* ahat equation 10.7*/
quietly summarize ahat_CP
generate double u_star_re_CP = r(max)-ahat_CP 			/* equation 10.4*/
generate double TE_reCP = exp(-u_star_re_CP)
sum TE_re TE_reCP
sum TE_reCP, detail
twoway (hist TE_reCP)

gen Prevrank = Eff_Ranking6
egen New_Rnk = rank(TE_reCP), field
sort New_Rnk
*List the top 20 efficient records
list id country yr New_Rnk TE_reCP Prevrank TE_re in 1/20


*Method 2: Use of an exogenous factor of EPR (an exergenous factor to the model - see chapter 3, section 3.3.8)
***************************************************************************************************************

*Model 1: COLS_EPR
reg lnVA $xvar_cd EPR					/* regress the Cobb-Douglas Function */
predict res_EPR, r						/* extract the residuals */

*Calculate the estimate of E(u)
egen maxres_EPR=max(res_EPR)				/* generate the maximum residuals */	
sum maxres_EPR
gen lnE_cols_EPR= maxres_EPR-res_EPR		/* calculate inefficiency */
gen TE_colEPR= exp(-lnE_cols_EPR)			/* calculate technical efficiency */
sum TE_cols TE_colEPR
sum TE_colEPR, detail
twoway (hist TE_colEPR)					/* plot a histogram of the technical efficiency distribution */

egen newrank = rank(TE_colEPR), field
sort newrank
*List the top 20 efficient records
list id country yr newrank TE_colEPR PrevRank TE_cols in 1/20

reg lnVA $xvar_cd EPR, beta				/* beta regression of Cobb-Douglas Function to obtain elasticities */
test lnlab+lncap+yr+EPR=1				/* Aditional test for scale elasticity */

*Model 6: random effects model using Generalized Least Squares (GLS)_EPR
xtreg lnVA $xvar_cd EPR, re
matrix bre =e(b)
predict ue_EPR, ue 								/* overall error */
sort id
generate ahat_EPR = (ue_EPR - _b[_cons]) 			/* ahat equation */
quietly summarize ahat_EPR
generate double u_star_re_EPR = r(max)-ahat_EPR
generate double TE_reEPR = exp(-u_star_re_EPR)
summ TE_re TE_reEPR
summ TE_reEPR, detail
twoway (hist TE_reEPR)

egen new_rnk = rank(TE_reEPR), field
sort new_rnk
*List the top 20 efficient records
list id country yr new_rnk TE_reEPR Prevrank TE_re in 1/20 


*Comparing GHG Internalization Methods: "using carbon price or EPR factor"
**************************************************************************

*a. Summarize
sum TE_cols TE_cols_CP TE_cols_EPR
corr TE_cols TE_cols_CP TE_cols_EPR

*b. Compare histograms
label variable TE_cols "Without Bad Output"
hist TE_cols, bin(10) normal xlabel(.1(.1)1) saving(panel2_TE_cols, replace)

label variable TE_cols_CP "Bad Output using CP Aggregation"
hist TE_cols_CP, bin(10) normal xlabel(.1(.1)1) saving(panel2_TE_TE_cols_CP, replace)

label variable TE_cols_EPR "Bad output Env_Ef"
hist TE_cols_EPR, bin(10) normal xlabel(.1(.1)1) saving(panel2_TE_cols_EPR, replace)

graph combine panel2_TE_cols.gph panel2_TE_TE_cols_CP.gph panel2_TE_cols_EPR.gph, col(3) scale(1) xcommon ycommon


*****************************************
*Comparison graphs for GHG internalizing
*****************************************

label variable TE_cols "Pooled COLS TE without GHG"
hist TE_cols, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_cols2, replace)

label variable TE_re "RE Model TE without GHG"
hist TE_re, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_re2, replace)

label variable TE_colCP "Pooled COLS TE with GHG by CP"
hist TE_colCP, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_colCP, replace)

label variable TE_reCP "RE Model TE with GHG by CP"
hist TE_reCP, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_reCP, replace)

label variable TE_colEPR "Pooled COLS TE with GHG by EPR"
hist TE_colEPR, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_colEPR, replace)

label variable TE_reEPR "RE Model TE with GHG by EPR"
hist TE_reEPR, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_reEPR, replace)

graph combine panel_TE_cols2.gph panel_TE_re2.gph panel_TE_colCP.gph panel_TE_reCP.gph panel_TE_colEPR.gph panel_TE_reEPR.gph, col(2) scale(1) xcommon ycommon



label variable TE_cols "Pooled COLS TE without GHG"
hist TE_cols, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_cols2, replace)

label variable TE_colCP "Pooled COLS TE with GHG by CP"
hist TE_colCP, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_colCP, replace)

label variable TE_colEPR "Pooled COLS TE with GHG by EPR"
hist TE_colEPR, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_colEPR, replace)

label variable TE_re "RE Model TE without GHG"
hist TE_re, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_re2, replace)

label variable TE_reCP "RE Model TE with GHG by CP"
hist TE_reCP, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_reCP, replace)

label variable TE_reEPR "RE Model TE with GHG by EPR"
hist TE_reEPR, bin(10) normal xlabel(.1(.1)1) saving(panel_TE_reEPR, replace)

graph combine panel_TE_cols2.gph panel_TE_colCP.gph panel_TE_colEPR.gph panel_TE_re2.gph panel_TE_reCP.gph panel_TE_reEPR.gph, col(3) scale(1) xcommon ycommon


*********************************************************************************
*Calculation and comparison of TFP - with and without internalizing GHG emission
*********************************************************************************
/*
Note that the variable t shall be used to replace yr in the following regression.
t is defined at the beginning of this script, it is a representation of years with numbers from year 1 - 8.
Two TFP values will be calculated. First not internalizing GHG, then next with GHG internalized.
*/

*i. TFP without internalizing GHG
**********************************
sort id
global xvar_no_GHG lnlab lncap t	/* yr is replaced by t, to have values of year as 1,2,3...,8 */
reg lnVA $xvar_no_GHG
matrix b0=e(b)
sfmodel lnVA, prod dist(h) frontier($xvar_no_GHG) usigmas(t) vsigmas()
sf_init, frontier(b0) usigmas(0 0) vsigmas(0)
ml max, difficult gtol(1e-5)

sf_predict, bc(bc_cd) jlms(jlms_cd) marginal

sort id
by id: generate dot_VA = (value_added-value_added[_n-1])/(.5*(value_added+value_added[_n-1]))

sort id
by id: generate dot_lab = (labour-labour[_n-1])/(.5*(labour+labour[_n-1]))

sort id
by id: generate dot_cap = (capital_stock-capital_stock[_n-1])/(.5*(capital_stock+capital_stock[_n-1]))

generate RTS = 0.5029602+0.4930523+0.0482366-0.0383809

generate TC = _b[t] if id ~= 1									/* Technological Change = dlnVA/dt = y* (i.e. the new coef of t) */

generate SC = (RTS-1)*(_b[lnlab]*dot_lab + _b[lncap]*dot_cap)	/* Scale Change = (RTS-1)*summation of inputs */

generate EC = t_M if id ~=1										/* Technical Efficiency change */

generate TFP = TC + SC + EC

sum TC SC EC TFP


*ii. TFP with GHG internalized
*******************************
sort id
global xvar_NZ lnlab lncap EPR t
reg lnVA $xvar_NZ																	 	/* NZ = Net Zero */
matrix b0=e(b)
sfmodel lnVA, prod dist(h) frontier($xvar_NZ) usigmas(t) vsigmas()
sf_init, frontier(b0) usigmas(0 0) vsigmas(0)
ml max, difficult gtol(1e-5)
*ntol(1e-5)

sf_predict, bc(bc_cd_NZ) jlms(jlms_cd_NZ) marginal

sort id
by id: generate dot_EPR = (EPR-EPR[_n-1])/(.5*(EPR+EPR[_n-1]))

generate TC_NZ = _b[t] if id ~= 1														/* Technological Change = dlnVA/dt = y* (i.e. the new coef of t) */

generate SC_NZ = (RTS-1)*(_b[lnlab]*dot_lab + _b[lncap]*dot_cap + _b[EPR]*dot_EPR)		/* Scale Change = (RTS-1)*summation of inputs */

generate EC_NZ = t_M if id ~=1															/* Technical Efficiency change */

generate TFP_NZ = TC_NZ + SC_NZ + EC_NZ													/* Total Factor Productivity */

sum TC_NZ SC_NZ EC_NZ TFP_NZ


/*
*Just checks
reg lnVA $xvar_no_GHG, beta
reg lnVA $xvar_NZ, beta
*/






