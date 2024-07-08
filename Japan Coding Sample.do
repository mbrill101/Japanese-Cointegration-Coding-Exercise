/*Here is a simple time series exercise. I will perform both an ARDL and VECM. The dependent variaible is Japanese GDP, and the independent variables are the Japanese unemployment rate and the Yen - USD exchange rate. The data is quarterly and ranges from 1995 to 2023*/
gen date = tq(1995q1) + _n-1
format %tq date
tsset date
dfuller JGDP, lags(4) 
dfuller UR, lags(4)
dfuller Yen, lags(4)
/*There are other options to include in the ADF tests, such as surpressing the constant or including a drift or trend term. For simplicity I only conduct basic ADF tests*/
dfgls JGDP, maxlag(8)
dfgls UR, maxlag(8)
dfgls Yen, maxlag(8)
/*I also perform DF - GLS tests which exhibit more power than standard ADF tests*/
gen dJGDP = d1.JGDP
gen dUR = d1.UR
gen dYen = d1.Yen
/*To account for non stationarity I take the first difference of each varible*/
ardl dJGDP dUR dYen, aic
/*Here I run the regression, selecting the optimal number of lags via the Akaike information criterion*/
ardl JGDP UR Yen, ec aic btest
/*I test for cointegration by putting the ARDL in error correction form and performing a bounds test to check for the possibility of cointegrating relationships*/
varsoc JGDP UR Yen, maxlag(8)
/*The varsoc command gives several information criterion results for lag selection. I use the AIC specification of 3 lags*/
vecrank JGDP UR Yen, lags(3) 
/*Here I perform a Johansen test to look for cointegrating relationships, the test indicates one cointegrating relationship*/
vec JGDP UR Yen
