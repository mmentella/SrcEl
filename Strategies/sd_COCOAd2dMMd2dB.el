inputs: lenl(18),kl(1.83),lens(10),ks(4.55);

vars: upb(0),lob(0);

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

if marketposition < 1 and c < upb then buy("el") next bar at upb stop;
if marketposition > -1 and c > lob then sellshort("es") next bar at lob stop;
