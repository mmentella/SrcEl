Inputs: Price(C);

vars: var0(0),count(0);

if count = 0 then begin
 var0 = price;
 count = count + 1;
end else begin
 var0 = var0*count/(count+1) + Price/(count+1);
 count = count + 1;
end;

plot1(var0,"Perpetuum Mean");
