Inputs: Strategy(""),Portfolio("38B"),Conversion(.81),Sett_y1(0),Sett_y2(0);

if currentbar = 1 then
 if getexchangename="EEI" or getexchangename="EUX" or getexchangename="IDEM" then value1 = 1
 else value1 = conversion;

WW.Portfolio(strategy,portfolio,value1,sett_y1,sett_y2);
