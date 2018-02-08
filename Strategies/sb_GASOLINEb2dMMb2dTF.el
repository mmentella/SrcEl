Inputs: nos(2),alphal(0.07),rngpctl(0.2843),alphas(0.0354),rngpcts(.2085);

vars: trendl(0),triggerl(0),cyclel(0),trends(0),triggers(0),cycles(0);

MM.ITrend(medianprice,alphal,trendl,triggerl);
cyclel = MM.Cycle(medianprice,alphal);

MM.ITrend(medianprice,alphas,trends,triggers);
cycles = MM.Cycle(medianprice,alphas);

if marketposition < 1 and cyclel > cyclel[1] and triggerl > trendl then
 buy nos shares next bar at c - rngpctl*range limit; 

if marketposition > -1 and cycles < cycles[1] and triggers < trends then
 sellshort nos shares next bar at c + rngpcts*range limit;
