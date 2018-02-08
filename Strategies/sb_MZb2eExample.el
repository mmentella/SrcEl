Inputs: alphal(.07),lenl(8),rngpctl(.1),alphas(.07),lens(8),rngpcts(.1);

vars: trendl(0),trigl(0),cycl(0),fishl(0),trends(0),trigs(0),cycs(0),fishs(0);

MM.ITrend(medianprice,alphal,trendl,trigl);


MM.ITrend(medianprice,alphas,trends,trigs);

if marketposition < 1 then begin
 
 if trigl > trendl then
  buy next bar at c - rngpctl*range limit;
  
end;
 
if marketposition > -1 then begin
 
 if trigs < trends then
  sellshort next bar at c + rngpcts*range limit;
  
end; 
