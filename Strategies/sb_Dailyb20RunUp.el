vars: cmp(0);

cmp = currentcontracts*marketposition;

if cmp <> cmp[1] then
 text_new(d,t,h,NumToStr(exitprice(1),Log(pricescale)/Log(10)));
