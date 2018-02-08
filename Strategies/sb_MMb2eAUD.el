inputs: lenl(20),kl(2),lens(20),ks(2);

vars: upk(0),lok(0),el(true),es(true),trade(0);

if d > d[1] then begin
 trade = 0;
end;

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;

if trade = 0 then begin
 
 if marketposition < 1 and el then
  buy("el") next bar upk stop;
 
 if marketposition > - 1 and es then
  sell short("es") next bar lok stop;
 
end;
