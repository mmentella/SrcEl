{********** - TEST.NOSTOP - ***********
 Engine:    TSK - Trend Skewness Kurtosis
 Author:    Matteo Mentella
 Portfolio: 
 Market:    EUREX DAX FUTURES
 TimeFrame: 1 h
 Session 1: 08:00 22:00
 BackBars:  5
 Date:      06 Set 2011
**************************************}
[IntrabarOrderGeneration = true]
var: tal(0.987),sal(0.238),kal(0.818);
var: tas(0.071),sas(0.371),kas(0.588);

var: stopl(2200),funkl(3200),{brkl(100000),}tl(3600);
var: stops(1800),funks(2400),brks(00002100),ts(4600);

var: trndl(0),trgrl(0),skewl(0),kurtl(0);
var: trnds(0),trgrs(0),skews(0),kurts(0);

var: IntraBarPersist trade(0), IntraBarPersist nos(1), IntraBarPersist mkt(false);

var: dru(0),mcp(0),fnkl(false),fnks(false),bpv(1/bigpointvalue);
var: stpv(0),stpw(0),stp(true);

var: reason(0),stoploss(10),daystop(11),breakeven(12),target(20);

var: id1(0),id2(0);
{***************************}
{***************************}
if currentbar = 1 then begin
 id1 = text_new(d,t,c,"Real Time");
 id2 = text_new(d,t,c,"Back Test");
 
 text_setstyle(id1,1,0);
 text_setsize(id1,10);
 text_setcolor(id1,white);
 text_setattribute(id1,2,true);
 text_setattribute(id1,1,true);
 
 text_setstyle(id2,1,0);
 text_setsize(id2,10);
 text_setcolor(id2,white);
 text_setattribute(id2,2,true);
 text_setattribute(id2,1,true);
 
 cleardebug;
end;
{***************************}
{***************************}
if getappinfo(aistrategyauto) = 1 then raiseruntimeerror("That's only a test!!");
{***************************}
{***************************}
if d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;
{***************************}
{***************************}
if barstatus(1) = 2 then begin
 MM.ITrend(medianprice,tal,trndl,trgrl);
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);
 kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal);
 
 MM.ITrend(medianprice,tas,trnds,trgrs);
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);
 kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas);
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if marketposition = 1 then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice - stopl*bpv;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if t < sessionendtime(0,1) and stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 {
 //BREAKEVEN
 stpv = entryprice + 12*MinMove points;
 
 if mcp > brkl*bpv and stpv > stpw then begin
  reason = breakeven;
  stpw   = stpv;
 end;
 }
 stp = c >  stpw;
 mkt = c <= stpw; 
 
end else if marketposition = -1 then begin
 
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
 stpv = entryprice - 12*MinMove points;
 
 if mcp > brks*bpv and stpv < stpw then begin
  reason = breakeven;
  stpw   = stpv;
 end;
 
 stp = c <  stpw;
 mkt = c >= stpw;
 
end;
{***************************}
{***************************}
if getappinfo(airealtimecalc) = 1 then begin
 
 text_setlocation(id1,d,t,c);
 
 if marketposition <> 0 and barssinceentry = 0 then
  FileAppend("C:\MM.LOG\LOG.txt", "ENTRY " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                              MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
 
 if marketposition = 1 then begin
  
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if mkt then begin
    sell("xl.stp.rt") this bar c;
    FileAppend("C:\MM.LOG\LOG.txt", "xl.stp.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                                    MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
   end;
  end else
  if reason = daystop then begin
   if mkt then begin
    sell("xl.funk.rt") this bar c;
    FileAppend("C:\MM.LOG\LOG.txt", "xl.funk.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                                    MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
   end;
  end {else
  if reason = breakeven then begin
   if mkt then sell("xl.brk.rt") this bar c;
  end};
  
  if c >= entryprice + tl*bpv then begin
   sell("xl.trgt.rt") this bar c;
   FileAppend("C:\MM.LOG\LOG.txt", "xl.trgt.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                              MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
  end;
  
 end else if marketposition = -1 then begin
  
  mkt = c >= stpw;
  
  if reason = stoploss then begin
   if mkt then begin
    buy to cover("xs.stp.rt") this bar c;
    FileAppend("C:\MM.LOG\LOG.txt", "xs.stp.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                                    MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
   end;
  end else
  if reason = daystop then begin
   if mkt then begin
    buy to cover("xs.funk.rt") this bar c;
    FileAppend("C:\MM.LOG\LOG.txt", "xs.funk.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                                    MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
   end;
  end else
  if reason = breakeven then begin
   if mkt then begin
    buy to cover("xs.brk.rt") this bar c;
    FileAppend("C:\MM.LOG\LOG.txt", "xs.brk.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                                    MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine);
   end;
  end;
  
  if c <= entryprice - ts*bpv then begin
   buy to cover("xs.trgt.rt") this bar c;
   FileAppend("C:\MM.LOG\LOG.txt", "xs.trgt.rt " + NumToStr(marketposition,0) + " " + NumToStr(c,2) + " " + 
                              MM.ELDateToString_IT(d) + " " + MM.CurrentTimeToStr_IT + NewLine + NewLine);
  end;
 
 end;
 
end else if barstatus(1) = 2 then begin
 
 text_setlocation(id2,d,t,c);
 
 if marketposition = 1 then begin
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else
  if reason = daystop then begin
   if stp then sell("xl.funk") next bar stpw stop
   else if mkt then sell("xl.funk.m") this bar c;
  end {else
  if reason = breakeven then begin
   if stp then sell("xl.brk") next bar stpw stop
   else if mkt then sell("xl.brk.m") this bar c;
  end};
  
  sell("xl.trgt") next bar entryprice + tl*bpv limit;
  
 end else if marketposition = -1 then begin
 
  if reason = stoploss then begin
   if stp then buy to cover("xs.stp") next bar stpw stop
   else if mkt then buy to cover("xs.stp.m") this bar c;
  end else
  if reason = daystop then begin
   if stp then buy to cover("xs.funk") next bar stpw stop
   else if mkt then buy to cover("xs.funk.m") this bar c;
  end else
  if reason = breakeven then begin
   if stp then buy to cover("xs.brk") next bar stpw stop
   else if mkt then buy to cover("xs.brk.m") this bar c;
  end;
  
  buy to cover("xs.trgt") next bar entryprice - ts*bpv limit;
 
 end;

end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if barstatus(1) = 2 and trade = 0 then begin
 
 if not fnkl and marketposition < 1 and trgrl > trndl and skewl < 0 then
  buy("el") next bar o;
 
 if not fnks and marketposition > -1 and trgrs < trnds and skews > 0 then 
  sell short("es") next bar o;
 
 if not fnks and marketposition = 1 and trgrs < trnds and skews < 0 and kurts < 0 then
  sell short("xles") next bar o;
 
 if not fnkl and marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl < 0 then
  buy("xsel") next bar o;
 
end;
{***************************}
{***************************}
