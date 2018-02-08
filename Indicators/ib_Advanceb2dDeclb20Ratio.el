inputs:
	AdvIssues( Close of data1 ),
	DecIssues( Close of data2 ) ;

variables:
	var0( 0 ) ;

var0 = AdvanceDeclineRatio( AdvIssues, DecIssues ) ;

Plot1( var0, "A/DRatio" ) ;
Plot2( 1, "Baseline" ) ;
