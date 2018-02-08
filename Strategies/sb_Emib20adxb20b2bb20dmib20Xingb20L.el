[LegacyColorValue = TRUE];


{***************************************
Written by: Emi 02feb05

 Description: applica DMi Xing quando vola in rialzo e - in alternativa - il sideways con il ribasso
****************************************}

Inputs: ADXlimit(20),ADXlength(13);
variable: fast(5),counterdmiL(0),counterSdL(0);

If  (ADX(ADXlength) > ADXlimit) then begin
	
If DMIPLUS(fast) cross above DMIMINUS(fast) then
Buy ("dmi-LO") this Bar at Close;
counterdmiL = counterdmiL + 1;
End


else
	
{ALTRIMENTI usa Sideways per i segnali}	
begin
Inputs:  ipervend(15);
Variables: RSILength(5),RS.d1(00);

RS.d1 = RSI(Close, RSILength);

If RS.d1 Cross above ipervend  Then
Buy ("SD-LO") this Bar at Close;
counterSdL=counterSdL + 1;
end;

if (Date  = @vrt.LastCalcDate) and (Time = @vrt.LastCalcTime)  then begin
  Print (@vrt.MMDDYYYY (Date), ", ", @vrt.HHMM.pm (Time), ", counterdmiL=", counterdmiL:1:0, ", counterSDL=", counterSdL:1:0) ;
end ;

