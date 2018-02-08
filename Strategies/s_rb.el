input:Nos(2);

var: f1(.189), f2l(0.0797),  f2s(0.0878),  f3l(.34),  f3s(.29),  reverse(.82),
    rangemin(.61),xdiv(10);

var:  ssetup(0),  bsetup(0),  senter(0),  benter(0),  bbreak(0),  sbreak(0),
    ltoday(0),  hitoday(9999),  startnow(0),  div(0),
    rfilter(false);

vars: MinimoBarraP(0),MassimoBarraP(0);

	 

if currentbar=1 then startnow=0;
div=maxlist(xdiv,1);
if d>d[1]and barstatus(1)=2 then begin
  //messagelog(NumToStr(d,0));
  startnow=startnow+1;

  ssetup=hitoday[1]+f1*(c[1]-ltoday[1]);
  senter=((1+f2l)/2)*(hitoday[1]+c[1])-(f2l)*ltoday[1];
  benter=((1+f2s)/2)*(ltoday[1]+c[1])-(f2s)*hitoday[1];
  bsetup=ltoday[1]-f1*(hitoday[1]-c[1]);
  bbreak=ssetup+f3l*(ssetup-bsetup);
  sbreak=bsetup-f3s*(ssetup-bsetup);

  hitoday=h;
  ltoday=l;

  rfilter=hitoday[1]-ltoday[1]>=rangemin;

end;
if d=d[1] and barstatus(1)=2 then
begin
	if h>hitoday and barstatus(1)=2 then hitoday=h;
	if l<ltoday and barstatus(1)=2 then ltoday=l;
end;
 
if startnow>=2 and rfilter and
date>entrydate(1)  then begin
//messagelog(NumToStr(d,0)+" "+NumToStr(t,0)+" "+NumToStr(senter+(hitoday-ssetup)/div ,2));
  if hitoday>=ssetup and marketposition>-1  then Sell Short("SE") Next Bar  nos shares senter+(hitoday-ssetup)/div stop;
  if ltoday<=bsetup and marketposition<1 then Buy("LE") Next Bar  nos shares benter-(bsetup-ltoday)/div stop;

  if marketposition=-1 then Buy("PLE") Next Bar nos shares entryprice+reverse stop;
  if marketposition=1 then Sell Short("NSE") Next Bar nos shares entryprice-reverse stop;

  if marketposition=0 then Buy("Break LE") Next Bar nos shares bbreak stop;
  if marketposition=0 then Sell Short("Break SE") Next Bar nos shares sbreak stop;
end;
