Inputs: lenl(20),kl(2),lens(20),ks(2),displace(0);

Vars: upk(0,data2),lok(0,data2);

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;

plot1[displace](upk,"UpperK");
plot2[displace](lok,"LowerK");
