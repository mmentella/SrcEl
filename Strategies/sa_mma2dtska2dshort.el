input: ta(0.07), sa(0.07), ka(0.07), startTime(700), endTime(2200);

var: trnd(0), trgr(0), skew(0), kurt(0);
var: goToMarket(false);

MM.ITrend(medianprice,ta,trnd,trgr);
skew = MM.Smoother(medianprice - MM.Smoother(medianprice,sa),sa);
kurt = MM.Smoother(medianprice - MM.Smoother(medianprice,ka),ka);

goToMarket = marketposition = 0 and
             startTime < time        and 
             time < endTime;

if goToMarket    and 
   trgr < trnd   and 
   skew > 0          
then sell short("es") next bar open
else if goToMarket    and 
        trgr < trnd and 
        skew < 0     and 
        kurt < 0 
then sell short("xles") next bar open
else if marketposition = -1 and 
        barssinceentry > 0 
then buy to cover("xs") this bar close;

