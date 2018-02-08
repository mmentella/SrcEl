Inputs: NoS(2),MinLen(5),MaxLen(30),VolLen(30),VLen(20),SOD(800),EOD(2200);

Vars: vadx(0),bull(false),bear(false),len(0),k(0),hh(0),ll(0),VAR0(0),VAR1(0),VAR2(0),VAR3(0);

vadx = VIDYADX(Close,vlen);
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

 print(File("C:\Portafoglio\Sviluppo\Output\JENAVIVE60.txt"),NumToStr(date,0),",",NumToStr(time,0),",",NumToStr(vadx,7),
 ",HH,",NumToStr(hh,0),",LL,",NumToStr(ll,0),",",bull,",",bear);
 
end;
