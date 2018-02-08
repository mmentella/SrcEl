{
data1= engine2 daily
data2= engine1 240 minuti
}

Vars: EP(0), MP(0), PivPnt(0),
	   Resistance1(0), Support1(0), NumCont(0),ccivalue(0);

Inputs: longLength(40), shortLength(40),
	
		  OverSold( -100 ),
	     OverBought( 100 ),
		  OverSColor( Green ), 
		  OverBColor( Red );

{-----Inizializzazione delle Variabili----}
PivPnt = (H + L + C + O)/4;
Resistance1 = (PivPnt) + avgtruerange(5); 
Support1 = (PivPnt) - avgtruerange(5);
MP = MarketPosition; 
EP = EntryPrice; 
ccivalue = CCI (20);


{-----Engine_1------}
//Short
If C < O and L < L[1] and H < H[1] and C < C[1] and C[1] < C[2] Then
 buy ("PVT-S") Next Bar at Support1 -1 Point Stop;
//Buy
If C > O and H > H[1] and L > L[1] and C > C[1] and C[1] > C[2] Then
 sellshort ("PVT-L") Next Bar  at Resistance1 +1 Point Stop;
	
	
	
{------Engine_2-------}
//buy
Buy ("DON-L") tomorrow at highest (high,longlength) +1 point stop;
//short
Sellshort ("DON-S") tomorrow at highest (high,longlength) -1 point stop;

{------Filtro_1 per EG2------}
If (marketposition = 1 and barsSinceEntry(0) >= 5 and C < entryPrice) then
Sell ("LongLoss5Days") this bar close;

If (marketposition = -1 and barsSinceEntry(0) >=5 and C > entryprice) then
Buytocover ("ShortLoss5Days") this bar close;
 





{-----Engine_3-------}
//buy
 if  (ccivalue > -100) Then buy ("CCI-L") Next Bar at Support1 -1 Point Stop;
//sell 
 if  (ccivalue > -100) Then sellshort ("CCI-S") Next Bar  at Resistance1 +1 Point Stop;
