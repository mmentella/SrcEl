Inputs: lenl(20),lens(20),minlen(1),maxlen(50);


vars: k(0),sd(0),klenl(minlen),klens(minlen);
{***************************}
{***************************}
sd = StdDev(h,lenl);
if sd <> 0 then k = 1 - sd[1]/sd else k = 0;

klenl = lenl*(1 + k);
klenl = MinList(klenl,maxlen);
klenl = MaxList(klenl,minlen);
{***************************}
{***************************} 
sd = StdDev(l,lens);
if sd <> 0 then k = 1 - sd[1]/sd else k = 0;

klens = lens*(1 + k);
klens = minlist(klens,maxlen);
klens = maxlist(klens,minlen);
{***************************}
{***************************}
plot1(IntPortion(klenl),"Dynamic LenL");
plot2(IntPortion(klens),"Dynamic LenS");
