inputs: 
	Criteria( Close > High[1] ), 
	Length( 14 ), 
	Occur( 7 ), 
	ShowText( true ), 
	TextColor( Cyan ) ;

variables: 
	var0( 0 ), 
	var1( 0 ) ;

if Criteria then
	begin
	var0 = CountIf( Criteria, Length ) ;
	if var0 >= Occur then 
		begin
		Plot1( High, "CntCrtSM" ) ;
		Alert ;
		if ShowText then 
			begin
			var1 = Text_New( Date, Time, High, NumToStr( var0, 0 ) ) ;
			Text_SetStyle( var1, 2, 1 ) ;
			Text_SetColor( var1, TextColor ) ;
			end ;
		end ;
	end
else
	NoPlot( 1 ) ;
