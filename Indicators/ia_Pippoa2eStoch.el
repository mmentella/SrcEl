inputs: TimeLen(5), Slowing(3);

vars: kfast(0),dslow(0);

Pippo.Stoch(TimeLen,Slowing,kfast,dslow);

Plot1( kfast, "%K" ) ;
Plot2( dslow, "%D") ;
Plot3( 20, "OverBot" ) ;
Plot4( 80, "OverSld" ) ;
