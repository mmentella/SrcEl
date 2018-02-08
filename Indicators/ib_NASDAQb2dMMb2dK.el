Inputs: nos(2),lenl(20),kl(2),alphal(.2),lens(20),ks(2),alphas(.2),adxlen(14),adxlimit(30);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),adxval(0,data2),engine(true,data2);

if currentbar > maxlist(lenl,lens) then begin

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);
end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;

plot1(upk,"UPK");
plot2(lok,"LOK");
