var: trend(0),trigger(0),vol(0),stdv(0),ret(0),rettrgr(0),rettrnd(0);

MM.ITrend(MedianPrice,0.07,trend,trigger);

vol  = Range;
stdv = StdDev(Range,10);

ret = c/c[1] - 1;
MM.ITrend(ret,0.07,rettrnd,rettrgr);
{
if marketposition = 1 then
 sell("xl") this bar c;

if marketposition = -1 then
 buy to cover("xs") this bar c;
}
if {marketposition = 0 and t < sessionendtime(0,1) and
   Range > (3*MinMove point) and} stdv > (MinMove point) then begin
 
 if trigger > trend and rettrgr > rettrnd and c < trend then
 begin
  buy this bar c;
  //sell("xl.tp") next bar c + 2*MinMove points limit;
 end;
 
 if trigger < trend and rettrgr < rettrnd and c > trend then
 begin
  sell short this bar c;
  //buy to cover("xs.tp") next bar c - 2*MinMove points limit;
 end;
 
end;
