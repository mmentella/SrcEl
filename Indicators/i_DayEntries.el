
Vars: de(0), maxde(0), mp(0), class(0);
Vars: eq(0), eqY(0), gain(0);
Arrays: WinDays[5](0), NumDays[5](0);

if Date > Date[1] then begin
	gain = eq[1] - eqY;
	Plot1[1](0, "Zero");
	class = MinList(4, de);
	NumDays[class] = NumDays[class] + 1;
	if gain < 0 then
		Plot2[1](de, "EntriesToday", Red)
	else begin
		WinDays[class] = WinDays[class] + 1;
		Plot2[1](de, "EntriesToday", Green);
	end;
	Plot3[1](maxde, "EntriesMax");
	de = 0;
	eqY = eq[1];
end;

mp = i_MarketPosition;
if mp <> mp[1] then begin
	if mp <> 0 then de = de + 1;
	if de > maxde then maxde = de;
end;
eq = i_OpenEquity;

if LastBarOnChart then begin
	if NumDays[0] > 0 then
		Plot10(Round(WinDays[0] / NumDays[0], 2), "Win%-0_DayEntry");
	if NumDays[1] > 0 then
		Plot11(Round(WinDays[1] / NumDays[1], 2), "Win%-1_DayEntry");
	if NumDays[2] > 0 then
		Plot12(Round(WinDays[2] / NumDays[2], 2), "Win%-2_DayEntry");
	if NumDays[3] > 0 then
		Plot13(Round(WinDays[3] / NumDays[3], 2), "Win%-3_DayEntry");
	if NumDays[4] > 0 then
		Plot14(Round(WinDays[4] / NumDays[4], 2), "Win%-4+DayEntry");
end;
