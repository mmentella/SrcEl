Inputs: NoS(2),FL(4.08),FS(3.45),KLenL(8),KLenS(7),MinLen(2),MaxLen(32);

Vars: UpperK(0,data2),LowerK(0,data2),K(0,data2),SD(0,data2),lenl(MinLen,data2),lens(MinLen,data2),
      posprofit(0),work(false);

work = time data2 > 1000 and time data2 < 2000;

sd = StdDev(h,klenl) data2;
k = iff(sd<>0,1 - sd[1]/sd,0);

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(h,lenl,fl) data2;
 
sd = StdDev(l,klens) data2;
k = iff(sd<>0,1 - sd[1]/sd,0);

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lowerk = KeltnerChannel(l,lens,-fs) data2;

if work then begin
 if c < upperk and c data2 < upperk then buy("el") nos shares next bar at upperk stop;
 if c > lowerk and c data2 > lowerk then sellshort("es") nos shares next bar at lowerk stop;
end;
