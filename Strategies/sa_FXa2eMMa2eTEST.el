vars: trend(0),trigger(0),cycle(0);

MM.ITrend(medianprice,.07,trend,trigger);
cycle = MM.Cycle(medianprice,.07);

//setstoploss(20);
//setprofittarget(50);

if trigger > trend then buy this bar c;
if trigger < trend then sell short this bar c;

{
if marketposition = 1 and cycle < cycle[1] then sell this bar c;
if marketposition = -1 and cycle > cycle[1] then buy to cover this bar c;
}
