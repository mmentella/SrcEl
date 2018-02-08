Inputs: lenl(26),kl(1.188),lens(82),ks(2.888),alphal(.121),alphas(.21);

vars: upk(0,data2),lok(0,data2);

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
plot1(upk,"Upper");
plot2(lok,"Lower");
