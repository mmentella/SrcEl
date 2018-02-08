inputs: 
	Price( Close ), 
	Length( 14 ), 
	HiAlert( 0 ),                        
	LoAlert( 0 ),                         
	UpColor( Cyan ), 
	DnColor( Red ) ;

variables:
	var0( 0 ) ;

var0 = 100 * PercentChange( Price, Length ) ;

Plot1( var0, "%Chg" ) ;
Plot2( HiAlert, "HiAlert" ) ;
Plot3( LoAlert, "LoAlert" ) ;

                  
if var0 > HiAlert then 
	SetPlotColor( 1, UpColor ) 
else if var0 < LoAlert then 
	SetPlotColor( 1, DnColor ) ;

         
condition1 = var0 crosses over HiAlert ;         
if condition1 then
	Alert( "Bullish alert" )
else 
begin 
condition1 = var0 crosses under LoAlert ;
if condition1 then
	Alert( "Bearish alert" ) ;
end;
