vars: id(0);

if currentbar > 1 then begin
 if d < 1111101 then begin


var: tal(0.812),sal(0.076),kal(0.162);
var: tas(0.750),sas(0.167),kas(0.431);
var: stopl(210),funkl(200);
var: stops(270),funks(240);

var: trndl(0,data2),trgrl(0,data2),skewl(0,data2),kurtl(0,data2);
var: trnds(0,data2),trgrs(0,data2),skews(0,data2),kurts(0,data2);

var: trade(0),stpw(0),stpv(0),stp(true),mkt(false),nos(1),fnkl(false),fnks(false);
var: reason(0),stoploss(10),daystop(11),dru(0),bpv(1/bigpointvalue),mp(0);

if t = sessionendtime(0,1) or d > d[1] then begin
 trade = 0;
end;

mp = marketposition;

if mp <> mp[1] then begin
 trade = trade + 1;
 if mp <> 0 and barssinceentry = 0 then
  nos = currentcontracts;
end;

if barstatus(2) = 2 then begin
 
 trade = 0;

 MM.ITrend(medianprice,tal,trndl,trgrl)data2;
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal)data2;
 kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal)data2;
 
 MM.ITrend(medianprice,tas,trnds,trgrs)data2;
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas)data2;
 kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas)data2;

end;

dru = MM.DailyRunup;

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
 
end;

if trade = 0 then begin

 if marketposition < 1 and trgrl > trndl and skewl < 0 then
  buy("el") next bar o;
 
 if marketposition > -1 and trgrs < trnds and skews > 0 then 
  sell short("es") next bar o;
 
 if marketposition = 1 and trgrs < trnds and skews < 0 and kurts < 0 then
  sell short("xles") next bar o;
 
 if marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl < 0 then
  buy("xsel") next bar o;

end;

end else begin
 text_setlocation(id,d,t,c);
 text_setstring(id,"*****************************************" + "\n" +
                   "* Strategy Expired.                     *" + "\n" +
                   "* Phone: +39 328 8080940           *" + "\n" +
                   "* Mail:  m.mentella@gmail.com *" + "\n" +
                   "*****************************************"
 		);
end;

end else begin
 id = text_new(d,t,c,"");
 text_setstyle(id,1,0);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
end;
