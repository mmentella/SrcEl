
Inputs: Step$(1000), EUROconv(1), GridColor(DarkGray);


Variables: maxLines(99), stepSize(Step$ / (BigPointValue * EUROconv)), halfStep(stepSize * 0.5);


Vars: maxVal(0), minVal(999999);
Vars: firstDate(0), firstTime(0);
Vars: valStep(0), totLines(0), cnt(0), tlID(0);


if CurrentBar <= 1 then begin
	firstDate = Date; firstTime = Time; end;

if High > maxVal then maxVal = High;
if Low < minVal then minVal = Low;

if LastBarOnChart then begin
	totLines = IntPortion((maxVal - minVal) / stepSize) + 1;
	if totLines > maxLines then
		RaiseRunTimeError("Too many lines (" + NumToStr(totLines, 0) + ")");
	for cnt = 0 to totLines begin
		valStep = minVal + cnt * stepSize;
		//if valStep < minVal + (cnt - 1) * stepSize then print("! cnt = ", cnt:1:0);
		tlID = TL_New(firstDate, firstTime, valStep, Date, Time, valStep);
		TL_SetColor(tlID, GridColor);
		valStep = valStep - halfStep;
		tlID = TL_New(firstDate, firstTime, valStep, Date, Time, valStep);
		TL_SetColor(tlID, GridColor);
		TL_SetStyle(tlID, Tool_Dotted);
	end;
end;
