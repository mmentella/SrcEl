input: lenl(42), exp1l(1.00), exp2l(0.35);
input: lens(37), exp1s(0.10), exp2s(0.40);

var: minl(0,data2),maxl(0,data2),xl(0,data2),fishl(0,data2),trigl(0,data2);
var: mins(0,data2),maxs(0,data2),xs(0,data2),fishs(0,data2),trigs(0,data2);

var: trade(0);
{***************************}
{***************************}{
if d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;}
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 minl = Lowest(h,lenl)data2;
 maxl = Highest(h,lenl)data2;
 
 xl = exp1l*(2*((h data2 - minl)/(maxl - minl) - 0.5)) + (1 - exp1l)*xl[1];

 xl = minlist(0.999,xl)data2;
 xl = maxlist(-0.999,xl)data2;
 
 fishl = exp2l*(0.2*Log((1 + xl)/(1 - xl))) + (1 - exp2l)*fishl[1];
 trigl = fishl[1];
 
 mins = Lowest(l,lenl)data2;
 maxs = Highest(l,lenl)data2;
 
 xs = exp1l*(2*((l data2 - mins)/(maxs - mins) - 0.5)) + (1 - exp1s)*xs[1];

 xs = minlist(0.999,xs)data2;
 xs = maxlist(-0.999,xs)data2;
 
 fishs = exp2s*(0.2*Log((1 + xs)/(1 - xs))) + (1 - exp2s)*fishs[1];
 trigs = fishs[1];
end;
{***************************}
{***************************}
if trade < 10 then begin
 
 if marketposition < 1 and fishl > trigl then
  buy next bar o;
 
 if marketposition > -1 and fishs < trigs then
  sell short next bar o;
 
end;
{***************************}
{***************************}
