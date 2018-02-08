inputs: Price( Close ),
	    MAShort( 9 ), MALong(30),
	    _rsia(14),RSIdown(30),RSIup(50),  
	    S_L(8),S_S(6);
Inputs: StopLossLong(3750), StopLossShort(3750);
Inputs: StopLimitPerc(5);

variables: AvgS( 0 ), AvgL( 0 ), Price2(0);  

{ Money Management Constants }
Variables: tickUnit(MinMove / PriceScale),
           stopLong(Floor((StopLossLong / BigPointValue) / (MinMove / PriceScale)) * (MinMove / PriceScale)),
           stopShort(Ceiling((StopLossShort / BigPointValue) / (MinMove / PriceScale)) * (MinMove / PriceScale));

{------Variabiles Value----}
Price2 = OptimalTracking;
AvgS = AverageFC( MPrice, MAShort ) ;
AvgL = AverageFC( MPrice, MALong ) ;

{-----Time Filter----}
If (Marketposition = 1) and (Barssinceentry=S_L)
Then sell  ("SL8") next bar at market; 
If (Marketposition = -1) and (Barssinceentry=S_S)
Then buytocover  ("SS6") next bar at market ;

{----Engine_1----}
if rsi(Price2,_rsia)< RSIdown and (AvgS cross over AvgL) then
 buy ( "RSI-LX" )next bar at market;
if rsi(Price2,_rsia)<RSIup and(AvgS cross under AvgL) then
 Sellshort  ( "RSI-SX" ) next bar at market; 

 {----Engine_2----}
 if (CCI(24) cross over 0) then
  buy ( "CCI-LX" )next bar at market;
if (CCI(14) cross under 0) then
 Sellshort  ( "CCI-SX" ) next bar at market;   
 
  

