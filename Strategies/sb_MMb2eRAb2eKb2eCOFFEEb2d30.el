{******** - MM.RA.K.COFFEE - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    COFFEE
 TimeFrame: 30 min.
 BackBars:  50
 Date:      07 Lug 2011
**************************************}
Inputs: lenl(1),kl(4.5),lens(5),ks(4.5),mngmnt(1);
Inputs: stopl(2250.00),funkl(2906.25),tl(6000.00);
Inputs: stops(3168.75),funks(3075.00),ts(3675.00);

vars: upk(0),el(true),lok(0),es(true),trades(0);
vars: dru(0),stpv(0),stp(true),mkt(true),nos(1);
vars: engine(true),fnkl(true),fnks(false),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
 fnks   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = t < 1900;
{***************************}
{***************************}
if mngmnt = 1 then begin
if marketposition = 1 then begin

 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar at stpv stop;
 if mkt then sell("xl.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru/nos + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar at stpv stop;
 if mkt then sell("xl.funk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.prft") next bar at stpv limit;
 if mkt then sell("xl.prft.m") this bar c;
 
end else if marketposition = -1 then begin
  
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stp") next bar at stpv stop;
 if mkt then buy to cover("xs.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c + (dru/nos + funks)*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.funk") next bar stpv stop;
 if mkt then buy to cover("xs.funk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.prft") next bar at stpv limit;
 if mkt then buy to cover("xs.prft.m") this bar c;
 
end;
end;
{***************************}
{***************************}
fnkl = dru <= - funkl * nos;
fnks = dru <= - funks * nos;
{***************************}
{***************************}
if engine and trades < 1 then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upk stop;
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lok stop;
  
end;
{***************************}
{***************************}
