vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM.LUGA.K1.SILVER - ********
 Engine:    Bollinger
 Author:    Matteo Mentella
 Portfolio: LUGANO
 Market:    SILVER
 TimeFrame: 60 min.
 BackBars:  100
 Date:      06 Ott 2010
*************************************}
vars: lenl(17),kl(3.67),lens(90),ks(1.95),mnymngmnt(1);
vars: stopl(2700),stopdl(2400),tl(4950);
vars: stops(1350),stopds(2750),ts(4700);

vars: upb(0),lob(0),el(true),es(true),engine(true);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),trade(0),nos(1);

if d <> d[1] then begin
 trade = 0;
 yc = c[1];
end;

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);
 
el = c  < upb;
es = c  > lob;
 
engine = 800 < t  and t  < 2300;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos = currentcontracts;
end;

if mnymngmnt = 1 and 800 < t and t < 2250 then begin
  
 setstopshare;
 
 mcp = MM.MaxContractProfit;
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc - stopdl/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc + stopds/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
 end;
  
end;

if trade < 1 and engine then begin
 if marketposition < 1 and el and c < upb then
  buy("el") next bar at upb stop;
 if marketposition > -1 and es and c > lob then
  sellshort("es") next bar at lob stop;
end;
 
 {--------------------------}
 {--------------------------}
 
 
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
