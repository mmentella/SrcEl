Inputs: kl(2.65),ks(3.7),lenl(14),lens(11),minlen(5),maxlen(44);

vars: upk(0,data1),lok(0,data1),k(0,data1),sd(0,data1),dlenl(minlen,data1),dlens(minlen,data1);

sd    = StdDev(h,lenl)data1;
k     = iff(sd>0,1 - sd[1]/sd,0);

dlenl = dlenl*(1 + k);
dlenl = MinList(dlenl,maxlen);
dlenl = MaxList(dlenl,minlen);
dlenl = floor(dlenl);

upk   = KeltnerChannel(h,dlenl,kl)data1;

sd    = StdDev(l,lens)data1;
k     = iff(sd>0,1 - sd[1]/sd,0);

dlens = dlens*(1 + k);
dlens = minlist(dlens,maxlen);
dlens = maxlist(dlens,minlen);
dlens = floor(dlens);

lok   = KeltnerChannel(l,dlens,-ks)data1;

plot1(upk,"UpperK");
plot2(lok,"LowerK");
