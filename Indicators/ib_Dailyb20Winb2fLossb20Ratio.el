vars: gp(0),gl(0),start(i_OpenEquity),now(0),gprofit(0),gloss(0),cleq(0);

if d <> d [1] then begin
 if now - start < 0 then gl = gl + absvalue(now - start)
 else gp = gp + now - start;
 
 start = now;
end;

now = i_OpenEquity;
cleq = i_ClosedEquity;

if cleq < cleq[1] then gloss = gloss + cleq[1] - cleq;
if cleq > cleq[1] then gprofit = gprofit + cleq - cleq[1]; 

if gl > 0 then plot1(Round(gp/gl,2),"D PF");
if gloss <> 0 then plot2(Round(gprofit/gloss,2),"PF");
