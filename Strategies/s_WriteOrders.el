vars: buyPrice(0),sellPrice(0);

buyPrice  = BollingerBand(h,20,2);
sellPrice = BollingerBand(l,20,-2);

if marketposition < 1 then
 WriteOrders("el",buyPrice,"stop");

if marketposition > -1 then
 WriteOrders("es",sellPrice,"stop");
