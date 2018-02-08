inputs:
ShowNumber(true),
Color(white),
size(10),
ShowPlot(false);
   
variables:
AskID(-1),
BidID(-1),
TradeID(-1),
offset(0),
digits(0);

if currentbar = 1 then begin

 if bartype_ex = 2 then offset = barinterval * 100 else
 if bartype_ex = 3 then offset = barinterval * 10000 else
 if bartype_ex = 1 or bartype_ex = 8 or bartype_ex = 11 or bartype_ex = 13  then offset = 1 else
  offset = barinterval;
 
 if Mod(PriceScale,10) = 0 then digits = Log(PriceScale)/Log(10)
 else if Mod(PriceScale,2) = 0 then digits = Log(PriceScale)/Log(2);
end;

if currentbar = 1 then
begin
	AskID = Text_New_s(date,time_s, InsideAsk, NumToStr(insideAsk,digits));
	BidID = Text_New_s(date,time_s, InsideBid, NumToStr(insideBid,digits));
	TradeID = Text_New_s(date,time_s, c, NumToStr(c,digits));
	
	text_setcolor(AskID, Color);
	text_setstyle(AskID, 0, 1);
	text_setsize(AskID, size);	
	
	text_setcolor(BidID, Color);
	text_setstyle(BidID, 0, 0);
	text_setsize(BidID, size);
	
	text_setcolor(TradeID, Color);
	text_setstyle(TradeID, 0, 0);
	text_setsize(TradeID, size);
end; 

if ShowNumber then begin
	Text_setstring(AskID, NumToStr(insideAsk,digits));
	Text_setlocation_s(AskID, date,time_s + offset, InsideAsk);

	Text_setstring(BidID, NumToStr(insideBid,digits));
	Text_setlocation_s(BidID, date,time_s + offset, InsideBid);
	
	Text_setstring(TradeID, NumToStr(c,digits));
	Text_setlocation_s(TradeID, date,time_s + offset, c);
end else begin
	Text_setstring(AskID, "<");
	Text_setlocation_s(AskID, date,time_s + offset, InsideAsk );

	Text_setstring(BidID, "<");
	Text_setlocation_s(BidID, date,time_s + offset, InsideBid );
	
	Text_setstring(TradeID, "<");
	Text_setlocation_s(TradeID, date,time_s + offset, c );
	
end;

if ShowPlot and getappinfo(airealtimecalc) = 1 then begin
 plot1(insideask,"A");
 plot2(insidebid,"B");
 plot3(close,"C");
end;
