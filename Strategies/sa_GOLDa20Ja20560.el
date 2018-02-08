[IntraBarOrderGeneration = true];
Inputs: NoS(2),VolLen(30),VLen(20),MinLen(5),MaxLen(30);

Vars: vadx(0),bull(false),bear(false),hh(0),ll(0),VAR0(0),k(0),len(minlen),work(false);

work = time > 800 and time < 2200;

vadx = VIDYADX(c,vlen) data2;
bull = vadx > vadx[1];
bear = vadx < vadx[1];

VAR0 = StdDev(c,vollen) data2;

k = 1 - VAR0[1]/VAR0;

len = len*(1 + k);
len = minlist(len,maxlen);
len = maxlist(len,minlen);
len = floor(len);

hh = Highest(high,len) data2;
ll = Lowest(low,len) data2;

if work then begin
 if bull then buy nos shares next bar at hh stop;
 if bear then sellshort nos shares next bar at ll stop;
end;
