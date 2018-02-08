Inputs: alpha(.43),cutoff(2),rngpctl(.075),rngpcts(.1);

vars: cycle(0),q1(0),i1(0),deltaphase(0),mediandelta(0),dc(0),instperiod(0),period(0),num(0),denom(0);
vars: a1(0),b1(0),c1(0),coef1(0),coef2(0),coef3(0),coef4(0),filt3(0);

cycle = MM.Cycle(medianprice,alpha);

q1    = (.0962*cycle + .5769*cycle[2] - .0962*cycle[4] - .5769*cycle[6])*(.5 + .08*instperiod[1]);
i1    = cycle[3];

if q1 <> 0 and q1[1] <> 0 then deltaphase = (i1/q1 - i1[1]/q1[1])/(1 + i1*i1[1]/(q1*q1[1]));

if deltaphase < .1 then deltaphase = .1;
if deltaphase > 1.1 then deltaphase = 1.1;

mediandelta = median(deltaphase,5);

if mediandelta = 0 then dc = 15 else dc = 6.28318/mediandelta + .5;

instperiod = .33*dc + .67*instperiod[1];
period     = .15*instperiod + .85*period[1];

value1 = medianprice - medianprice[IntPortion(period - 1)];

a1 = expvalue(-3.14159/cutoff);
b1 = 2*a1*cosine(1.738*180/cutoff);
c1 = a1*a1;

coef2 = b1 + c1;
coef3 = -(c1 + b1*c1);
coef4 = c1*c1;
coef1 = 1 - coef2 - coef3 - coef4;

filt3 = coef1*value1 + coef2*filt3[1] + coef3*filt3[2] + coef4*filt3[3];

if currentbar < 4 then filt3 = value1;

if filt3 crosses over 0 then buy next bar c - rngpctl*range limit;
if filt3 crosses under 0 then sellshort next bar c + rngpcts*range limit;
