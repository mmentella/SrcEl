inputs: tal(0.330),sal(0.034),kal(0.001);
inputs: tas(0.023),sas(0.043),kas(0.251);

var: trndl(0,data1),trgrl(0,data1),skewl(0,data1),kurtl(0,data1);
var: trnds(0,data1),trgrs(0,data1),skews(0,data1),kurts(0,data1);

MM.ITrend(medianprice,tal,trndl,trgrl)data1;
skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal)data1,sal)data1;
kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal)data1,kal)data1;

MM.ITrend(medianprice,tas,trnds,trgrs);
skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas)data1,sas)data1;
kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas)data1,kas)data1;


if marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;
 
if marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;

if marketposition > -1 and trgrs < trnds and skews < 0 and kurts < 0 then
 sell short("xles") next bar o;
 
if marketposition < 1 and trgrl > trndl and skewl > 0 and kurtl < 0 then
 buy("xsel") next bar o;
