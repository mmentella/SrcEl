Inputs: alpha(0.07);

vars: trend(0),trigger(0),cycle(0),dev(0),smd(0),dmd(0),md(0);

MM.ITrend(medianprice,alpha,trend,trigger);
cycle = MM.Cycle(medianprice,alpha);

dev = cycle;
smd = alpha*(dev) + (1 - alpha)*smd[1];
dmd = alpha*smd + (1 - alpha)*dmd[1];
md  = ((2 - alpha)*smd - dmd)/(1 - alpha);

plot1(dev,"Mean Deviation");
