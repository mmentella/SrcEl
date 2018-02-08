vars: id(0);

if currentbar > 1 then begin
 if d < 11109010 then begin

input: tal(0.158),sal(0.158),kal(0.974);
input: tas(0.046),sas(0.006),kas(0.050);

input: stopl(975),funkl(0750),tl(2506.25);
input: stops(900),funks(1200),ts(1700.00);


var: trndl(0),trgrl(0),skewl(0),kurtl(0);
var: trnds(0),trgrs(0),skews(0),kurts(0);

var: trade(0),stpw(0),stpv(0),stp(true),mkt(false),nos(1),fnkl(false),fnks(false);
var: reason(0),stoploss(10),daystop(11),dru(0),bpv(1/bigpointvalue);

if t = sessionendtime(0,1) or d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;

//if barstatus(1) = 1 then begin

 MM.ITrend(medianprice,tal,trndl,trgrl);
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);
 kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal);
 
 MM.ITrend(medianprice,tas,trnds,trgrs);
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);
 kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas);
 
//end;

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
 
 stpw = entryprice + tl*bpv;
 stp  = c <  stpw;
 mkt  = c >= stpw;
 
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
 
 stpw = entryprice - ts*bpv;
 stp  = c >  stpw;
 mkt  = c <= stpw;
 
 if stp then buy to cover("xs.trgt") next bar stpw limit
 else if mkt then buy to cover("xs.trgt.m") this bar c;
 
end;

if trade = 0 then begin

 if marketposition < 1 and trgrl > trndl and skewl < 0 then
  buy("el") tomorrow o;
 
 if marketposition > -1 and trgrs < trnds and skews > 0 then 
  sell short("es") tomorrow o;
 
 if marketposition = 1 and trgrs < trnds and skews < 0 and kurts < 0 then
  sell short("xles") tomorrow o;
 
 if marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl > 0 then
  buy("xsel") tomorrow o; 

end;

end else begin
 text_setlocation(id,d,t,c);
 text_setstring(id,"Periodo di Trading scaduto. Aggiornare la Licenza o contattare 'm.mentella@gmail.com'. " + 
                   "Potrebbero essere rimaste delle posizioni aperte in Banca.");
end;

end else begin
 id = text_new(d,t,c,"");
 text_setcolor(id,white);
 text_setsize(id,10);
 text_setstyle(id,1,1);
end;
