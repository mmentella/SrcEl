inputs: tal(0.050),sal(0.950),kal(0.050);
inputs: tas(0.850),sas(0.250),kas(0.150);

var: trndl(0,data2),trgrl(0,data2),skewl(0,data2),kurtl(0,data2);
var: trnds(0,data2),trgrs(0,data2),skews(0,data2),kurts(0,data2);

var: trade(0);

if t = sessionendtime(0,1) or d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;

if barstatus(2) = 2 then begin

 MM.ITrend(medianprice,tal,trndl,trgrl)data2;
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal)data2;
 kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal)data2;
 
 MM.ITrend(medianprice,tas,trnds,trgrs)data2;
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas)data2;
 kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas)data2;

end;

if trade < 100 then begin

if marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;

if marketposition = 1 and trgrs < trnds and skews < 0 and kurts > 0 then
 sell short("xles") next bar o;

if marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl < 0 then
 buy("xsel") next bar o;

end;
