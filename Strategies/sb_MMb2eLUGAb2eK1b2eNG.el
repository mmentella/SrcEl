vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM. - ********
  Engine:    Bollinger
  Author:    Matteo Mentella
  Portfolio: Lugano
  Market:    Natural Gas
  TimeFrame: 60 min.
  BackBars:  50
  Date:      30 Mar 2011
 *************************************}
 vars: lenl(39),kl(0.2),lens(3),ks(3.6);
 vars: stopl(1100),funkl(3200),brkl(1500),tl(3700);
 vars: stops(1700),funks(3400),brks(1200),ts(5300);
 
 vars: upb(0),lob(0),el(true),es(true),engine(true);
 vars: stpv(0),stp(false),mkt(false),trade(0),funk(false),dru(0),mcp(0),bpv(1/bigpointvalue),nos(1);
 
 if d <> d[1] then begin
  trade = 0;
  funk = false;
 end;
 
 upb = BollingerBand(h,lenl,kl);
 lob = BollingerBand(l,lens,-ks);
 
 el = c  < upb;
 es = c  > lob;
 
 engine = 700 < t  and t  < 2300;
 
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos = currentcontracts;
 end;
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
 {***************************}
 {***************************}
 if 700 < t and t < 2300 then begin
  
  if marketposition = 1 then begin
   
   //STOPLOSS
   stpv = entryprice - stopl*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then sell("xl.stp") next bar stpv stop
   else if mkt then sell("xl.stp.m") this bar c;
   
   //DAILY STOP
   stpv = c - (dru + funkl*currentcontracts)*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then sell("xl.funk") next bar stpv stop
   else if mkt then sell("xl.funk.m") this bar c;
   
   //BREAKEVEN
   stpv = entryprice + (10 points)*MinMove;
   stp  = mcp*bigpointvalue > brkl and c > stpv;
   mkt  = mcp*bigpointvalue > brkl and c <= stpv;
   
   if stp then sell("xl.brk") next bar stpv stop
   else if mkt then sell("xl.brk.m") this bar c;
   
   //PROFIT TARGET
   stpv = entryprice + tl*bpv;
   stp  = c < stpv;
   mkt  = c > stpv;
   
   if stp then sell("xl.prft") next bar stpv limit
   else if mkt then sell("xl.prft.m") this bar c;
   
  end else if marketposition = -1 then begin
   
   //STOPLOSS
   stpv = entryprice + stops*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then buy to cover("xs.stp") next bar stpv stop
   else if mkt then buy to cover("xs.stp.m") this bar c;
   
   //DAILY STOP
   stpv = c + (dru + funks*currentcontracts)*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then buy to cover("xs.funk") next bar stpv stop
   else if mkt then buy to cover("xs.funk.m") this bar c;
   
   //BREAKEVEN
   stpv = entryprice - (10 points)*MinMove;
   stp  = mcp*bigpointvalue > brks and c < stpv;
   mkt  = mcp*bigpointvalue > brks and c >= stpv;
   
   if stp then buy to cover("xs.brk") next bar stpv stop
   else if mkt then buy to cover("xs.brk.s") this bar c;
   
   //PROFIT TARGET
   stpv = entryprice - ts*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then buy to cover("xs.prft") next bar stpv limit
   else if mkt then buy to cover("xs.prft.m") this bar c;
   
  end;
   
 end;
 {***************************}
 {***************************}
 funk = dru <= -minlist(funkl,funks)*nos;
 {***************************}
 {***************************} 
 if not funk and trade < 1 and engine then begin
 
  if marketposition < 1 and el then
   buy("el") next bar upb stop;
   
  if marketposition > -1 and es then
   sellshort("es") next bar lob stop;
   
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

