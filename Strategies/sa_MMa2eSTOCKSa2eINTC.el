Inputs: lenl(20),kl(2),lens(20),ks(2);

vars: upk(0),lok(0),el(true),es(true);

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

if marketposition < 1 and el then
 buy next bar upk stop;

if marketposition > -1 and es then
 sell short next bar lok stop;
