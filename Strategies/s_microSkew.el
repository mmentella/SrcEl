vars: id(0);

if currentbar > 1 then begin
 if d < 1111201 then begin
 
 
 {--------------------------}
 {--------------------------}
 
{****** - MM.RA.SKEW.MICRO - ********
 Engine:    SKEW
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    MICRO EURO DOLLAR FUTURES
 TimeFrame: 2 min + 24 h
 Session 1: 00:00 23:00
 Session 2: 00:00 23:00
 BackBars:  22
 Date:      27 Lug 2011
**************************************}
var: alphal(0.84),alpml(0.04),alpdl(0.78);
var: alphas(0.67),alpms(0.10),alpds(0.05);
var: stopl(192.5),funkl(290),tl(600);
var: stops(180.0),funks(210),ts(275);

vars: skewl(0,data2),trndl(0,data2),trgrl(0,data2);
vars: skews(0,data2),trnds(0,data2),trgrs(0,data2);

vars: trade(0),dru(0),mcp(0),mww(0,data2),fnkl(false),fnks(false),stp(true),mkt(false),nos(1),bpv(1/bigpointvalue);
vars: stpv(0),stpw(0),reason(0),stoploss(10),daystop(11),target(20);
{***************************}
{**UPDATE SYSTEM VARIABLES**}
if t = sessionendtime(0,1) then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;
{***************************}
{**UPDATE ENGINE VARIABLES**}
if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphal,trndl,trgrl)data2;
 MM.ITrend(medianprice,alphas,trnds,trgrs)data2;
 
 skewl = MM.Skewness(medianprice,alpml,alpdl)data2;
 skews = MM.Skewness(medianprice,alpms,alpds)data2;
 
 mww = MM.MovingWeeklyWave data2;

end;
{***************************}
{******MONEY MANAGEMENT*****}
if marketposition = 1 then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice - stopl*bpv;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if t < sessionendtime(0,1) and stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 stp = c >  stpw;
 mkt = c <= stpw;
 
 if reason = stoploss then begin
  if stp then sell("xl.stp") next bar stpw stop
  else if mkt then sell("xl.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then sell("xl.funk") next bar stpw stop
  else if mkt then sell("xl.funk.m") this bar c;
 end;
 
 //TARGET
 stpw = entryprice + tl*bpv;
 stp  = (nos = 1 or currentcontracts = .5*nos) and c <  stpw;
 mkt  = (nos = 1 or currentcontracts = .5*nos) and c >= stpw;
 
 if stp then sell("xl.trgt") next bar stpw limit
 else if mkt then sell("xl.trgt.m") this bar c;
 
end else if marketposition = -1 then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice + stops*bpv;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 
 if t < sessionendtime(0,1) and stpv < stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 stp = c <  stpw;
 mkt = c >= stpw;
 
 if reason = stoploss then begin
  if stp then buy to cover("xs.stp") next bar stpw stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then buy to cover("xs.funk") next bar stpw stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
 end;
 
 //TARGET
 stpw = entryprice - ts*bpv;
 stp  = (nos = 1 or currentcontracts = .5*nos) and c > stpw;
 mkt  = (nos = 1 or currentcontracts = .5*nos) and c <= stpw;
 
 if stp then buy to cover("xs.trgt") next bar stpw limit
 else if mkt then buy to cover("xs.trgt.m") this bar c;
 
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***********ENGINE**********}
if trade < 1 then begin 
 //LONG ENTRY
 if not fnkl and marketposition < 1 and trgrl > trndl and skewl < 0 then  
  buy next bar o;  
 //SHORT ENTRY
 if not fnks and marketposition > -1 and trgrs < trnds and skews > 0 then
  sell short next bar o;
end;
{***********END*************}
{***********END*************}

{--------------------------}
 {--------------------------}
 
 
end else begin
 text_setlocation(id,d,t,c);
  text_setstring(id,"*****************************************" + "\n" +
                   "* Strategy Expired.                     *" + "\n" +
                   "* Phone: +39 328 8080940           *" + "\n" +
                   "* Mail:  m.mentella@gmail.com *" + "\n" +
                   "*****************************************"
 		);end;

end else begin
 id = text_new(d,t,c,"");
 text_setstyle(id,1,0);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
end;
