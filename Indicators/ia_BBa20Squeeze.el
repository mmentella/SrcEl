{04/05/2006}
//Updated by TradingDude, fixed "division by zero error"

{02/16/2005}
{Updated by Redlock}
{
Well, I have been working in this indicator. I have made a couple of changes:
(1) that if the momentum changes direction, it changes color.
(2) I have taken out the plotting of the alertline
(3) have the dots plotted along the axis
(4) Have changed the name of the indicator to BBSqueeze (cuts down on confusion).

I think that you will find that it resembles what is on the TTM indicator.}

{------------------------------------------------------------------}
{mmillar, 05/12/2005
For anyone interested I made a small change to the indicator(s) above.
I found that the indicator displayed fine for ES, YM etc but screwed up for FX -
this is due to the number of decimal places used by the symbol.
I just added a multiplier so the indicator is normalised across all symbols.

Add the following lines...
Vars: LHMult(0);
if ( barnumber=1 ) then Begin
LHMult=pricescale/minmove;
end;

And modify the following line so that it includes the LHMult variable...

Plot3(value2*LHMult, "NickmNxtMove", color);

}

{ Bolinger Band Squeeze (BBS) Indicator }

{ A variation of an idea by nickm001 (Originally coded by eKam) that when Bollinger Bands (BB) fit inside
the Keltner Channel (KC), a breakout is about to occur. It works on longer term charts, such as
15 minute to daily charts.

This code creates an indicator that plots the ratio of BB width to KC width. When BB and KC widths are
the same, the ratio (BBS_Ind)is equal to one (1). When the BB width is less than the KC Width (i.e. BB
fit inside KC), the BBS_Ind is less than one and a breakout is indicated.

An Alert Line is provided to indicate the level at which the trader considers that the "sqeeze is on" and
a breakout is eminant.

Coded by Kahuna 9/10/2003

Added by eKam: 9/10/2003
The average of where price has been relative to the Donchian mid line and Exponential average of the
same length is also plotted as an attempt to predict the direction of the breakout.

Added 2/1/2005 For decreasing Delta bar....darker colors to highlight the change.}

Inputs: {------------------------------------------------}
Price(Close),
Length(20), { Length for Average True Range (ATR) & Std. Deviation (SD) Calcs }
nK(1.5), { Keltner Channel ATRs from Average }
nBB(2), { Bollinger Band Std. Devs. from Average }
AlertLine( 1 ), { BBS_Index level at which to issue alerts }
NormalColor( Red ), { Normal color for BBS_Ind }
AlertlColor( Blue ); { Color for BBS_Ind below alert line }


Variables: {---------------------------------------------}
ATR(0), { Average True Range }
SDev(0), { Standard Deviation }
BBS_Ind(0), { Bollinger Band Squeeze Indicator }
alertTextID(-1),
Denom(0),
LHMult(0);



if ( barnumber=1 ) then
Begin
If minmove <> 0 then
LHMult = pricescale/minmove;
end;

if barnumber = 1 and alertTextID = -1 then
alertTextID = Text_New(date,time,0,"dummy");

{-- Calculate BB Squeeze Indicator ----------------------}
ATR = AvgTrueRange(Length);
SDev = StandardDev(Price, Length, 1);

Denom = (nK*ATR);
If Denom <> 0 then
BBS_Ind = (nBB * SDev) /Denom;

If BBS_Ind < Alertline then
SetPlotColor(1, NormalColor)
else
SetPlotColor(1, AlertlColor);

{-- Plot the Index & Alert Line -------------------------}
Plot1(0, "BBS_Ind");

{-- Plot delta of price from Donchian mid line ----------}
value2 = LinearRegValue(price-((Highest(H, Length)+Lowest(L, Length))/2
+ xAverage(c,Length))/2,Length,0);

var:color(0); color = yellow;

if value2 > 0 then
if value2 > value2[1] then
color = green
else
color = darkgreen;

if value2 < 0 then
if value2 < value2[1] then color = red
else
color = darkred;

Plot3(value2*LHMult, "NickmNxtMove", color);
{plot3(value2,"BB Squeeze",color);}

{-- Issue Alert when the Squeeze is On ------------------}
if BBS_Ind crosses below AlertLine
and Text_GetTime(alertTextID) <> time then
begin
text_setLocation(alertTextID, date, time, 0);
Alert("BB Squeeze Alert");
end;

{-- Issue Alert when the Squeeze Releases ---------------}
if BBS_Ind crosses above AlertLine
and Text_GetTime(alertTextID) <> time then
begin
text_setLocation(alertTextID, date, time, 0);
Alert("BB Squeeze Is Over");
end;
