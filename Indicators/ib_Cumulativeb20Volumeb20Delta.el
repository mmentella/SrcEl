vars: intrabarpersist vol(0),intrabarpersist trade(0),intrabarpersist bid(0),intrabarpersist ask(0);

if getappinfo(airealtimecalc) = 1 then begin

 if d <> d[1] then vol = 0;
 
 trade = c;
 ask   = insideask;
 bid   = insidebid;
 
 trade = Round(trade[0],4);
 ask   = Round(ask[0],4);
 bid   = Round(bid[0],4);
 
 if trade >= ask then vol = vol + Ticks
 else if trade <= bid then vol = vol - Ticks;
 
 plot1(vol,"CVD");

end;
