Inputs: LenL(25),KL(1.5),LenS(35),KS(1.5);

Vars: lowerk(0,data2),upperk(0,data2);

lowerk = KeltnerChannel(l,lens,-ks)data2;
upperk = KeltnerChannel(h,lenl,kl)data2;

plot1(upperk,"UP");
plot2(lowerk,"LOW");
