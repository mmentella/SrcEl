Inputs: nos(1),lenl(20),kl(2),lens(20),ks(2),ccilen(14),ccilimit(100);

vars: upb(0),lob(0);

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);
