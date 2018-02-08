vars: start(0),now(0),gprofit(0),gloss(0),cleq(0);

now = i_OpenEquity;

if now - start > 0 then gprofit = gprofit + now - start
else gloss = gloss + start - now;

start = now;

if gloss <> 0 then plot1(gprofit/gloss,"Win/Loss RATIO");
