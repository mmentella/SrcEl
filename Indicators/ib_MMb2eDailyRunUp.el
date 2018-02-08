Input: Period(5),SmoothPeriod(5),Conversion(1),Ref(-3500);

vars: dru(0);

dru = MM.DailyRunup*Conversion;

plot1(dru,"Daily",green);

if plot1 < 0 then SetPlotColor(1,red);

plot2(Ref,"Ref");
plot3(0,"Zero");{
plot4((MM.MovingWave(Period,SmoothPeriod)data2)*bigpointvalue,"Average Range");
plot5(i_OpenEquity - i_ClosedEquity,"Position Profit");
}
