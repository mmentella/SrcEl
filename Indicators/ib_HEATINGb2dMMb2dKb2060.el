Inputs: lenl(20),kl(2),lens(20),ks(2),alphal(.2),alphas(.2);

vars: upk(0),lok(0),adxval(0);

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

upk = MM.Smooth(upk,alphal);
lok = MM.Smooth(lok,alphas);

plot1(upk,"UpperK");
plot2(lok,"LowerK");
