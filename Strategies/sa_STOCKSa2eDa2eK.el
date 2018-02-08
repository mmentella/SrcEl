{*********** - MM.FX.K.IK - ***********
 Engine:    Intraday Volatility
 Author:    Matteo Mentella
 Portfolio: MMFX
 Market:    EURUSD
 TimeFrame: 60 min.
 BackBars:  50
 Date:      20 Gen 2011
**************************************}
Inputs: lenl(20),kl(2),lens(20),ks(2);
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
 buy("el") next bar upk stop;

if marketposition > -1 and es then
 sell short("es") next bar lok stop;
