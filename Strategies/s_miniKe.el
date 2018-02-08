vars: id(0);

if currentbar > 1 then begin
 if d < 1110901 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - miniKe - ********
  Engine:    Keltner
  Author:    Matteo Mentella
  Portfolio: miniEU
  Market:    MINI EUR/USD
  TimeFrame: 60 min.
  BackBars:  50
  Date:      24/08/2011
 *************************************}
 var: lenl(7),kl(2.1),lens(12),ks(4.39);
 var: stopl(650),funkl(1450),{brkl(100000),}tl(2600);
 var: stops(600),funks(1675),brks(650),ts(2600);
 
 vars: upk(0),lok(0),el(true),es(true),engine(true),trades(0);
 vars: dru(0),mcp(0),bpv(1/bigpointvalue),fnkl(true),fnks(true),nos(1);
 vars: stpv(0),stp(true),mkt(true);
 {***************************}
 {***************************}
 if barstatus(1) = 2 then begin
 {***************************}
 {***************************}
 if d <> d[1] then begin
  trades = 0;
  fnkl   = false;
  fnks   = false;
 end;

 if marketposition <> 0 and barssinceentry = 0 then begin
  trades = trades + 1;
  nos    = currentcontracts;
 end;
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
 {***************************}
 {***************************}
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 el = c  < upk;
 es = c  > lok;
 {***************************}
 {***************************}  
  if marketposition = 1 then begin
   
   //STOPLOSS
   stpv = entryprice - stopl*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then sell("xl.stp") next bar at stpv stop
   else if mkt then sell("xl.stp.m") this bar c;
   
   //DAILY STOPLOSS
   stpv = c - (dru + funkl*currentcontracts)*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then sell("xl.funk") next bar at stpv stop
   else if mkt then sell("xl.funk.m") this bar c;
   {
   //BREAKEVEN
   stpv = entryprice + 20*MinMove points;
   stp  = mcp > brkl*bpv and c > stpv;
   mkt  = mcp > brkl*bpv and c <= stpv;
   
   if stp then sell("xl.brk") next bar stpv stop
   else if mkt then sell("xl.brk.m") this bar c;
   }
   //PROFIT TARGET
   stpv = entryprice + tl*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then sell("xl.prft") next bar at stpv limit
   else if mkt then sell("xl.prft.m") this bar c;
   
  end else if marketposition = -1 then begin
   
   //STOPLOSS
   stpv = entryprice + stops*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then buy to cover("xs.stp") next bar stpv stop
   else if mkt then buy to cover("xs.stp.m") this bar c;
   
   //DAILY STOPLOSS
   stpv = c + (dru + funks*currentcontracts)*bpv;
   stp  = c < stpv;
   mkt  = c >= stpv;
   
   if stp then buy to cover("xs.funk") next bar stpv stop
   else if mkt then buy to cover("xs.funk.m") this bar c;   
   
   //BREAKEVEN
   stpv = entryprice - 20*MinMove points;
   stp  = mcp > brks*bpv and c < stpv;
   mkt  = mcp > brks*bpv and c >= stpv;
   
   if stp then buy to cover("xs.brk") next bar stpv stop
   else if mkt then buytocover("xs.brk.m") this bar c;
   
   //PROFIT TARGET
   stpv = entryprice - ts*bpv;
   stp  = c > stpv;
   mkt  = c <= stpv;
   
   if stp then buy to cover("xs.prft") next bar stpv limit
   else if mkt then buy to cover("xs.prft.m") this bar c;
   
  end;
 {***************************}
 {***************************}
 fnkl = dru <= - funkl * nos;
 fnks = dru <= - funks * nos;
 {***************************}
 {***************************}
 if trades < 2 then begin
  
  if not fnkl and marketposition < 1 and el then
   buy("el") next bar upk stop;
  
  if not fnks and marketposition > -1 and es then
   sell short("es") next bar lok stop;
    
 end;
 {***************************}
 {***************************}
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
{***************************}
{***************************}
