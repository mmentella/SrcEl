vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM. - ********
  Engine:    Keltner
  Author:    Matteo Mentella
  Portfolio: 
  Market:    Light Sweet Crude Oil
  TimeFrame: 60 min.
  BackBars:  50
  Date:      09 Apr 2010
 *************************************}
 vars: LenL(19),KL(2.07),LenS(6),KS(4.85),ADXLen(24),ADXLimit(24);
 vars: StopL(490),StopS(1700),BRKL(700),BRKS(700),TL(3100),TS(1900),TRSL(2100),TRSS(2900);
 
 vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el(true,data2),es(true,data2),mpp(0),stopval(0),stp(false),mkt(false),NoS(2);
 
 if barstatus(2) = 2 then begin
  upperk = KeltnerChannel(h,lenl,kl)data2;
  lowerk = KeltnerChannel(l,lens,-ks)data2;
  
  el = c data2 < upperk;
  es = c data2 > lowerk;
  
  adxval = adx(adxlen)data2;
 end;
 
 if marketposition <> 0 and barssinceentry = 0 then nos = currentcontracts;
 mpp = MM.MaxContractProfit;
 
 if time > 800 and time < 2200 then begin
  
  if marketposition <> 0 then begin
   
   //STOPLOSS
   setstopshare;
   if marketposition = 1 then begin
    stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
    stp     = c > stopval;
    mkt     = c <= stopval;
    
    if stp then setstoploss(stopl);
    if mkt then sell("xl.stpls") next bar at market;
   end;
   if marketposition = -1 then begin
    stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
    stp     = c < stopval;
    mkt     = c >= stopval;
    
    if stp then setstoploss(stops);
    if mkt then buytocover("xs.stpls") next bar at market;
   end;  
   
   //BREAKEVEN
   stopval = entryprice + 100/bigpointvalue;
   stp     = mpp > brkl/bigpointvalue and stopval < c;
   mkt     = mpp > brkl/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
   
   //MODAL EXIT
   if currentcontracts = nos and nos > 1 then begin
    if marketposition = 1 then begin
     stopval = entryprice + tl/bigpointvalue;
     stp     = currentcontracts = nos and c < stopval;
     mkt     = currentcontracts = nos and c >= stopval;
     
     if stp then sell("xl.modl") IntPortion(nos/2) shares next bar at stopval limit;
     if mkt then sell("xl.modl.m") IntPortion(nos/2) shares next bar at market;
    end;
    if marketposition = -1 then begin
     stopval = entryprice - ts/bigpointvalue;
     stp     = currentcontracts = nos and c > stopval;
     mkt     = currentcontracts = nos and c <= stopval;
     
     if stp then buytocover("xs.modl") IntPortion(nos/2) + 1 shares next bar at stopval limit;
     if mkt then buytocover("xs.modl.m") IntPortion(nos/2) + 1 shares next bar at market;
    end;
   end;
   
   //TRAILING STOP  
   if mpp > brkl/bigpointvalue then begin
    stopval = entryprice + (mpp - trsl/bigpointvalue);
    stp     = currentcontracts < nos and stopval < c;
    mkt     = currentcontracts < nos and c <= stopval;
    
    if stp then sell("xl.trs") next bar at stopval stop;
    if mkt then sell("xl.trs.m") next bar at market;
   end;
     
  end;
 
  //ENGINE
  if adxval < adxlimit and TradesToday(d) < 1 then begin
   if marketposition < 1 and el and c < upperk then
    buy("long")  next bar at upperk stop;
   if marketposition > -1 and es and c > lowerk then
    sellshort("short")  next bar at lowerk stop;
  end;
 
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

