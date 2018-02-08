inputs: TimeLen(5), Slowing(3);

vars: kfast(0,data2),dslow(0,data2);

if barstatus(2) = 2 then begin 
Pippo.Stoch(TimeLen,Slowing,kfast,dslow)data2;

Plot1( kfast, "%K" ) ;
Plot2( dslow, "%D") ;
Plot3( 20, "OverSld" ) ;
Plot4( 80, "OverBot" ) ;

end;
