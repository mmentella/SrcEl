
Inputs: ComprStart1(0.1), ComprStop1(0.4), ComprStart2(1.5), ComprStop2(0.4), DaysXsector(22);

Vars: WeekShift(0), FileName("");

Vars: nDays(0), SectorCnt(0), DataTrue(False);

Vars: ValueShift(0), VarRand(0);

Array: ValueCompr[1000](0);
Array: DateSector[1000](0);

Variables: dgt(0), dayShift(WeekShift * 7);

Vars: s(""), dt(""), nd(0), lastDate(0);
Vars: nO(0), nH(0), nL(0), nC(0);
Vars: nO1(0), nH1(0), nL1(0), nC1(0);

if CurrentBar <= 1 then begin
	if PriceScale > 1 then begin
		dgt = MinMove / PriceScale;
		if IntPortion(dgt * 10) / 10 = dgt then dgt = 1 else
		if IntPortion(dgt * 100) / 100 = dgt then dgt = 2 else
		if IntPortion(dgt * 1000) / 1000 = dgt then dgt = 3 else
		if IntPortion(dgt * 10000) / 10000 = dgt then dgt = 4 else
		dgt = 5;
	end;
	s = "<Date>, <Time>, <Open>, <High>, <Low>, <Close>, <Volume>";
	if FileName = "" then
		Print(s)
	else begin
		FileDelete(FileName);
		FileAppend(FileName, s + NewLine);
	end;
end;

if Date > lastDate then begin
	nd = CalcDate(Date, dayShift);
	lastDate = Date;
end;


if CurrentBar = 1 then begin
	SectorCnt = 0;
	VarRand = Round( Random(1), 0 );
	if VarRand = 1 then ValueCompr[SectorCnt] = ComprStart1 + Random(ComprStop1)
	else ValueCompr[SectorCnt] = ComprStart2 + Random(ComprStop2);
end;


dt = DateTimeToStringEU(nd, ",", Time);
nO = (Open) * ValueCompr[SectorCnt];
nH = (High) * ValueCompr[SectorCnt];
nL = (Low) * ValueCompr[SectorCnt];
nC = (Close) * ValueCompr[SectorCnt];

if CurrentBar <= 1 {and SectorCnt = 0} then ValueShift = ValueShift - ( nO - Open );

//print( DateSector[0], " ", DateSector[1], " ", DateSector[2], " ", DateSector[3], " ", DateSector[4], " ", DateSector[5] );
//print( ValueCompr[0], " ", ValueCompr[1], " ", ValueCompr[2], " ", ValueCompr[3], " ", ValueCompr[4], " ", ValueCompr[5] );

{
if DataTrue and Date > Date[1] then begin
	DateSector[SectorCnt] = Date;
	DataTrue = False;
end;
}

if Date > Date[1] then nDays = nDays + 1;

if nDays >= DaysXsector {and Date > Date[1]} then begin
	SectorCnt = SectorCnt + 1;
	
	VarRand = Round( Random(1), 0 );
	if VarRand = 1 then ValueCompr[SectorCnt] = ComprStart1 + Random(ComprStop1)
	else ValueCompr[SectorCnt] = ComprStart2 + Random(ComprStop2);
	
	DateSector[SectorCnt] = Date;
	//print(ValueCompr[SectorCnt], "   ValueCompr");
	//DataTrue = True;
	nDays = 0;
end;

if Date = DateSector[SectorCnt] and Date[1] > Date[2] then ValueShift = ValueShift - ( nO - nC[1] );

//print( ValueShift, " ", nO, " ", nC[1] );

dt = DateTimeToStringEU(nd, "," , Time);
nO1 = ( nO + ValueShift ) ;
nH1 = ( nH + ValueShift ) ;
nL1 = ( nL + ValueShift ) ;
nC1 = ( nC + ValueShift ) ;

{s = NumToStr(nO, dgt) + "," + NumToStr(nH, dgt) + "," + NumToStr(nL, dgt) + "," + NumToStr(nC, dgt) + ","
  + NumToStr(Ticks, 0);}
  
 s = NumToStr(nO1, dgt) + "," + NumToStr(nH1, dgt) + "," + NumToStr(nL1, dgt) + "," + NumToStr(nC1, dgt) + ","
 + NumToStr(Ticks, 0);
 
//PlotPaintBar(nH, nL, nO, nC);
PlotPaintBar(nH1, nL1, nO1, nC1);
if FileName = "" then
	Print(dt + "," + s)
else
	FileAppend(FileName, dt + "," + s + NewLine);
