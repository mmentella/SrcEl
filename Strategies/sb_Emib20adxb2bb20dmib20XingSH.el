[LegacyColorValue = TRUE];


{***************************************
Written by: Emi 02feb05

 Description: applica DMi Xing quando vola in rialzo e - in alternativa - il sideways con il ribasso
****************************************}

Inputs: ADXlimit(20),ADXlength(13);
variable: fast(5),counterdmiS(0),counterSdsh(0);

If  (ADX(ADXlength) > ADXlimit) then begin
	
If DMIPLUS(fast) cross below DMIMINUS(fast) then
Sell ("dmi-LO") this Bar at Close;
counterdmiS = counterdmiS + 1;
End


else
	
{ALTRIMENTI usa Sideways per i segnali}	
begin
Inputs: ipercomp(85);
Variables: RSILength(5),RS.d1(00);

RS.d1 = RSI(Close, RSILength);

If RS.d1 Cross below ipercomp  Then
Sell ("SD-sh") this Bar at Close;
counterSdsh = counterSdsh + 1;
end;

if (Date  = @vrt.LastCalcDate) and (Time = @vrt.LastCalcTime)  then begin
  Print (@vrt.MMDDYYYY (Date), ", ", @vrt.HHMM.pm (Time), ", counterdmiS=", counterdmiS:1:0, ", counterSDsh=", counterSdsh:1:0) ;
end ;
