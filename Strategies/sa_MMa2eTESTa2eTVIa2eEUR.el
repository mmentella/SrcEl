input: r(0.5), s(0.5);
input: len(8), exp1(0.5), exp2(0.5);

var: num(0),den(0),tvi(0);

var: up(0),dw(0);

var: min(0),max(0),x(0),fish(0);

var: mp(0);

up = UpTicks;
dw = DownTicks;

num = MM.Smooth(MM.Smooth(up,r),s) - MM.Smooth(MM.Smooth(dw,r),s);
den = MM.Smooth(MM.Smooth(up,r),s) + MM.Smooth(MM.Smooth(dw,r),s);

tvi = num/den;

min = Lowest(tvi,len);
max = Highest(tvi,len);

x = exp1*(2*((tvi- min)/(max - min) - 0.5)) + (1 - exp1)*x[1];

x = minlist(0.999,x);
x = maxlist(-0.999,x);

fish = exp2*(0.2*Log((1 + x)/(1 - x))) + (1 - exp2)*fish[1];
{***************************}
{***************************}
if mp < 1 and tvi > 0.01 and fish > 0.01 then begin
 buy this bar c;
 mp = 1;
end;

if mp > -1 and tvi < 0.01 and fish < 0.01 then begin
 sell short this bar c;
 mp = -1;
end;
