Inputs: kl(2.65),ks(3.7),lenl(14),lens(11),minlen(5),maxlen(44);

vars: upk(0,data2),lok(0,data2),k(0,data2),sd(0,data2),dlenl(minlen,data2),dlens(minlen,data2);

sd    = StdDev(h,lenl)data2;
k     = 1 - sd[1]/sd;

dlenl = dlenl*(1 + k);
dlenl = MinList(dlenl,maxlen);
dlenl = MaxList(dlenl,minlen);
dlenl = floor(dlenl);

upk   = KeltnerChannel(h,dlenl,kl)data2;

sd    = StdDev(l,lens)data2;
k     = 1 - sd[1]/sd;

dlens = dlens*(1 + k);
dlens = minlist(dlens,maxlen);
dlens = maxlist(dlens,minlen);
dlens = floor(dlens);

lok   = KeltnerChannel(l,dlens,-ks)data2;

plot1(upk,"UpperK");
plot2(lok,"LowerK");
