vars: id(0);

if currentbar > 1 then begin
 if d < 1121201 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 var: lenl(42),kl(0.3),lens(6),ks(1.9);
 
 var: stopl(355),funkl(365),brkl(140),tl(410);
 var: stops(320),funks(330),brks(120),ts(315);
 
 var: upb(0),lob(0),el(true),es(true),engine(true),orderL(true),orderS(true);
 var: trade(0),fnkl(false),fnks(false),dru(0),mcp(0);
 
 var: stpw(0),stpv(0),stp(true),mkt(false),nos(1),bpv(1/bigpointvalue);
 var: reason(0),position(0),stoploss(10),daystop(11),breakeven(12);
 {**************************}
 {**************************}
 if d <> d[1] then begin
  trade = 0;
  fnkl  = false;
  fnks  = false;
 end;
 {**************************}
 {**************************}
 upb = KeltnerChannel(h,lenl,kl);
 lob = KeltnerChannel(l,lens,-ks);
 
 el = c  < upb;
 es = c  > lob;
 
 engine = 00 < t and t  < 11000;
 {**************************}
 {**************************}
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
  nos   = currentcontracts;
 end;
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
 {**************************}
 {**************************} 
 fnkl = dru <= -funkl*nos;
 fnks = dru <= -funks*nos;
 {**************************}
 {**************************}
 orderL = false;
 orderS = false;
  
 if trade < 1 and engine then begin
  
  orderL = not fnkl and marketposition < 1 and el;
  if orderL then 
   buy("el") next bar upb stop;
  
  orderS = not fnks and marketposition > -1 and es;
  if orderS then
   sellshort("es") next bar lob stop;
   
 end;
 {**************************}
 {**************************}
 if marketposition = 1 then begin
  
  reason = position;
  stpw   = lob;
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  
  if orderS then begin
   if stpv > stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
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
  
  stpw = entryprice + tl*bpv;
  stp  = c <  stpw;
  mkt  = c >= stpw;
  
  if stp then sell("xl.tp") next bar stpw limit
  else if mkt then sell("xl.tp.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  reason = position;
  stpw   = upb;
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  
  if orderL then begin
   if stpv < stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
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
  
  stpw = entryprice - ts*bpv;
  stp  = c >  stpw;
  mkt  = c <= stpw;
  
  if stp then buy to cover("xs.tp") next bar stpw limit
  else if mkt then buy to cover("xs.tp.m") this bar c;
  
 end;
 {**************************}
 {**************************}
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
