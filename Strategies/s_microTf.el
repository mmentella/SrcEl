vars: id(0);

if currentbar > 1 then begin
 if d < 1111201 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 vars: alphal(0.27),lenl(21),rngl(.61);
 vars: alphas(.20),lens(03),rngs(.62);
 Input: stopl(540),funkl(340),tl(460);
 Input: stops(320),funks(220),ts(580); 
 
 vars: trndl(0,data2),trgl(0,data2),cycl(0,data2),fishl(0,data2),el(0,data2),bs(true,data2);
 vars: trnds(0,data2),trgs(0,data2),cycs(0,data2),fishs(0,data2),es(0,data2),ss(true,data2);
 
 vars: stpv(0),stp(true),mkt(false),fnkl(false),fnks(false),bpv(1/bigpointvalue),dru(0),nos(1);
 
 vars: trade(0);
 
 if barstatus(1) = 2 then begin
 
 if d > d[1] then begin
  trade = 0;
  fnkl  = false;
  fnks  = false;
 end;
 
 dru = MM.DailyRunup;
 
 end;
 
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
 
 if barstatus(1) = 2 then begin
 
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos   = currentcontracts;
 end;
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl)*bpv;
  stp  = c > stpv;
  mkt =  c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.trg") next bar stpv limit
  else if mkt then sell("xl.trg.m") this bar c;
 
 end else if marketposition = -1 then begin
 
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)*bpv;
  stp  = c < stpv;
  mkt =  c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.trg") next bar stpv limit
  else if mkt then buy to cover("xs.trg.m") this bar c;
 
 end;
 
 fnkl = dru <= -funkl*nos;
 fnks = dru <= -funks*nos;
 
 if trade = 0 then begin
  
  if not fnkl and marketposition < 1 and bs then
   buy("el") next bar el limit;
  
  if not fnks and marketposition > -1 and ss then
   sell short("es") next bar es limit;
   
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
