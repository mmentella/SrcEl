//data1 nq, data 2 es
//Strategy:  Gardner_RelStr;

Inputs:
	ReferenceAvgLen( 20 ),
	TargetAvgLen( 10 ) ;
variables:
	Reference_SMA( 0, data2 ),
	Reference_Diff( 0, data2 ),
	Reference_Vol( 0, data2 ),
	Target_SMA( 0 ),
	Target_Diff( 0 ),
	Target_Vol( 0 ) ;

Reference_SMA= Average(Close data2, ReferenceAvgLen) data2 ;
Reference_Diff =  close data2 - Reference_SMA ;
Reference_Vol = Reference_Diff/(2 * StandardDev( Reference_SMA,ReferenceAvgLen,2));

if Reference_Vol > 1 and close > Average( close, TargetAvgLen) then
	buy next bar at market ;

if Reference_Vol < -1 and (close - Average(Close,TargetAvgLen))
	/(2*StdDev( Average(Close, TargetAvgLen),TargetAvgLen)) < 1  
then
	sell next bar at market ;

