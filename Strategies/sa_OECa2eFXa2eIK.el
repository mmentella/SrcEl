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
vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2);
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
end;
{***************************}
{***************************}
if t < 2300 then begin
 
 if marketposition < 1 and el and c < upk then
  buy("el") next bar upk stop;
 
 if marketposition > -1 and es and c > lok then
  sell short("es") next bar lok stop;
 
end;
{***************************}
{***************************}
if t >= 2259 and marketposition <> 0 then begin
 if marketposition = 1 then
  sell("xl") this bar c
 else buy to cover("xs") this bar c;
end;
