Inputs: lenl(54),kl(3.869),lens(15),ks(5.71),displace(-1);

vars: upk(0,data2),lok(0,data2);

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;

plot1[displace](upk,"UPK");
plot2[displace](lok,"LOK");
