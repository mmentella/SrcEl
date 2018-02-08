inputs: lenl(67),kl(1.43),lens(60),ks(2.02);

vars: upb(0,data2),lob(0,data2);

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
end;

plot1(upb,"UPB");
plot2(lob,"LOB");
