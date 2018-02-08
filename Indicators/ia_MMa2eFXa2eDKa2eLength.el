Inputs: FL(0.2),FS(1.2),KLenL(33),KLenS(27),MinLen(9),MaxLen(50);

vars: K(0),SD(0),lenl(MinLen),lens(MinLen);

sd = StdDev(h,klenl);
if sd <> 0 then k = 1 - sd[1]/sd;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);
 
sd = StdDev(l,klens);
if sd <> 0 then k = 1 - sd[1]/sd;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

plot1(lenl,"LENS");
plot2(lens,"LENS");
