{********** - MM.H1.DK.GBP - **********
 Engine:    DINAMIC KELTNER
 Author:    Matteo Mentella
 Portfolio: H1
 Market:    BRITISH POUND
 TimeFrame: 60 min.
 BackBars:  50
 Date:      01 Mar 2011
**************************************}
Inputs: lenl(20),kl(2.0),lens(20),ks(2.0),minlen(1),maxlen(50);

vars: upk(0),lok(0),k(0),sd(0),klenl(minlen),klens(minlen);
{***************************}
{***************************}
sd = StdDev(h,lenl);
if sd <> 0 then k = 1 - sd[1]/sd;

klenl = klenl*(1 + k);
if klenl > maxlen then klenl = maxlen
else if klenl < minlen then klenl = minlen;

upk = KeltnerChannel(h,IntPortion(klenl),kl);
{***************************}
{***************************} 
sd = StdDev(l,lens);
if sd <> 0 then k = 1 - sd[1]/sd;

klens = klens*(1 + k);
if klens > maxlen then klens = maxlen
else if klens < minlen then klens = minlen;

lok = KeltnerChannel(l,IntPortion(klens),-ks);
{***************************}
{***************************}
if 700 < t and t < 2300 then begin
 
 if marketposition < 1 and c < upk then
  buy("el") next bar at upk stop;
  
 if marketposition > -1 and c > lok then
  sellshort("es") next bar at lok stop;

end;
{***************************}
{***************************}
