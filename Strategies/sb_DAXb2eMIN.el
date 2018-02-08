vars: id(0);

if currentbar > 1 then begin
 if d < 1111201 then begin
{***************************}
{***************************}
input: lenl(41),lens(22);

input: stopl(5200),funkl(3600),brkl(4300),tl(7350);
input: stops(5400),funks(6000),brks(2100),ts(6300);

var: hrl(0),hh(0);
var: hrs(0),ll(0);

var: trade(0),stpw(0),stpv(0),stp(true),mkt(false),nos(1),fnkl(false),fnks(false);
var: reason(0),stoploss(10),daystop(11),breakeven(12);
var: mcp(0),dru(0),bpv(1/bigpointvalue),mp(0),orderL(true),orderS(true);
{***************************}
{***************************}
if d > 1110801 then begin
{***************************}
{***************************}
if hrl = 0 then begin

 hrl = AvgTrueRange(lenl);
 hrs = AvgTrueRange(lens);
 ll  = Lowest(l,lenl);
 hh  = Highest(h,lens);
 
end else begin
 
 dru = MM.DailyRunup;
 mcp = MM.MaxContractProfit;
 
 orderL = marketposition < 1 and TrueRange > hrl and c > o and l < ll and DownTicks > UpTicks;
 if orderL then
  buy next bar o;
  
 orderS = marketposition > -1 and TrueRange > hrs and c < o and h > hh and UpTicks > DownTicks;
 if orderS then
  sell short next bar o;
  
 hrl = AvgTrueRange(lenl);
 hrs = AvgTrueRange(lens);
 ll  = Lowest(l,lenl);
 hh  = Highest(h,lens);

end;
{***************************}
{***************************}
if marketposition = 1 and not orderL then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice - stopl*bpv;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if t < sessionendtime(0,1) and stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice + 40*MinMove points;
 
 if mcp > brkl*bpv and stpv > stpw then begin 
  reason = breakeven;
  stpw   = stpv;
 end;
 
 stp = c >  stpw;
 mkt = c <= stpw;
 
 if reason = stoploss then begin
  if stp then sell("xl.stp") next bar stpw stop
  else if mkt then sell("xl.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then sell("xl.fnk") next bar stpw stop
  else if mkt then sell("xl.fnk.m") this bar c;
 end else 
 if reason = breakeven then begin 
  if stp then sell("xl.brk") next bar stpw stop
  else if mkt then sell("xl.brk.m") this bar c;
 end;
 
 //TARGET
 stpw = entryprice + tl*bpv;
 stp  = c <  stpw;
 mkt  = c >= stpw;
 
 if stp then sell("xl.tp") next bar stpw limit
 else if mkt then sell("xl.tp.m") this bar c;
 
end else if marketposition = -1 and not orderS then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice + stops*bpv;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 
 if t < sessionendtime(0,1) and stpv < stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice - 40*MinMove points;
 
 if mcp > brks*bpv and stpv < stpw then begin 
  reason = breakeven;
  stpw   = stpv;
 end;
 
 stp = c <  stpw;
 mkt = c >= stpw;
 
 if reason = stoploss then begin
  if stp then buy to cover("xs.stp") next bar stpw stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then buy to cover("xs.fnk") next bar stpw stop
  else if mkt then buy to cover("xs.fnk.m") this bar c;
 end else
 if reason = breakeven then begin
  if stp then buy to cover("xs.brk") next bar stpw stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
 end;
 
 //TARGET
 stpw = entryprice - ts*bpv;
 stp  = c >  stpw;
 mkt  = c <= stpw;
 
 if stp then buy to cover("xs.tp") next bar stpw limit
 else if mkt then buy to cover("xs.tp.m") this bar c;
 
end;
{***************************}
{***************************}
end;
{***************************}
{***************************}
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
{***************************}
{***************************}
