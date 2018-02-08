{****** - MM.RA.TF.FIB - ********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    FTMIB FUTURES
 TimeFrame: 52 min
 BackBars:  50
 Date:      21 Set 2011
*************************************}
input: alphal(0.01),flenl(1),rngpctl(0.1);
input: alphas(0.01),flens(1),rngpcts(0.1);

var: stopl(100000),funkl(100000),brkl(100000),tl(100000);
var: stops(100000),funks(100000),brks(100000),ts(100000);

var: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2);
var: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2);

var: engl(true,data2),engs(true,data2),entrylong(0,data2),entryshort(0,data2);

var: trades(0),fnkl(false),fnks(true),nos(1),dru(0),mcp(0);
{*************************************}
{*************************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
 fnks   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;
{*************************************}
{*************************************}
if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphal,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice,alphal)data2;
 fishl  = MM.FisherTransform(cyclel,flenl,true)data2;
 
 MM.ITrend(medianprice,alphas,trends,triggers)data2;
 cycles = MM.Cycle(medianprice,alphas)data2;
 fishs  = MM.FisherTransform(cycles,flens,true)data2;
 
 engl = fishl > fishl[1] and triggerl > trendl;
 engs = fishs < fishs[1] and triggers < trends;
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end;
{*************************************}
{*************************************}
//dru = MM.DailyRunup;
//mcp = MM.MaxContractProfit;

//fnkl = dru <= -funkl*nos;
//fnks = dru <= -funks*nos;
{*************************************}
{*************************************}
if trades < 2 then begin

 if not fnkl and marketposition < 1 and engl then
  buy next bar entrylong limit;
  
 if not fnks and marketposition > -1 and engs then
  sell short next bar entryshort limit;
  
end;
