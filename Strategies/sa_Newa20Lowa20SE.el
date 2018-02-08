[IntrabarOrderGeneration = false]
inputs: PeriodType( 1 ) ;
                                                                       

variables: var0( BarType ), var1( false ), var2( -1000000 ) ;

condition1 =  ( PeriodType = 2 and var0 <= 2 and Date <> Date next bar )
    or ( PeriodType = 3 and var0 <= 3 and DayOfWeek( Date) > DayOfWeek( Date next
	 bar ) )
    or ( PeriodType = 4 and var0 <= 4 and Month( Date ) <> Month( Date next bar ) )
    or ( PeriodType = 5 and var0 <= 4 and Year( Date ) <> Year( Date next bar ) );              

if     condition1
then
	var1 = true 
else
	var1 = false ;

condition1 = ( CurrentBar = 1 and ( PeriodType <= 1 or PeriodType > 5 ) ) 
	or var1[1] 
	or Low < var2 ;

if condition1
then
	var2 = Low ;

if var1 = false then
	Sell Short( "NewLo" ) next at bar at var2 - 1 point stop ;
