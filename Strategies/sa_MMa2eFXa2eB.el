Inputs: lenl(16),kl(4.9),lens(20),ks(4.43),intraday(0);

vars: upb(0),lob(0),el(true),es(true);

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

el = c  < upb;
es = c  > lob;

if marketposition < 1 and el then
 buy("el") next bar upb stop;
if marketposition > -1 and es then
 sellshort("es") next bar at lob stop;

if intraday = 1 then setexitonclose;
