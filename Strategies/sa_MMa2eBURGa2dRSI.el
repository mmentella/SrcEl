Inputs: CycPart(.4);

vars: dc(0);

dc = MM.BurgPeriod(medianprice,6,40);

value1 = rsi(medianprice,cycpart*dc);

if value1 > 70 then sellshort this bar c;
if value1 < 30 then buy this bar c;
