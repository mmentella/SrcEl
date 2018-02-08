inputs: Length( 20 ), lengthBB(20), Factor( 2 ), NumDevsUp(2), NumDevsDn(-2),bp(-2),sp(30)  ;

variables: oHammer( 0 ), oHangingMan( 0 ), LowerBand( 0 ), UpperBand( 0 ) ;

Value1 = C_Hammer_HangingMan( Length, Factor, oHammer, oHangingMan ) ;
{Value2 = C_Hammer_HangingMan( Length, Factor, oHammer, oHangingMan ) ;}
LowerBand = BollingerBand( C, LengthBB, NumDevsDn ) ;
UpperBand = BollingerBand( C, LengthBB, NumDevsUp ) ;


if value1 = 1 and oHammer = 1 {and oHangingMan = 0} 
And Low < LowerBand
And C>O
//And c>=O and c[1]<o[1] and c[2]<o[2] and c[3]<o[3] 

then buy ("Gimmy-EL") next bar at h+0.25 stop; 
If (marketposition = 1)  and (barsSinceEntry =4)
{h>h[1] and h>h[2]}
then sell ("-XL") 1 contracts next bar market;  { bar  at L + 0.50 stop;} 

if value1 = 1 and oHammer = 0 or oHangingMan = 1 
And High > {cross over} UpperBand
And C<O
//And c>=O and c[1]<o[1] and c[2]<o[2] and c[3]<o[3] 

then sellshort ("Gimmy-ES") next bar at L-0.25 stop; 
If (marketposition = -1)  and (barsSinceEntry =3)
{L<>[1] and L<L[2]}
then buytocover ("-XS") 1 contracts next bar market;  { bar  at L + 0.50 stop;} 

{Currententries} 
    
   {
else if oHangingMan = 1 then 
   begin
   Plot2( Low, "HangMan" ) ;
   Alert( "HangingMan" ) ;
   end ;
Value1 = C_Hammer_HangingMan(14, 2, oHammer, oHangingMan)
Value2 = BollingerBand(Close,20,-2);
if oHammer = 1  and value2 < value1 then
Buy at market;
 
inputs:
   BollingerPrice( Close ),
   TestPriceUBand( Close ), { cross of this price under UpperBand triggers placement
    of stop order at UpperBand }
   Length( 20 ),
   NumDevsUp( 2 ) ;

variables:
   UpperBand( 0 ) ;

UpperBand = BollingerBand( Close, Length, NumDevsUp ) ;
if CurrentBar > 1 and TestPriceUBand crosses under UpperBand then
{ CB > 1 check used to avoid spurious cross confirmation at CB = 1 }
   Sell Short ( "BBandSE" ) next bar at UpperBand stop ;
   }
