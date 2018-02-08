Inputs: NoS(2),MinLen(5),MaxLen(30),VolLen(30),VLen(20),SOD(800),EOD(2200);

Vars: vadx(0),bull(false),bear(false),len(0),k(0),hh(0),ll(0),VAR0(0),VAR1(0),VAR2(0),VAR3(0);

Vars: outOfDate(false);

if currentbar = 1 then len = MinLen;

outOfDate = date > 9991231;

if outOfDate = false then begin

VAR1 = VidyaADXStrength(Close,vlen,vadx,VAR2,VAR3);
bull = vadx > vadx[1];
bear = vadx < vadx[1];

VAR0 = StdDev(Close,VolLen);

k =  iff(var0<>0,1 - VAR0[1]/VAR0,0);

len = len*(1+k);
len = minlist(len,maxlen);
len = maxlist(len,minlen);

hh = highest(high,len);
ll = lowest(low,len);

if time > SOD and time < EOD then begin

 if bull then buy nos shares next bar at hh stop;
 if bear then sellshort nos shares next bar at ll stop;
 
end;

end;
