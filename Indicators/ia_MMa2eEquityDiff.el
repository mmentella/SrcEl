Inputs: el_startdate(1100409),el_enddate(1100528);

vars: starteq(0),endeq(0);

if d <= el_startdate then starteq = i_ClosedEquity;
if d <= el_enddate then endeq = i_ClosedEquity;

if LastBarOnChart then begin
 plot1(endeq - starteq);
end;

if endeq > starteq then SetPlotColor(1,green) else SetPlotColor(1,red);
