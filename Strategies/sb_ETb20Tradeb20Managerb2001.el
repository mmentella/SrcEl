[LegacyColorValue = true]; 

{ACME TRADE MANAGER -SIGNAL}

Inputs:
systemid(""),
exitfactor(0.25),
stopbars(3),
profittarget(true),
profitfactor(0.9),
holdbars(5),
drawtargets (false),
logtrades(false),
logfile("order.txt"),
stpl(2);

variables:
atr(0.0),
atrlength(20),
atrfactor(0.0),
profitbars(0),
sellstop(0.0),
selltarget1(0.0),
selltarget2(0.0),
coverstop(0.0),
covertarget1(0.0),
covertarget2(0.0);

atr = AvgTrueRange(atrlength);
atrfactor = profitfactor * atr;
profitbars = intportion(holdbars/2) + 1;


sellstop = lowest(low, stopbars) - (exitfactor * atr);
Sell("LL -") next bar at sellstop stop;
if profittarget then begin
	selltarget1 = entryprice + atrfactor;
	Sell("TL +") currentcontracts/2 shares next bar at selltarget1 limit;
{	selltarget2 = high[profitbars] + (4 * atrfactor);
	exitlong("LX ++") currentcontracts/2 shares next bar at selltarget2 limit;}
end;
{if barssinceentry >= holdbars - 1 then exitlong("LX ++") currentcontracts/2 shares next bar at  selltarget1 limit;}


coverstop = highest(high, stopbars) + (exitfactor * atr);
	Buy to Cover("HH -") next bar at coverstop stop;
	if profittarget then begin
		covertarget1 = entryprice - atrfactor;
		Buy to Cover("TS +") currentcontracts/2 shares next bar at covertarget1 limit;
{		covertarget2 = low[profitbars] - (2 * atrfactor);
		exitshort("SX ++") CurrentContracts / 2 Shares Next Bar at CoverTarget2 Limit;}
end;

if drawtargets then
if marketposition = 1 then 
	condition1 = ETacmeexittargets(systemid, sellstop, selltarget1, selltarget2)
	else if  marketposition = -1 then
	condition1 = ETacmeexittargets(systemid, coverstop,covertarget1, covertarget2);

{condition1 = AcmeLogTrades(logtrades, logfile, systemid);}

{------------------------- stop loss fisso ----------------}

If MarketPosition = 1 then Sell ("SLL") Next Bar  at (Entryprice- Entryprice*stpl/100) stop;
If MarketPosition = - 1 then Buy to Cover ("SLS") Next Bar  at (Entryprice+ Entryprice*stpl/100) stop;

