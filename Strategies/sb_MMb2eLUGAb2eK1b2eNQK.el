vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {******** - MM.LUG.K1.NQK - **********
  Engine:    Keltner
  Author:    Matteo Mentella
  Portfolio: LUGA
  Market:    eMini Nasdaq
  TimeFrame: 60 min.
  BackBars:  50
  Date:      11 Mar 2011
 *************************************}
 
 vars: lenl(1),kl(2.92),lens(4),ks(4.52);
 vars: stopl(2500),funkl(1800),tl(2000);
 vars: stops(1300),funks(2000),ts(4400);
 
 vars: upk(0),lok(0),el(true),es(true),engine(true);
 vars: trade(0),funk(false),dru(0),stpv(0),stp(true),mkt(false),bpv(1/bigpointvalue),nos(1);
 
 if d > d[1] then begin
  trade = 0;
  funk  = false;
 end;
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 el = c < upk;
 es = c > lok;
 
 engine = 700 < t and t < 2300;
 
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos = currentcontracts;
 end;
 
 dru = MM.DailyRunup;
 
 if marketposition <> 0 and 700 < t and t < 2300 then begin
  
  if marketposition = 1 then begin
  
   //STOPLOSS
   stpv = entryprice - stopl*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then sell("xl.stp") next bar stpv stop
   else if mkt then sell("xl.stp.m") this bar c;
   
   //DAILY STOPLOSS
   stpv = c - (dru + funkl*nos)*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then sell("xl.funk") next bar stpv stop
   else if mkt then sell("xl.funk.m") this bar c;
   
   //PROFIT TARGET
   stpv = entryprice + tl*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then sell("xl.pt") next bar stpv limit
   else if mkt then sell("xl.pt.m") this bar c;
     
  end else begin
   
   //STOPLOSS
   stpv = entryprice + stops*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then buy to cover("xs.stp") next bar stpv stop
   else if mkt then buy to cover("xs.stp.m") this bar c;
   
   //DAILY STOPLOSS
   stpv = c + (dru + funks*nos)*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then buy to cover("xs.funk") next bar stpv stop
   else if mkt then buy to cover("xs.funk.m") this bar c;
   
   //PROFIT TARGET
   stpv = entryprice - ts*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then buy to cover("xs.pt") next bar stpv limit
   else if mkt then buy to cover("xs.pt.m") this bar c;
   
  end;
  
 end;
 
 funk = dru <= -minlist(funkl,funks)*nos;
 
 if not funk and trade = 0 and engine then begin
  
  if marketposition < 1 and el then
   buy("el") next bar upk stop;
  
  if marketposition > -1 and es then
   sellshort("es") next bar lok stop;
 
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
