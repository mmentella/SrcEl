{******** - MM.FX.K.EURUSD - *********
 Engine:    MicroWave
 Author:    Matteo Mentella
 Portfolio: MMFX
 Market:    EURUSD
 TimeFrame: 1 min.
 BackBars:  2
 Date:      08 Gen 2011
**************************************}
Inputs: lenl(18),kl(.5),lens(17),ks(1.1);
vars: upk(0),lok(0),el(true),es(true);
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;
{***************************}
{***************************}
if t < 2300 then begin
 if marketposition < 1 and el then
  buy("el") next bar at upk stop;
 if marketposition > -1 and es then
  sell short("es") next bar at lok stop;
end;
{***************************}
{***************************
if t >= 2300 and marketposition <> 0 then begin
 if marketposition = 1 then sell("xl") this bar c
 else buy to cover("xs") this bar c;
end;
***************************}
{***************************}
