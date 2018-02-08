Inputs: kl(2.0),ks(2.0),lenl(20),lens(20),minlen(1),maxlen(50);

vars: upk(0),lok(0),k(0),sd(0),klenl(minlen),klens(minlen);
{***************************}
{***************************}
sd = StdDev(h,lenl);
if sd <> 0 then k = 1 - sd[1]/sd else k = 0;

klenl = lenl*(1 + k);
klenl = MinList(klenl,maxlen);
klenl = MaxList(klenl,minlen);

upk = KeltnerChannel(h,IntPortion(klenl),kl);
{***************************}
{***************************} 
sd = StdDev(l,lens);
if sd <> 0 then k = 1 - sd[1]/sd else k = 0;

klens = lens*(1 + k);
klens = minlist(klens,maxlen);
klens = maxlist(klens,minlen);

lok = KeltnerChannel(l,IntPortion(klens),-ks);
{***************************}
{***************************}
plot1[-1](upk,"DUPK");
plot2[-1](lok,"DLOK");
