inputs: lenl(19),kl(2.38),lens(162),ks(1.99);

vars: upb(0),lob(0);
vars: trades(0);

if d <> d[1] then begin
 trades = 0;
end;

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if trades < 1 then begin
 if marketposition < 1 and c < upb then
  buy next bar at upb stop;
 if marketposition > -1 and c > lob then
  sellshort next bar at lob stop;
end;
