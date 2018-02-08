Inputs: Strategy(""),Portfolio("38B"),Conversion(.81);

if currentbar = 1 then
 if getexchangename="EEI" or getexchangename="EUX" or getexchangename="IDEM" then value1 = 1
 else value1 = conversion;

MM.Portfolio(strategy,portfolio,value1);
