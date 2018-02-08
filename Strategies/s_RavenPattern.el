variables:	Message ( "" ) ,
	PatternName(""),
	header("");
variables:
	H1 ( 0 ) ,
	H2 ( 0 ) ,
	L1 ( 0 ) ,
	L2 ( 0 ) ,
	O1 ( 0 ) ,
	O2 ( 0 ) ,
	C1 ( 0 ) , 
	C2 ( 0 ) ;
variables:
	GapUp ( false ) ,
	GapDn ( false ) ;

// //////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////// //

H1 = high[ 1 ] ;

L1 = low[ 1 ] ;
O1 = open[ 1 ] ;
C1 = close[ 1 ] ;

H2 = high[ 2 ] ;
L2 = low[ 2 ] ;
O2 = open[ 2 ] ;
C2 = close[ 2 ] ;

// //////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////// //
// ///////////////////////////////+//////////////////////////////////////// //

Message = "Pattern(s) = " ;
GapUp = L>H1;
GapDn = H<L1;

// //////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////// //

{candele ad 1 pattern}

 Var: Doji(0); //ok
 PatternName = "doji";
 If Currentbar = 1 then header = PatternName;
if (O=C) then  begin doji = doji + 1; Message = Message + PatternName + "  "; end; 

Var: NearDoji(0); //ok
 PatternName = "NearDoji";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (AbsValue(O-C)<= ((H-L)*0.1)) then begin nearDoji = nearDoji + 1; Message = Message + PatternName + "  "; end;
 
Var: BlackCandle(0); //ok
 PatternName = "BlackCandle"; 
 If Currentbar = 1 then header = header + ";" + PatternName;
if (O>C) then begin blackCandle = blackCandle + 1; Message = Message + PatternName + "  "; end;
 
 Var: LongBlackCandle(0); //ok
 PatternName = "LongBlackCandle"; 
 If Currentbar = 1 then header = header + ";" + PatternName;
if (O>C AND (O-C)/(.001+H-L)>.6) then begin longBlackCandle = longBlackCandle + 1; Message = Message + PatternName + "  "; end;
 
 var: SmallBlackCandle(0); //ok
 PatternName = "SmallBlackCandle";
 If Currentbar = 1 then header = header + ";" + PatternName; 
if ((O>C) AND ((H-L)>(3*(O-C)))) then begin smallBlackCandle = smallBlackCandle + 1; Message = Message + PatternName + "  "; end;
 
 var: WhiteCandle(0); //ok
 PatternName = "WhiteCandle";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C>O) then begin whiteCandle = whiteCandle + 1; Message = Message + PatternName + "  "; end;
 
 var: LongWhiteCandle(0); //ok
 PatternName = "LongWhiteCandle";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C>O) AND((C-O)/(.001+H-L)>.6)) then begin longWhiteCandle = longWhiteCandle + 1; Message = Message + PatternName + "  "; end;
 
 var: SmallWhiteCandle(0); //ok
 PatternName = "SmallWhiteCandle";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C>O) AND ((H-L)>(3*(C-O)))) then begin smallWhiteCandle = smallBlackCandle + 1; Message = Message + PatternName + "  "; end;
 
 var: BlackMaubozu(0); //ok
 PatternName = "BlackMaubozu";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (O>C AND H=O AND C=L) then begin blackMaubozu = blackMaubozu + 1; Message = Message + PatternName + "  ";end;
 
 var: WhiteMaubozu(0); //ok
 PatternName = "WhiteMaubozu";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C>O AND H=C AND O=L) then begin whiteMaubozu = whiteMaubozu + 1; Message = Message + PatternName + "  "; end;
 
 var: BlackClosingMarubozu(0); //ok
 PatternName = "BlackClosingMarubozu";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (O>C AND C=L) then begin blackClosingMarubozu = blackClosingMarubozu + 1; Message = Message + PatternName + "  "; end;
 
 var: WhiteClosingMarubozu(0); //ok
 PatternName = "WhiteClosingMarubozu";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C>O AND C=H) then begin whiteClosingMarubozu = whiteClosingMarubozu + 1; Message = Message + PatternName + "  "; end;
 
 var: BlackOpeningMarubozu(0); //ok
 PatternName = "BlackOpeningMarubozu";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (O>C AND O=H) then begin blackOpeningMarubozu = blackOpeningMarubozu + 1; Message = Message + PatternName + "  "; end;
 
 var: WhiteOpeningMarubozu(0); //ok
 PatternName = "WhiteOpeningMarubozu";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C>O AND O=L) then begin whiteOpeningMarubozu = whiteOpeningMarubozu + 1; Message = Message + PatternName + "  ";  end;
 
 var: HangingMan(0); //ok
 PatternName = "HangingMan";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (((H-L)>4*(O-C)) AND ((C-L)/(.001+H-L)>= 0.75) AND ((O-L)/(.001+H-L)>= 0.75)) then begin hangingMan = hangingMan + 1; Message = Message + PatternName + "  "; end;
 
 var: Hammer(0);
 PatternName = "Hammer";  //ok
 If Currentbar = 1 then header = header + ";" + PatternName;
if (((H-L)>3*(O-C)) AND ((C-L)/(.001+H-L)>0.6) AND ((O-L)/(.001+H-L)>0.6)) then begin hammer = hammer + 1; Message = Message + PatternName + "  ";end;
 
 var: InvertedHammer(0);
 PatternName = "InvertedHammer"; //ok
 If Currentbar = 1 then header = header + ";" + PatternName;
if (((H-L)>3*(O-C))AND ((H-C)/(.001+H-L)>0.6) AND ((H-O)/(.001+H-L)>0.6)) then begin invertedHammer = invertedHammer + 1; Message = Message + PatternName + "  "; end;

 var: ShootingStar(0);  //ok
 PatternName = "ShootingStar";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (((H-L)>4*(O-C)) AND ((H-C)/(.001+H-L)>= 0.75) AND ((H-O)/(.001+H-L)>= 0.75)) then begin shootingStar = shootingStar + 1; Message = Message + PatternName + "  "; end;
 
 var: BlackSpinningTop(0); //ok
 PatternName = "BlackSpinningTop";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((O>C) AND ((H-L)>(3*(O-C))) AND (((H-O)/(.001+H-L))<.4) AND (((C-L)/(.001+H-L))<.4)) then begin blackSpinningTop = blackSpinningTop + 1; Message = Message + PatternName + "  "; end;
 
 var: WhiteSpinningTop(0); //ok
 PatternName = "WhiteSpinningTop";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C>O) AND((H-L)>(3*(C-O))) AND (((H-C)/(.001+H-L))<.4) AND(((O-L)/(.001+H-L))<.4)) then begin whiteSpinningTop = whiteSpinningTop + 1; Message = Message + PatternName + "  "; end;

{candele a 2 pattern}
var: DarkCloudCover(0); //ok
 PatternName = "DarkCloudCover";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C1>O1 AND((C1+O1)/2)>C AND O>C AND O>C1 AND C>O1 AND ( O-C )/( .001+( H-L ))> 0.6 ) then begin darkCloudCover = darkCloudCover + 1;  Message = Message + PatternName + "  "; end; 

 var: DarkCloudCover2(0); //ok
 PatternName = "DarkCloudCover2";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C1>O1*1.01) AND (O>C) AND (O>H1) AND (C>O1) AND (((C1+O1)/2)>C) AND (C>O1) AND Average(C,13)-Average(C[ 1 ],13)[4]>0 then begin DarkCloudCover2 = DarkCloudCover2 + 1; Message = Message + PatternName + "  "; end;

var: BearishEngulfing(0);  //ok
 PatternName = "BearishEngulfing";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C1>O1) AND(O>C) AND (O>= C1) AND (O1>= C) AND ((O-C)>(C1-O1))) then begin BearishEngulfing = BearishEngulfing + 1;  Message = Message + PatternName + "  ";end; 

var: BullishEngulfing(0); //ok
 PatternName = "BullishEngulfing";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((O1>C1) AND(C>O) AND (C>= O1) AND (C1>= O) AND ((C-O)>(O1-C1))) then begin BullishEngulfing = BullishEngulfing + 1; Message = Message + PatternName + "  "; end;
 
var: BullishHarami(0); //ok
 PatternName = "BullishHarami";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((O1>C1) AND (C>O)AND (C<= O1) AND (C1<= O) AND ((C-O)<(O1-C1))) then begin BullishHarami = BullishHarami + 1; Message = Message + PatternName + "  "; end;

 var: PiercingLine(0); //OK
 PatternName = "PiercingLine";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C1<O1) AND(((O1+C1)/2)<C) AND (O<C) AND (O<C1) AND (C<O1) AND((C-O)/(.001+(H-L))>0.6)) then begin PiercingLine = PiercingLine + 1; Message = Message + PatternName + "  "; end;

 var: BearishHarami(0); //ok
 PatternName = "BearishHarami";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C1>O1) AND (O>C)AND (O<= C1) AND (O1<= C) AND ((O-C)<(C1-O1))) then begin BearishHarami = BearishHarami +1; Message = Message + PatternName + "  "; end;

{candele a 3 pattern} 
 var: BearishAbandonedBaby(0); //ok
 PatternName = "BearishAbandonedBaby";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C1 = O1)AND (C2>O2) AND (O>C) AND (L1>H2) AND (L1>H)) then begin BearishAbandonedBaby = BearishAbandonedBaby + 1; Message = Message + PatternName + "  ";end;

 var: BearishEveningDStr(0); //ok
 PatternName = "BearishEveningDStr";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C2>O2)AND ((C2-O2)/(.001+H2-L2)>.6) AND (C2<O1) AND (C1>O1) AND((H1-L1)>(3*(C1-O1))) AND (O>C) AND (O<O1)) then begin BearishEveningDStr = BearishEveningDStr + 1; Message = Message + PatternName + "  "; end;

 var: ThreeOutsideDwPtrn(0); //ok
 PatternName = "ThreeOutsideDwPtrn";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C2>O2)AND (O1>C1) AND (O1>= C2) AND (O2>= C1) AND ((O1-C1)>(C2-O2)) AND (O>C) AND (C<C1)) then begin ThreeOutsideDwPtrn = ThreeOutsideDwPtrn + 1; Message = Message + PatternName + "  "; end;

 var: BullishAbandonedBaby(0); //ok
 PatternName = "BullishAbandonedBaby"; 
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C1 = O1)AND (O2>C2) AND (C>O) AND (L2>H1) AND (L>H1)) then begin BullishAbandonedBaby = BullishAbandonedBaby + 1; Message = Message + PatternName + "  "; end;

 var: BullishMorningDStr(0); 
 PatternName = "BullishMorningDStr"; //ok
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((O2>C2)AND ((O2-C2)/(.001+H2-L2)>.6) AND (C2>O1) AND (O1>C1) AND((H1-L1)>(3*(C1-O1))) AND (C>O) AND (O>O1)) then begin BullishMorningDStr = BullishMorningDStr +1; Message = Message + PatternName + "  "; end;

 Var: ThreeOutsideUpPtrn(0); 
 PatternName = "ThreeOutsideUpPtrn"; //ok
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((O2>C2)AND (C1>O1) AND (C1>= O2) AND (C2>= O1) AND ((C1-O1)>(O2-C2)) AND (C>O) AND(C>C1)) then begin ThreeOutsideUpPtrn = ThreeOutsideUpPtrn + 1; Message = Message + PatternName + "  "; end;
 
 var: ThreeInsideUpPattern(0);  //ok
 PatternName = "ThreeInsideUpPattern";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((O2>C2)AND (C1>O1) AND (C1<= O2) AND (C2<= O1) AND ((C1-O1)<(O2-C2)) AND (C>O) AND(C>C1) AND (O>O1)) then begin ThreeInsideUpPattern = ThreeInsideUpPattern + 1; Message = Message + PatternName + "  ";end; 

 var: ThreeInsideDwPtrn(0); //ok
 PatternName = "ThreeInsideDwPtrn";
 If Currentbar = 1 then header = header + ";" + PatternName;
if ((C2>O2)AND (O1>C1) AND (O1<= C2) AND (O2<= C1) AND ((O1-C1)<(C2-O2)) AND (O>C) AND(C<C1) AND (O<O1)) then begin ThreeInsideDwPtrn = ThreeInsideDwPtrn + 1; Message = Message + PatternName + "  "; end;

 var: ThreeWhiteSoldiers(0); //ok
 PatternName = "ThreeWhiteSoldiers";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (C>O*1.01)AND (C1>O1*1.01) AND (C2>O2*1.01) AND (C>C1) AND (C1>C2) AND (O<C1) AND (O>O1) AND (O1<C2) 
AND (O1>O2) AND (((H-C)/(H-L))<.2) AND (((H1-C1)/(H1-L1))<.2) AND (((H2-C2)/(H2-L2))<.2) then begin ThreeWhiteSoldiers = ThreeWhiteSoldiers +1; Message = Message + PatternName + "  ";end; 

 var: ThreeBlackCrows(0); //ok
 PatternName = "ThreeBlackCrows";
 If Currentbar = 1 then header = header + ";" + PatternName;
if (O>C*1.01) AND (O1>C1*1.01) AND (O2>C2*1.01) AND (C<C1) AND (C1<C2) AND (O>C1) AND (O<O1)
AND (O1>C2) AND (O1<O2) AND (((C-L)/(H-L))<.2) AND (((C1-L1)/(H1-L1))<.2)AND (((C2-L2)/(H2-L2))<.2) then begin ThreeBlackCrows = ThreeBlackCrows +1;  Message = Message + PatternName + "  "; end;


{configurazioni a gap}

 var: gapupPattern(0);
 PatternName = "gapupPattern"; //ok
 If Currentbar = 1 then header = header + ";" + PatternName;
if GapUp then begin gapupPattern = gapupPattern +1;Message = Message + PatternName + "  "; end;
 
 var: GapDown(0); //ok
 PatternName = "GapDown";
 If Currentbar = 1 then header = header + ";" + PatternName;
if GapDn then begin GapDown = GapDown +1;Message = Message + PatternName + "  ";end;
 
 var: BigGapUp(0); //ok
 PatternName = "BigGapUp";
 If Currentbar = 1 then header = header + ";" + PatternName;
if L>1.01*H1 then begin BigGapUP = BigGapUp +1; Message = Message + PatternName + "  "; end;

var: BigGapDown(0); //ok
 PatternName = "BigGapDown";
 If Currentbar = 1 then header = header + ";" + PatternName;
if H<0.99*L1 then begin BigGapDown = BigGapDown +1; Message = Message + PatternName + "  "; end;

var: HugeGapUp(0); //ok
 PatternName = "HugeGapUp"; 
 If Currentbar = 1 then header = header + ";" + PatternName;
if L>1.02*H1 then begin HugeGapUp = HugeGapUp +1; Message = Message + PatternName + "  "; end;

var: HugeGapDown(0); //ok
 PatternName = "HugeGapDown";
 If Currentbar = 1 then header = header + ";" + PatternName;
if H<0.98*L1 then begin HugeGapDown = HugeGapDown +1; Message = Message + PatternName + "  ";end;
 
var: DoubleGapUp(0); //ok
 PatternName = "DoubleGapUp";
 If Currentbar = 1 then header = header + ";" + PatternName;
if GapUp AND GapUp[ 1 ] then begin DoubleGapUp = DoubleGapUp +1; Message = Message + PatternName + "  "; end;

var: DoubleGapDown(0); //ok
 PatternName = "DoubleGapDown";
 If Currentbar = 1 then header = header + ";" + PatternName;
if GapDn AND GapDn[ 1] then begin DoubleGapDown = DoubleGapDown +1; Message = Message + PatternName + "  "; end;


{volume pattern configurazioni basate sui volumi}

if Message <> Message[ 1 ] then
begin
	ALERT( Message ) ;  // Alert window details for live data
	PRINT( ELDateToString( date ), "  ", time, "  ", Message ) ;  // Print log details for all data
end ;

If Currentbar = 1 then Print(File("C:\RavenPattern - " + symbol + ".txt"),header);

var: str("");
If LastBarOnChart then begin
 str = "";
 
{ pattern gap }

 str = str + Numtostr(DoubleGapDown,0) + ";";
 str = str + Numtostr(DoubleGapUp,0) + ";";
 str = str + Numtostr(HugeGapDown,0) + ";";
 str = str + Numtostr(HugeGapUp,0) + ";";
 str = str + Numtostr(BigGapDown,0) + ";";
 str = str + Numtostr(BigGapUp,0) + ";";
 str = str + Numtostr(GapDown,0) + ";";
 str = str + Numtostr(gapupPattern,0) + ";";
 
{candele a 3 pattern} 
 
 str = str + Numtostr(ThreeBlackCrows,0) + ";";
 str = str + Numtostr(ThreeWhiteSoldiers,0) + ";";
 str = str + Numtostr(ThreeInsideDwPtrn,0) + ";";
 str = str + Numtostr(ThreeInsideUpPattern,0) + ";";
 str = str + Numtostr(ThreeOutsideUpPtrn,0) + ";";
 str = str + Numtostr(BullishMorningDStr,0) + ";";
 str = str + Numtostr(BullishAbandonedBaby,0) + ";";
 str = str + Numtostr(ThreeOutsideDwPtrn,0) + ";";
 str = str + Numtostr(BearishEveningDStr,0) + ";";
 str = str + Numtostr(BearishAbandonedBaby,0) + ";";  
 
{candele a 2 pattern}
 
 str = str + Numtostr(DarkCloudCover,0) + ";";
 str = str + Numtostr(DarkCloudCover2,0) + ";";
 str = str + Numtostr(BearishEngulfing,0) + ";";
 str = str + Numtostr(BullishEngulfing,0) + ";";
 str = str + Numtostr(BullishHarami,0) + ";";
 str = str + Numtostr(PiercingLine,0) + ";";
 str = str + Numtostr(BearishHarami,0) + ";";
 str = str + Numtostr(ThreeOutsideDwPtrn,0) + ";";

{candele a 1 pattern}

 str = str + Numtostr(Doji,0) + ";";
 str = str + Numtostr(NearDoji,0) + ";";
 str = str + Numtostr(BlackCandle,0) + ";";
 str = str + Numtostr(LongBlackCandle,0) + ";";
 str = str + Numtostr(SmallBlackCandle,0) + ";";
 str = str + Numtostr(WhiteCandle,0) + ";";
 str = str + Numtostr(LongWhiteCandle,0) + ";";
 str = str + Numtostr(SmallWhiteCandle,0) + ";";
 str = str + Numtostr(BlackMaubozu,0) + ";";
 str = str + Numtostr(WhiteMaubozu,0) + ";";
 str = str + Numtostr(BlackClosingMarubozu,0) + ";";
 str = str + Numtostr(WhiteClosingMarubozu,0) + ";";
 str = str + Numtostr(BlackOpeningMarubozu,0) + ";";
 str = str + Numtostr(WhiteOpeningMarubozu,0) + ";";
 str = str + Numtostr(HangingMan,0) + ";";
 str = str + Numtostr(InvertedHammer,0) + ";";
 str = str + Numtostr(ShootingStar,0) + ";";
 str = str + Numtostr(BlackSpinningTop,0) + ";";
 str = str + Numtostr(WhiteSpinningTop,0) + ";";

 Print(File("C:\RavenPattern - " + symbol + ".txt"),str);
end; 
