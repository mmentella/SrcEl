vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 vars: alphal(.52),lenl(2),rngl(.07),alphas(.01),lens(43),rngs(.17);
 Input: stopl(1200),funkl(1900),tl(2700);
 Input: stops(1050),funks(1200),ts(1650); 
 
 vars: trndl(0,data2),trgl(0,data2),cycl(0,data2),fishl(0,data2),el(0,data2),bs(true,data2);
 vars: trnds(0,data2),trgs(0,data2),cycs(0,data2),fishs(0,data2),es(0,data2),ss(true,data2);
 vars: stpv(0),stp(true),mkt(false),funk(false),bpv(1/bigpointvalue),mcp(0),dru(0),nos(1);
 
 vars: trade(0),engine(true);
 
 if d > d[1] then begin
  trade = 0;
  funk = false;
 end;
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
 
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
 
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos   = currentcontracts;
 end;
 
 engine = t < 1800;
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)*bpv;
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
  stpv = c + (dru/nos + funks)*bpv;
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
 
 funk = dru <= -minlist(funkl,funks)*nos;
 
 if not funk and trade = 0 and engine then begin
  
  if marketposition < 1 and bs then
   buy("el") next bar el limit;
  
  if marketposition > -1 and ss then
   sell short("es") next bar es limit;
   
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
