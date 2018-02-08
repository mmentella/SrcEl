input: tal(0.87),sal(0.59);
input: tas(0.04),sas(0.72);

var: trndl(0),trgrl(0),skewl(0);
var: trnds(0),trgrs(0),skews(0);

var: trade(0);

if d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;

MM.ITrend(medianprice,tal,trndl,trgrl);
skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);
 
MM.ITrend(medianprice,tas,trnds,trgrs);
skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);

if trade = 0 then begin

if marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;

end;
