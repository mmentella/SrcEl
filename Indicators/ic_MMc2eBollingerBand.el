Inputs: lenl(20),kl(2),lens(20),ks(2);

vars: upb(0,data2),lob(0,data2);

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
end;

plot1(upb,"UP");
plot2(lob,"LOW");
