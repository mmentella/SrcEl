Inputs: lenl(20),kl(2),lens(20),ks(2);

vars: vup(0),vlo(0);

vup = average(h,lenl) + kl*average(absvalue(h - h[1]),lenl);
vlo = average(l,lens) - ks*average(absvalue(l - l[1]),lens);

plot1(vup,"Vol UP");
plot2(vlo,"Vol Low");
