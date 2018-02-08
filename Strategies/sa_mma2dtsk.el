input: tal(0.07),sal(0.07),kal(0.07);
input: tas(0.07),sas(0.07),kas(0.07);
input: dailyTrades(1);

{
input: handlePosition(false);
input: stopl(100000),funkl(100000),tl(100000);
input: stops(100000),funks(100000),ts(100000);
}

var: trndl(0),trgrl(0),skewl(0),kurtl(0);
var: trnds(0),trgrs(0),skews(0),kurts(0);

var: trade(0){,stpw(0),stpv(0),stp(true),mkt(false),nos(1),fnkl(false),fnks(false)};
{var: reason(0),stoploss(10),daystop(11),dru(0),bpv(1/bigpointvalue);}

if d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;

MM.ITrend(medianprice,tal,trndl,trgrl);
skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);
kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal);
 
MM.ITrend(medianprice,tas,trnds,trgrs);
skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);
kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas);
{
dru = MM.DailyRunup;

if handlePosition and 
   marketposition = 1 then begin
 
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
 
 stpw = entryprice + tl*bpv;
 stp  = c <  stpw;
 mkt  = c >= stpw;
 
 if stp then sell("xl.trgt") next bar stpw limit
 else if mkt then sell("xl.trgt.m") this bar c;
 
end else 
if handlePosition and 
   marketposition = -1 then begin
 
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
 
 stpw = entryprice - ts*bpv;
 stp  = c >  stpw;
 mkt  = c <= stpw;
 
 if stp then buy to cover("xs.trgt") next bar stpw limit
 else if mkt then buy to cover("xs.trgt.m") this bar c;
 
end;
}
if trade < dailyTrades then begin

 if marketposition < 1 and trgrl > trndl and skewl < 0 then
  buy("el") next bar o;
 
 if marketposition > -1 and trgrs < trnds and skews > 0 then 
  sell short("es") next bar o;
 
 if marketposition = 1 and trgrs < trnds and skews < 0 and kurts < 0 then
  sell short("xles") next bar o;
 
 if marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl > 0 then
  buy("xsel") next bar o; 

end;
