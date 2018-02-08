Inputs: NoS(2),MinLen(5),MaxLen(30),VolLen(30),VLen(20);

Vars: vadx(0,data2),bull(false),bear(false),len(0),k(0),hh(0,data2),ll(0,data2),VAR0(0,data2),trade(true);

vadx = vidyadx(c,vlen) data2;
bull = vadx > vadx[1] and vadx > vadx[2];
bear = vadx < vadx[1] and vadx < vadx[2];

VAR0 = StdDev(Close,VolLen) data2;

k =  iff(var0<>0,1 - VAR0[1]/VAR0,0);

len = len*(1+k);
len = minlist(len,maxlen);
len = maxlist(len,minlen);

hh = highest(high,len) data2;
ll = lowest(low,len) data2;

if marketposition <> 0 then trade = false;

if trade then begin
 if bull then sellshort nos shares next bar at hh stop;
 if bear then buy nos shares next bar at ll stop;
end;

if marketposition <> 0 then begin
 setstopshare;
 //setprofittarget(500);
 //setstoploss(250);
end;

if barstatus(2) = 2 then begin
 if marketposition = 1 then
  sell this bar on close;
 if marketposition = -1 then
  buytocover this bar on close;
 trade = true;
end;
