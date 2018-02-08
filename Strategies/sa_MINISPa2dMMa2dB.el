inputs: lenl(20),kl(2),lens(20),ks(2);

vars: upb(0),lob(0);

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

if 800 < t and t < 2300 then begin
 if c < upb then buy("el") next bar at upb stop;
 if c > lob then sellshort("es") next bar at lob stop;
end;
