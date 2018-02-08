Inputs: NoS(2),FL(2.65),FS(3.7),KLenL(14),KLenS(11),MinLen(5),MaxLen(44);
Inputs: TargetL(2800),TargetS(1400),StopL(2600),StopS(1000),BKL(700),BKS(1200);

Vars: UpperK(0,data2),LowerK(0,data2),K(0,data2),SD(0,data2),lenl(MinLen,data2),lens(MinLen,data2),
      posprofit(0),work(false);

work = time data2 > 700 and time data2 < 2300;

sd = StdDev(h,klenl) data2;
k = 1 - sd[1]/sd;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(h,lenl,fl) data2;
 
sd = StdDev(l,klens) data2;
k = 1 - sd[1]/sd;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lowerk = KeltnerChannel(l,lens,-fs) data2;

if work then begin
 if c < upperk and c data2 < upperk then buy("el") nos shares next bar at upperk stop;
 if c > lowerk and c data2 > lowerk then sellshort("es") nos shares next bar at lowerk stop;
end;
