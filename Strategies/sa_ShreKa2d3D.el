Inputs: lenl(20),kl(2),lens(20),ks(2),sod(700),eod(2300);

vars: upk(0),lok(0),el(true),es(true),engine(true),trades(0);

if d <> d[1] then begin
 trades = 0;
end;

upk = BollingerBand(h,lenl,kl);
lok = BollingerBand(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = sod < t and t < eod;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if trades = 0 and engine then begin
 
 if marketposition < 1 and el then
  buy next bar upk stop;
  
 if marketposition > -1 and es then
  sell short next bar lok stop;
  
end;
