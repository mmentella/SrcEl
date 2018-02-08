{****** - MM.RA.SKEW.EURO - ********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    EURO DOLLAR FUTURES
 TimeFrame: 2 min + 24 h
 Session 1: 08:00 23:00
 Session 2: 00:00 23:00
 BackBars:  50
 Date:      27 Lug 2011
**************************************}
Inputs: alphal(0.03),alpml(0.67),alpdl(0.28);
Inputs: alphas(0.21),alpms(0.07),alpds(0.05);

vars: skewl(0,data2),trndl(0,data2),trgrl(0,data2);
vars: skews(0,data2),trnds(0,data2),trgrs(0,data2);
vars: trade(0);
{***************************}
{***************************}
if d > d[1] then begin
 trade  = 0;
end;

if barinterval < 15 then begin
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
 end; 
end;
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

 if marketposition < 1 and trgrl > trndl and skewl < 0 then  
  buy next bar o;
   
 if marketposition = 1 and trgrs < trnds and skews > 0 then
  sell next bar o;

end;
{***************************}
{***************************}
