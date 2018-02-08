vars: id(0);

if currentbar > 1 then begin
 if d < 1111201 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 var: lenl(34),kl(1.27),lens(49),ks(2.66);
 var: stopl(100),funkl(265),{brkl(100000),}tl(596);
 var: stops(151),funks(245),{brks(100000),}ts(156);
 
 var: upb(0),lob(0),el(true),es(true),engine(true);
 var: trade(0),fnkl(false),fnks(false),dru(0),mcp(0),_date(d);
 var: stpv(0),stp(true),mkt(true),nos(1),bpv(1/bigpointvalue);
 
 if d <> d[1] then begin
  trade = 0;
  fnkl  = false;
  fnks  = false;
 end;
 
 upb = BollingerBand(h,lenl,kl);
 lob = BollingerBand(l,lens,-ks);
 
 el = c  < upb;
 es = c  > lob;
 
 engine = 400 < t  and t  < 2200;
 
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos   = currentcontracts;
 end;
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
  
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*MinMove points;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru*bpv/nos + funkl*MinMove points);
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  {
  //BREAK EVEN
  stpv = entryprice + 16*MinMove points;
  stp  = mcp >= (brkl*MinMove points) and c > stpv;
  mkt  = mcp >= (brkl*MinMove points) and c <= stpv;
  
  if stp then sell("xl.brl") next bar stpv stop
  else if mkt then sell("xl.brk.m") this bar c;
  }
  //PROFIT TARGET
  stpv = entryprice + tl*MinMove points;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
  end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*MinMove points;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru*bpv/nos + funks*MinMove points);
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  {
  //BREAK EVEN
  stpv = entryprice - 16*MinMove points;
  stp  = mcp >= (brks*MinMove points) and c < stpv;
  mkt  = mcp >= (brks*MinMove points) and c >= stpv;
  
  if stp then buy to cover("xs.brl") next bar stpv stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
  }
  //PROFIT TARGET
  stpv = entryprice - ts*MinMove points;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
 
 fnkl = dru <= -funkl*nos*bigpointvalue;
 fnks = dru <= -funks*nos*bigpointvalue;
 
 if trade < 1 and engine then begin
 
  if not fnkl and marketposition < 1 and el then
   buy("el") next bar upb stop;
  
  if not fnks and marketposition > -1 and es then
   sellshort("es") next bar lob stop;
   
 end;
 {--------------------------}
 {--------------------------}
 
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
