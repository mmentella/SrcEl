inputs: tal(0.450),sal(0.225),kal(0.225);
inputs: tas(0.450),sas(0.220),kas(0.017);

var: trndl(0),trgrl(0),skewl(0),kurtl(0);
var: trnds(0),trgrs(0),skews(0),kurts(0);

MM.ITrend(medianprice,tal,trndl,trgrl);
skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);
kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal);

MM.ITrend(medianprice,tas,trnds,trgrs);
skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);
kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas);

if marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;

if marketposition = 1 and trgrs < trnds and skews < 0 and kurts < 0 then
 sell short("xles") next bar o;

if marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl < 0 then
 buy("xsel") next bar o;
