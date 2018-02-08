{******** - MM.FX.K.EURUSD - *********
 Engine:    MicroWave
 Author:    Matteo Mentella
 Portfolio: MMFX
 Market:    EURUSD
 TimeFrame: 1 min.
 BackBars:  2
 Date:      08 Gen 2011
**************************************}
Inputs: lenl(1),kl(1.7),lens(2),ks(1.3);
vars: upk(0),lok(0),el(true),es(true);
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;
{***************************}
{***************************}
if marketposition < 1 and el then
 buy("el") next bar at upk stop;
if marketposition > -1 and es then
 sell short("es") next bar at lok stop;
