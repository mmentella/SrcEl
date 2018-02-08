{********* - MM.FX.K.XAU - ***********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: MMFX
 Market:    XAUUSD
 TimeFrame: 1 min.
 BackBars:  2
 Date:      08 Gen 2011
**************************************}
vars: upk(0),lok(0),el(true),es(true);
{***************************}
{***************************}
upk = h + .1*TrueRange;
lok = l - .1*TrueRange;

el = c < upk;
es = c > lok;
{***************************}
{***************************}
if marketposition < 1 and el then
 buy("el") next bar upk stop;
if marketposition > -1 and es then
 sell short("es") next bar lok stop;
{***************************}
{***************************}
//MM.LOG;
