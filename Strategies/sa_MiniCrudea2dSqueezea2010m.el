Inputs: NoS(2),Length(16),nTop(1.94),nBot(1.9),sbw(0.7),bbw(2.2),mfl(14);

Inputs: SOD(1530),EOD(2030);

Vars: squeeze(false),burst(false),top(0),bot(0),bw(0),rval(0),mf(0);

top = BollingerBand(Close,length,ntop);
bot = BollingerBand(Close,length,-nbot);
bw = top - bot;
mf = MoneyFlow(mfl);

squeeze = bw < sbw;
burst = bw > bbw;
{
if Date <> Date[1] then begin
 if marketposition = 1 then sell("wewe-l") NoS shares this bar on close;
 if marketposition = -1 then buytocover("wewe-s") NoS shares this bar on close;
end;
}
if Time > SOD and Time < EOD then begin

if squeeze = true then begin
 if close > top then buy("long") NoS shares next bar at High stop;
 if close < bot then sellshort("short") NoS shares next bar at Low stop;
end;

if burst = true then begin
 if marketposition = 1 and Close < top then sell("xl") entry("long") NoS shares next bar at Low stop;
 if marketposition = -1 and Close > bot then buytocover("xs") entry("short") NoS shares next bar at High stop;
end;

{******WALKING THE BAND******}
if burst = false and squeeze = false then begin
 if mf < 20 then sellshort("wb-s") NoS shares next bar at bot stop;
 if mf > 80 then buy("wb-l") NoS shares next bar at top stop;
end;

end;
{
if time > EOD then begin
 if marketposition = 1 then sell("late-l") NoS shares this bar on close;
 if marketposition = -1 then buytocover("late-s") NoS shares this bar on close;
end;
}
