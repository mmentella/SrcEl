input:Nos(2);
vars: notbef(1100),notaft(2100);
var:intrabarpersist f1(.189),intrabarpersist  f2l(0.0797),intrabarpersist   f2s(0.0878), intrabarpersist  f3l(.34),intrabarpersist   f3s(.29),intrabarpersist   reverse(.82),
    intrabarpersist rangemin(.61),intrabarpersist xdiv(10),  intrabarpersist profitto(4300), intrabarpersist  stopp(2200), intrabarpersist  PointL(.06),  intrabarpersist PointSS(.05),
   intrabarpersist  PL(2800), intrabarpersist  PLV(41), intrabarpersist  PS(3000), intrabarpersist  PSV(15);

var:  intrabarpersist ssetup(0), intrabarpersist  bsetup(0),  intrabarpersist senter(0), intrabarpersist  benter(0), intrabarpersist  bbreak(0),  intrabarpersist sbreak(0),
    intrabarpersist ltoday(0), intrabarpersist  hitoday(9999),intrabarpersist   startnow(0),intrabarpersist   div(0),
    intrabarpersist rfilter(false);

setprofittarget(profitto*nos);
setstoploss(stopp*nos);

vars:intrabarpersist  MinimoBarraP(0),intrabarpersist MassimoBarraP(0);

	 

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
 
if t>=notbef and t<notaft and startnow>=2 and rfilter and
date>entrydate(1)  then begin
//messagelog(NumToStr(d,0)+" "+NumToStr(t,0)+" "+NumToStr(senter+(hitoday-ssetup)/div ,2));
  if hitoday>=ssetup and marketposition>-1  then Sell Short("SE") Next Bar  nos shares senter+(hitoday-ssetup)/div stop;
  if ltoday<=bsetup and marketposition<1 then Buy("LE") Next Bar  nos shares benter-(bsetup-ltoday)/div stop;

  if marketposition=-1 then Buy("PLE") Next Bar nos shares entryprice+reverse stop;
  if marketposition=1 then Sell Short("NSE") Next Bar nos shares entryprice-reverse stop;

  if marketposition=0 then Buy("Break LE") Next Bar nos shares bbreak stop;
  if marketposition=0 then Sell Short("Break SE") Next Bar nos shares sbreak stop;

{if marketposition>0 and barssinceentry>1 then
	begin
		setpercenttrailing(PL*nos,PLV);
		end;
 
if marketposition<0 and barssinceentry>1 then
	begin
		setpercenttrailing(PS*nos,PSV);
		end;
}
 

Inputs: ATRsl(28);
Variables:  PosHighl(0),   ATRVall(0);

if barstatus(1)=2 then
begin
	ATRVall = AvgTrueRange(10) * ATRsl;
end;

If BarsSinceEntry = 0 Then
	PosHighl = High;

If MarketPosition = 1   Then Begin
	If High > PosHighl and barstatus(1)=2 Then PosHighl = High;
	if barssinceentry>1 then Sell ("ATRl") nos shares Next Bar at PosHighl - ATRVall Stop;
End
else
	if barssinceentry>1 then Sell ("ATR ebl") nos shares Next bar at High - ATRVall Stop;



Inputs: ATRss(19);
Variables:   PosLows(0),   ATRVals(0);

if barstatus(1)=2 then
begin
	ATRVals = AvgTrueRange(10) * ATRss;
end;
If BarsSinceEntry = 0 Then
	PosLows = Low;

If MarketPosition = -1   Then Begin
	If Low < PosLows and barstatus(1)=2 Then PosLows = Low;
	if barssinceentry>1 then Buy to Cover ("ATR") nos shares Next Bar at PosLows + ATRVals Stop;
End
else
	if barssinceentry>1 then Buy to Cover ("ATR eb") nos shares Next bar at Low + ATRVals Stop;




Inputs: ATRsb(12), ATRLengthb(13);
Variable:   ATRValb(0),   PosHLb(0);

if barstatus(1)=2 then
begin
	ATRValb = AvgTrueRange(ATRLengthb) * ATRsb;
end;

If BarsSinceEntry = 0 Then
	PosHLb = Close;

If MarketPosition = 1  Then Begin
	If Close > PosHLb and barstatus(1)=2 then PosHLb = Close;
	If PosHLb > EntryPrice + ATRValb Then
	if barssinceentry>1 then 	Sell ("1L") nos shares Next Bar at EntryPrice Stop;
End;

If MarketPosition = -1   Then Begin
	If Close < PosHLb and barstatus(1)=2 then PosHLb = Close;	
	If PosHLb < EntryPrice - ATRValb Then
	if barssinceentry>1 then	Buy to Cover ("1S") nos shares Next Bar at EntryPrice Stop;
End;


Inputs: VolatilityATRsv(11), ATRLengthv(19);
Variable:   ATRValv(0);

if barstatus(1)=2 then
begin
	ATRValv = AvgTrueRange(ATRLengthv) * VolatilityATRsv;
end;

If MarketPosition = 1   Then
	if barssinceentry>1 then Sell nos shares Next Bar at EntryPrice - ATRValv Stop;

If MarketPosition = -1   Then
	if barssinceentry>1 then Buy to Cover nos shares Next Bar at EntryPrice + ATRValv Stop;






end;

if barstatus(1)=2 then
begin
	MinimoBarraP =L;
	MassimoBarraP = H; 
end;

if t>=notaft and t<>sess1endtime   then begin

  if marketposition=-1 and barssinceentry>1   then
    Buy to Cover("RbUP SX") Next Bar  nos shares entryprice+reverse stop;
  if marketposition=1 and barssinceentry>1     then
    Sell("RbDN LX") Next Bar  nos shares entryprice-reverse stop;

  if barssinceentry>1 then  Buy to Cover("Late SX") Next Bar  nos shares {h}MassimoBarraP+PointL stop;
  if barssinceentry>1 then  Sell("Late LX") Next Bar   nos shares {l}MinimoBarraP-PointSS stop;
END;


