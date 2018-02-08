{****** - MM.RA.SKEW.EURO - ********
 Engine:    SKEW
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    EURO DOLLAR FUTURES
 TimeFrame: 2 min + 24 h
 Session 1: 08:00 23:00
 Session 2: 00:00 23:00
 BackBars:  22
 Date:      27 Lug 2011
**************************************}
vars: alphal(0.36),alpml(0.09),alpdl(0.88);
vars: alphas(0.07),alpms(0.05),alpds(0.38);
Inputs: stopl(100000),funkl(100000),brkl(100000),tl(100000);
Inputs: stops(100000),funks(100000),brks(100000),ts(100000);

vars: skewl(0,data2),trndl(0,data2),trgrl(0,data2);
vars: skews(0,data2),trnds(0,data2),trgrs(0,data2);

vars: trade(0),fnkl(false),fnks(false),dru(0),mcp(0),nos(1),bpv(1/bigpointvalue);
vars: stpv(0),stpw(0),stoploss(10),daystop(11),breakeven(12),target(20);
{***************************}
{***************************}
if d > d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;
{***************************}
{***************************}
if barstatus(2) = 2 then begin

 MM.ITrend(medianprice,alphal,trndl,trgrl)data2;
 MM.ITrend(medianprice,alphas,trnds,trgrs)data2;
 
 skewl = MM.Skewness(medianprice,alpml,alpdl)data2;
 skews = MM.Skewness(medianprice,alpms,alpds)data2;

end;
{***************************}
{***************************}
if trade < 1 then begin

 if marketposition = -1 and trgrl > trndl and skewl < 0 then  
  buy to cover next bar o;
   
 if marketposition > -1 and trgrs < trnds and skews > 0 then
  sell short next bar o;

end;
{***************************}
{***************************}
