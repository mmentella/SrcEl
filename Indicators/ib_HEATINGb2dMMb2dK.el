Inputs: lenl(45),kl(1.971),lens(27),ks(3.307),alphal(.202),alphas(.2);

vars: upk(0,data2),lok(0,data2);

if barstatus(2) = 2 then begin
 
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);
 
end;

plot1(upk,"UpK");
plot2(lok,"LoK");
