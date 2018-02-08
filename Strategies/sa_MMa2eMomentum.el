input: periodo(200);

var: mom(0),sig15(0),sigDay(0),sig60(0),totalSig(0);
var: trade(0),goL(true),goS(true);

if d > d[1] then begin
 trade = 0;
 goL   = true;
 goS   = true;
end;

//Calcolo indicatori su 15 minuti
mom = Momentum(c,periodo);
if mom > 0 then
   sig15 = 1;

if mom < 0 then
   sig15 = -1;

//Calcolo indicatori su 60 minuti
mom = momentum(c,periodo*4);
if mom > 0  then
   sig60 = 1;

if mom < 0  then
   sig60 = -1;

//Calcolo indicatori su Giornaliero
mom = momentum(c,periodo*56);
if mom > 0  then
   sigDay = 1;

if mom < 0 then
   sigDay = -1;

totalSig = sig15 +sigDay + sig60;

if trade < 2 then begin

 if goL and totalSig > 0 then begin
  buy next bar o;
  trade = trade + 1;
  goL   = false;
 end;  

 if goS and totalSig < 0 then begin
  sell short next bar o;
  trade = trade + 1;
  goS   = false;
 end;

end;
