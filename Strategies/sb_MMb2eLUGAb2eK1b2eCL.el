vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM. - ********
  Engine:    KELTNER
  Author:    Matteo Mentella
  Portfolio: LUGA
  Market:    Crude Light Sweet
  TimeFrame: 60 min.
  BackBars:  50
  Date:      30 Mar 2011
 *************************************}
 
 {--------------------------}
 {--------------------------}
 vars: lenl(10),kl(4.2),lens(4),ks(5);
 Inputs: stopl(2500),funkl(2600),tl(3250);
 inputs: stops(2500),funks(1600),ts(3000);

 vars: upk(0),lok(0),el(true),es(true),engine(true),trade(0);
 vars: stpv(0),stp(false),mkt(false),fnkl(false),fnks(false),dru(0),mcp(0),bpv(1/bigpointvalue);
 {--------------------------}
 {--------------------------}
 if d <> d[1] then begin
  trade = 0;
  fnkl = false;
  fnks = false;
 end;
 {--------------------------}
 {--------------------------}
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 el = c < upk;
 es = c > lok;
 
 engine = 200 < t and t < 1900;
 {--------------------------}
 {--------------------------}
 if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;
 
 mcp = MM.MaxContractProfit;
 dru = MM.DailyRunup;
 {--------------------------}
 {--------------------------}
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
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
 {--------------------------}
 {--------------------------}
 fnkl = dru <= - funkl*maxlist(1,currentcontracts);
 fnks = dru <= - funks*maxlist(1,currentcontracts);
 {--------------------------}
 {--------------------------}
 if trade = 0 and engine then begin
  
  if not fnkl and marketposition < 1 and el then
   buy("el") next bar upk stop;
  
  if not fnks and marketposition > -1 and es then
   sell short("es") next bar lok stop;
  
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

