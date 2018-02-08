{******** - MM.RA.K.CAC40 - *********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    CAC
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      13 Set 2011
*************************************}
input: lenl(1),kl(0.1),alphal(1);
input: lens(1),ks(0.1),alphas(1);
input: adxlen(14),adxlimit(30),moneymanagement(false);


vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),trade(true);

if currentbar > maxlist(lenl,lens) then begin

if d <> d[1] then begin trade = true; end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal)data2;
 lok = MM.Smooth(lok,alphas)data2;
 
 adxval = adx(adxlen)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
end;

if moneymanagement and marketposition <> 0 then begin
  
 if barssinceentry = 0 then trade = false;
 
 if marketposition = 1 then begin
  
 end else begin
  
 end;
  
end;

//ENGINE
if 100 < t and t < 21000 and trade and adxval < adxlimit then begin

 if marketposition < 1 and el and c < upk then 
  buy("el") 2 shares next bar upk stop;
  
 if marketposition > -1 and es and c > lok then
  sell short("es") 2 shares next bar lok stop;
  
end;

end else begin
 upk = KeltnerChannel(h, lenl, kl)data2;
 lok = KeltnerChannel(l, lens, -ks)data2;
end;
