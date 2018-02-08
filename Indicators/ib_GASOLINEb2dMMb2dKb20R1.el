inputs: lenl(40),kl(0.3),lens(9),ks(3.6),displace(-1);

vars: upk(0),lok(0);

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

plot1[displace](upk,"UPK");
plot2[displace](lok,"LOK");
