inputs: tal(0.1),sal(0.04);
inputs: tas(0.43),sas(0.5);

var: trndl(0),trgrl(0),skewl(0);
var: trnds(0),trgrs(0),skews(0);

MM.ITrend(medianprice,tal,trndl,trgrl);
skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);

MM.ITrend(medianprice,tas,trnds,trgrs);
skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);
 
if marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;
