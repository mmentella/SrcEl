{********* - MM.G1.TF.AUD - ***********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    AUD
 TimeFrame: 60 min.
 BackBars:  500
 Date:      13 Gen 2011
**************************************}
inputs: alphal(.07),rngl(.1);
inputs: alphas(.07),rngs(.1);
inputs: sod(700),eod(2300);

vars: trndl(0),trgl(0),trnds(0),trgs(0),el(true),es(true),engine(true);
vars: trades(0);
{*************************************}
{*************************************}
if d <> d[1] then begin
 trades = 0;
end;
{*************************************}
{*************************************}
MM.ITrend(.5*(h+c),alphal,trndl,trgl);
MM.ITrend(.5*(l+c),alphas,trnds,trgs);

el = trgl > trndl;
es = trgs < trnds;

engine = sod < t and t < eod;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{*************************************}
{*************************************}
if trades = 0 and engine then begin
 if marketposition < 1 and el then
  buy("el") next bar c - rngl*range limit;
 if marketposition > -1 and es then
  sell short("es") next bar c + rngs*range limit;
end;
