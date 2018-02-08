Input: averageLenght(200), bollingerLenght(20), bollingerDeviation(2);
Input: maxBarsPosition(14), stopLoss(10), target(2);

var: avg(0), bbandlow(0), bbandhigh(0);
var: mcp(0), atr(0), trackPosition(false);
var: stopLossPerc(0), targetPerc(0);

{Aggiornamento Variabili}
avg       = Average(c, averageLenght);
bbandhigh = BollingerBand(c, bollingerLenght, bollingerDeviation);
bbandlow  = BollingerBand(c, bollingerLenght, -bollingerDeviation);

mcp = MM.MaxContractProfit;
atr = averagetruerange(averageLenght);
trackPosition = not trackPosition 
                and mcp >= atr; 

stopLossPerc = 0.01 * minlist(stopLoss, 100);
targetPerc   = 0.01 * minlist(target, 100);  
{+++++++++++++++++++++++}

{Setup di Ingresso - LONG}
if marketposition < 1        and
   c crosses above bbandhigh and
   c > avg then begin

   buy("TrendLong") 1 share next bar at market;

end else
if marketposition < 1       and
   c crosses above bbandlow and
   c > avg then begin

   buy("ReverseLong") 1 share next bar at market;

end else

{Setup di Ingresso - SHORT}
if marketposition > -1       and
   c crosses below bbandhigh and
   c < avg then begin

   sell short("ReverseShort") 1 share next bar at market;

end else
if marketposition > -1      and
   c crosses below bbandlow and
   c < avg then begin

   sell short("TrendShort") 1 share next bar at market;

end;

{++++++++++++++++++++++++++++++}
{++++++++++++++++++++++++++++++}

{Gestione della Posizione - LONG}
if marketposition > 0 then begin
 
 {Stop Temporale}
 if mcp < 0 and barssinceentry > maxBarsPosition then
  sell("TimeStopLong") this bar on close
 else
 {Trailing Stop} 
 if trackPosition then
  sell("TrailingStopLong") next bar at (entryprice + (mcp - atr)) stop
 else
 {StopLoss}
  sell("StopLossLong") next bar at entryprice * (1 - stopLossPerc) stop;
 
 {Target}
 sell("TargetLong") next bar at entryprice * (1 + targetPerc) limit;

end else
{Gestione della Posizione - SHORT}
if marketposition < 0 then begin

 {Stop Temporale}
 if mcp < 0 and barssinceentry > maxBarsPosition then
  buy to cover("TimeStopShort") this bar on close
 else
 {Trailing Stop}
 if trackPosition then 
  buy to cover("TrailingStopShort") next bar at (entryprice - (mcp - atr)) stop
 else
  {StopLoss}
  buy to cover("StopLossShort") next bar at entryprice * (1 + stopLossPerc) stop;
 
 {Target}
 buy to cover("TargetShort") next bar at entryprice * (1 - targetPerc) limit;

end else begin

 trackPosition = false;

end;
