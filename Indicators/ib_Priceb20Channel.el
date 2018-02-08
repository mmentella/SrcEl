inputs:  Length( 20 ), Displace( 0 ) ;
variables:  var0( 0 ), var1( 0 ) ;

var0 = Lowest( Low, Length )[1] ;
var1 = Highest( High, Length )[1] ;

condition1 = Displace >= 0 or CurrentBar > AbsValue( Displace ) ;
if condition1 then 
	begin
	Plot1[Displace]( var1, "UpperBand" ) ;
	Plot2[Displace]( var0, "LowerBand" ) ;

	                  
	if Displace <= 0 then
		begin
		condition1 = Low crosses under var0 ;
		if condition1 then
			Alert( "Price making new low" ) ;
		condition1 = High crosses over var1 ;
		if condition1 then
			Alert( "Price making new high" ) ;
		end ;
	end ;
