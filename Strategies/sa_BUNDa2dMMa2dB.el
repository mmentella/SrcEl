inputs: lenl(56),kl(2.89),lens(145),ks(1.86);

vars: upb(0),lob(0);

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

if marketposition < 1 and c < upb then buy("el") next bar at upb stop;
if marketposition > -1 and c > lob then sellshort("es") next bar at lob stop;
