vars: trend(0),trigger(0);

MM.ITrend(MedianPrice,.07,trend,trigger);

if trigger > trend then buy tomorrow at market;
if trigger < trend then sellshort tomorrow at market;
