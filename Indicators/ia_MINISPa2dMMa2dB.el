inputs: lenl(20),kl(2),lens(20),ks(2),displace(-1);

vars: upb(0),lob(0),burst(true);

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

burst = upb > upb[1] and lob < lob[1];

plot10[displace](upb,"UPB");
plot20[displace](lob,"LOB");

if burst then PlotPB(h,l,o,c,"",white);
