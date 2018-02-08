Inputs: nos(1);

vars: mom(0),smom(0),dc(0);

dc     = MM.BurgPeriod(medianprice,6,.4);
mom    = medianprice - medianprice[IntPortion(dc+.5)];

MM.ITrend(mom,.07,smom,value1);

if smom > 0 then buy nos shares next bar market;
if smom < 0 then sellshort nos shares next bar market;
