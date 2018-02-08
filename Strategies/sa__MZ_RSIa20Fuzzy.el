Inputs: overbought(70),oversold(30),rsilength(8),expLength(8);
Vars: myRsiVal(0),myXAverage(0);

myRsiVal = rsi(c,rsilength);
myXAverage = XAverage(c,expLength);

if(myRsiVal>overbought) and
(myRsiVal crosses below myXAverage)
 then buy next bar at market;

 //then PlotPaintBar(High,Low,"RSIOB",Blue);
 
 
if(myRsiVal<oversold) and
(myRsiVal crosses above myXAverage)
then sellshort next bar at market;


 //then PlotPaintBar(High,Low,"RSIOS",white);
