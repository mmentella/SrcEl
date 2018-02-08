Inputs: LenL(34),KL(1),LenS(30),KS(4.8),Displace(0);

Vars: upperk(0),lowerk(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

plot1[displace](upperk,"UpperK");
plot2[displace](lowerk,"LowerK");
