Inputs: LenL(34),KL(1),LenS(30),KS(4.8),Displace(0);

Vars: upperk(0,data2),lowerk(0,data2);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;

plot1[displace](upperk,"UpperK");
plot2[displace](lowerk,"LowerK");
