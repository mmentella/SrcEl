vars: id(0);

if currentbar > 1 then begin
 if d < 1111201 then begin
{***************************}
{***************************}
input: tal(0.70),sal(0.45),kal(0.30);
input: tas(0.30),sas(0.15),kas(0.25);

input: stopl(20.00),funkl(30.00),brkl(14.30),tl(50.00);
input: stops(22.50),funks(22.50),brks(22.00),ts(59.00);

var: trndl(0,data2),trgrl(0,data2),skewl(0,data2),kurtl(0,data2);
var: trnds(0,data2),trgrs(0,data2),skews(0,data2),kurts(0,data2);

var: trade(0),stpw(0),stpv(0),stp(true),mkt(false),nos(1),fnkl(false),fnks(false);
var: reason(0),stoploss(10),daystop(11),breakeven(12);
var: mcp(0),dru(0),bpv(1/bigpointvalue),mp(0),orderL(true),orderS(true);
{***************************}
{***************************}
if t = sessionendtime(0,1) or d > d[1] then begin
 trade = 0;
end;

mp = marketposition;

if mp <> mp[1] then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 
 trade = 0;

 MM.ITrend(medianprice,tal,trndl,trgrl)data2;
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal)data2;
 kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal)data2;
 
 MM.ITrend(medianprice,tas,trnds,trgrs)data2;
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas)data2;
 kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas)data2;
 
end;
{***************************}
{***************************}
orderL = false;
orderS = false;

if trade = 0 then begin
 
 orderL = marketposition < 1 and trgrl > trndl and skewl < 0;
 if orderL then
  buy("el") next bar o;
 
 orderS = marketposition > -1 and trgrs < trnds and skews > 0;
 if orderS then 
  sell short("es") next bar o;
 
 if not orderS then orderS = marketposition > -1 and trgrs < trnds and skews < 0 and kurts > 0;
 if orderS then
  sell short("xles") next bar o;
 
 if not orderL then orderL = marketposition < 1 and trgrl > trndl and skewl > 0 and kurtl > 0; 
 if orderL then
  buy("xsel") next bar o; 

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
 if LastBarOnChart then print(reason:2:0);
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
