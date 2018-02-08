{******** - MM.H1.TF.FTSE - **********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: H1
 Market:    FTSE 100
 TimeFrame: 60 min.
 BackBars:  50
 Date:      07 FFeb 2011
*************************************}
Inputs: alphal(.07),rngpctl(.1),alphas(.07),rngpcts(.1);

vars: trndl(0),trgrl(0),trnds(0),trgrs(0);
vars: el(true),es(true),entrylong(0),entryshort(0);
vars: trades(0),stpv(0),stp(true),mkt(false);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
end;
{***************************}
{***************************}
MM.ITrend(MedianPrice,alphal,trndl,trgrl);
MM.ITrend(MedianPrice,alphas,trnds,trgrs);

el = trgrl > trndl;
es = trgrs < trnds;

entrylong  = c - rngpctl*Range;
entryshort = c + rngpcts*Range;
{***************************}
{***************************}
if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{***************************}
{***************************}
if trades < 1 then begin
 
 stp = c > entrylong;
 mkt = c <= entrylong;
 
 if el and marketposition < 1 then begin
  if stp then buy("el.s") next bar entrylong limit
  else if mkt then buy("el.m") this bar c;
 end;
 
 stp = c < entryshort;
 mkt = c >= entryshort;
 
 if es and marketposition > -1 then begin
  if stp then sellshort("es.s") next bar entryshort limit
  else if mkt then sellshort("es.m") this bar c;
 end;

end;
