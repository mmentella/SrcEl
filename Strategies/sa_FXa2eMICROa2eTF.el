vars: id(0);

if currentbar > 1 then begin
 if d < 1111201 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 var: alphal(0.66),lenl(8),rngl(.70);
 var: alphas(0.94),lens(8),rngs(.95);
 
 input: stopl(55),funkl(28),brkl(16),tl(24);
 input: stops(27),funks(33),brks(23),ts(68); 
 
 var: trndl(0,data2),trgl(0,data2),cycl(0,data2),fishl(0,data2),el(0,data2),bs(true,data2);
 var: trnds(0,data2),trgs(0,data2),cycs(0,data2),fishs(0,data2),es(0,data2),ss(true,data2);
 
 var: fnkl(false),fnks(false),bpv(1/bigpointvalue),mcp(0),dru(0),nos(1);
 var: stpw(0),stpv(0),stp(true),mkt(false);
 var: reason(0),position(0),stoploss(10),daystop(11),breakeven(12),target(20);
 
 var: trade(0),orderL(true),orderS(true);
 {**************************}
 {**************************}
 if d > d[1] then begin
  trade = 0;
  fnkl  = false;
  fnks  = false;
 end;
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
 {**************************}
 {**************************}
 if barstatus(2) = 2 then begin
 
  MM.ITrend(.5*(h+l),alphal,trndl,trgl)data2;
  cycl = MM.Cycle(.5*(h+l),alphal)data2;
  fishl = MM.FisherTransform(cycl,lenl,true)data2;
  
  bs = trgl > trndl and fishl > fishl[1];
  el = c data2 - rngl*(h data2 - l data2);
  
  MM.ITrend(.5*(h+l),alphas,trnds,trgs)data2;
  cycs = MM.Cycle(.5*(h+l),alphas)data2;
  fishs = MM.FisherTransform(cycs,lens,true)data2;
  
  ss = trgs < trnds and fishs < fishs[1];
  es = c data2 + rngs*(h data2 - l data2);
 
 end;
 {**************************}
 {**************************}
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos   = currentcontracts;
 end;
 {**************************}
 {**************************} 
 fnkl = dru <= -funkl*nos;
 fnks = dru <= -funks*nos;
 {**************************}
 {**************************}
 orderL = false;
 orderS = false;
 
 if trade = 0 then begin
  
  orderL = not fnkl and marketposition < 1 and bs;
  if orderL then
   buy("el") next bar el limit;
  
  orderS = not fnks and marketposition > -1 and ss;
  if orderS then
   sell short("es") next bar es limit;
   
 end;
 {**************************}
 {**************************}
 if marketposition = 1 then begin
  
  //STOPLOSS
  reason = stoploss;
  stpw   = entryprice - stopl*bpv;
  
  //DAYSTOP
  stpv = c - (dru/nos + funkl)*bpv;
  
  if t < sessionendtime(0,1) and stpv > stpw then begin 
   reason = daystop;
   stpw   = stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 20*MinMove points;
  
  if mcp > brkl*bpv and stpv > stpw then begin
   reason = breakeven;
   stpw   = stpv;
  end;
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason > position then begin
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else if reason = daystop then begin
    if stp then sell("xl.fnk") next bar stpw stop
    else if mkt then sell("xl.fnk.m") this bar c;
   end else if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
   end;
  end;
  
  reason = position;
  stpw   = es;
  
  //TARGET
  stpv = entryprice + tl*bpv;
  
  if orderS then begin
   if stpv < stpw then begin 
    reason = target;
    stpw   = stpv;
   end;
  end else begin
   reason = target;
   stpw   = stpv;
  end;
  
  if reason = target then begin
   stp = c <  stpw;
   mkt = c >= stpw;
   
   if stp then sell("xl.tp") next bar stpw limit
   else if mkt then sell("xl.tp.m") this bar c;
  end;  
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  reason = stoploss;
  stpw   = entryprice + stops*bpv;
  
  //DAYSTOP
  stpv = c + (dru/nos + funks)*bpv;
  
  if t < sessionendtime(0,1) and stpv < stpw then begin 
   reason = daystop;
   stpw   = stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice - 20*MinMove points;
  
  if mcp > brks*bpv and stpv < stpw then begin
   reason = breakeven;
   stpw   = stpv;
  end;
  
  stp = c <  stpw;
  mkt = c >= stpw;
  
  if reason > position then begin
   if reason = stoploss then begin
    if stp then buy to cover("xs.stp") next bar stpw stop
    else if mkt then buy to cover("xs.stp.m") this bar c;
   end else if reason = daystop then begin
    if stp then buy to cover("xs.fnk") next bar stpw stop
    else if mkt then buy to cover("xs.fnk.m") this bar c;
   end else if reason = breakeven then begin
    if stp then buy to cover("xs.brk") next bar stpw stop
    else if mkt then buy to cover("xs.brk.m") this bar c;
   end;
  end;
  
  reason = position;
  stpw   = es;
  
  //TARGET
  stpv = entryprice - ts*bpv;
  
  if orderL then begin
   if stpv > stpw then begin 
    reason = target;
    stpw   = stpv;
   end;
  end else begin
   reason = target;
   stpw   = stpv;
  end;
  
  if reason = target then begin
   stp = c >  stpw;
   mkt = c <= stpw;
   
   if stp then buy to cover("xs.tp") next bar stpw limit
   else if mkt then buy to cover("xs.tp.m") this bar c;
  end;
  
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
 		);end;

end else begin
 id = text_new(d,t,c,"");
 text_setstyle(id,1,0);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
end;
