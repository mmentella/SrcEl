Inputs: nos(2),alphal(.07),flenl(8),rngpctl(.15),alphas(.07),flens(8),rngpcts(.15);

vars: trendl(0),trigl(0),cycl(0),fishl(0),trends(0),trigs(0),cycs(0),fishs(0);

MM.ITrend(medianprice,alphal,trendl,trigl);
cycl  = MM.Cycle(medianprice,alphal);
fishl = MM.FisherTransform(cycl,flenl,true);

MM.ITrend(medianprice,alphal,trends,trigs);
cycs  = MM.Cycle(medianprice,alphas);
fishs = MM.FisherTransform(cycs,flens,true);

if marketposition < 1 and fishl > fishl[1] and trigl > trendl then
 buy nos shares next bar at c - rngpctl*range limit;

if marketposition > -1 and fishs < fishs[1] and trigs < trends then
 sellshort nos shares next bar at c + rngpcts*range limit;
