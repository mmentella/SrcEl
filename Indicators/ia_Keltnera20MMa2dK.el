Inputs: lenl(20),kl(2),lens(20),ks(2),displace(-1);

Vars: upk(0),lok(0);

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

plot1[displace](upk,"UpperK");
plot2[displace](lok,"LowerK");
