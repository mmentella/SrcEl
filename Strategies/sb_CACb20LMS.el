Inputs: NoS(2),Length(10),Prediction(4),alpha(.25),StepL(3),StepS(1),SOD(900),EOD(1700),ADXLen(13),ADXLimit(38);

Inputs: AvgLength(10),StdDevLen(5),MaxLen(30),MinLen(5),MaxPre(10),MinPre(2);

Inputs: SLoss(2000),PTarget(2250);

Inputs: ATRl(2),ATRs(5), ATRLength(30);
Variable: ATRVal(0), PosHL(0);

Vars: SDP(0),len(0),pre(0),SDPA(0),LSSigL(0),LSSigH(0);

if currentbar = 0 then begin len = length; pre = Prediction; end;

if Time>SOD and Time<EOD then begin
	
{********INITIALIZATION*********}

SDP = StdDev(High,StdDevLen);
SDPA = Average(SDP,AvgLength);

len = len*(1+((sdpa-sdpa[1])/sdpa));
len = floor(len);
len = MinList(len,MaxLen);
len = MaxList(len,MinLen);

pre = pre*(1+((sdpa-sdpa[1])/sdpa));
pre = floor(pre);
pre = MinList(pre,MaxPre);
pre = MaxList(pre,MinPre);

LSSigH = LMS(High,len,pre,alpha);

SDP = StdDev(Low,StdDevLen);
SDPA = Average(SDP,AvgLength);

len = len*(1+((sdpa-sdpa[1])/sdpa));
len = floor(len);
len = MinList(len,MaxLen);
len = MaxList(len,MinLen);

pre = pre*(1+((sdpa-sdpa[1])/sdpa));
pre = floor(pre);
pre = MinList(pre,MaxPre);
pre = MaxList(pre,MinPre);

LSSigL = LMS(Low,len,pre,alpha);

{********Entry SetUp**********}
{
SetStopLoss(SLoss*NoS);
SetProfitTarget(PTarget*NoS);
}
if C > LSSigH and C[1] > LSSigH and LSSigH > LSSigH[1] + StepL and 
	LSSigL > LSSigL[1] + StepL and ADX(ADXLen)<ADXLimit then begin
		
	buy("EL") NoS shares next bar at LSSigH stop;
	//sell("LSL") NoS shares next bar at LSSigL stop;	

end;

if C < LSSigL and C[1] < LSSigL and LSSigL < LSSigL[1] - StepS and 
	LSSigH < LSSigH[1] - StepS and ADX(ADXLen)<ADXLimit then begin	
		
	sellshort("ES") NoS shares next bar at LSSigL stop;
	//buytocover("SSL") NoS shares next bar at LSSigH stop; 
   
end;
{
{********Exit SetUp**********}

if ADX(ADXLen) > ADXLimit then begin
if marketposition = 1 then begin
	if C < LSSigL and C[1] < LSSigL then
		sell("XL") NoS shares next bar at market;
end;
if marketposition = -1 then begin
	if C > LSSigH and C[1] > LSSigH then
		buytocover("XS") NoS shares next bar at market;	
end;
end;

ATRVal = AvgTrueRange(ATRLength) * ATRl;

If BarsSinceEntry = 0 Then
	PosHL = Close;

If MarketPosition = 1 Then Begin
	If Close > PosHL Then
		PosHL = Close;
	If PosHL > EntryPrice + ATRVal Then
		sell ("1L") Next Bar at EntryPrice Stop;
End;

ATRVal = AvgTrueRange(ATRLength) * ATRs;

If MarketPosition = -1 Then Begin
	If Close < PosHL Then
		PosHL = Close;	
	If PosHL < EntryPrice - ATRVal Then
		buytocover ("1S") Next Bar at EntryPrice Stop;
End;

	
}
end;
