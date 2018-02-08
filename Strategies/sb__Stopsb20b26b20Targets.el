[IntrabarOrderGeneration = false]
inputs:
	ShareOrPosition( 1 ),                                                        
	ProfitTargetAmt( 5 ),                                                
	StopLossAmt( 1 ),                                            
	BreakevenFloorAmt( 0 ),                                                 
	DollarTrailingAmt( 0 ),                                                       
	PctTrailingFloorAmt( 0 ),                                                         
	                          
	PctTrailingPct( 0 ),                                                             
	                                                          
	ExitOnClose( false ) ;                                                        
	                                                                                  
	                                                                               
	                                                                                 
	                                         

if ShareOrPosition = 1 then 
	SetStopShare
else
	SetStopPosition ;

if ProfitTargetAmt > 0 then
	SetProfitTarget( ProfitTargetAmt ) ;
if StopLossAmt > 0 then
	SetStopLoss( StopLossAmt ) ;
if BreakevenFloorAmt > 0 then
	SetBreakeven( BreakevenFloorAmt ) ;
if DollarTrailingAmt > 0 then
	SetDollarTrailing( DollarTrailingAmt ) ;
condition1 = PctTrailingFloorAmt > 0 and PctTrailingPct > 0 ;
if condition1 then 
	SetPercentTrailing( PctTrailingFloorAmt, PctTrailingPct ) ;
if ExitOnClose = true then 
	SetExitOnClose ;
