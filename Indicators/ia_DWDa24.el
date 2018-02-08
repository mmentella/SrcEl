
Inputs: EUROconv(1), ShowEquity(false), ShowIndexDWD(false);

//Vars: ContractValue(0);
Vars: maxEq(0), dwd$(0), minDwd$(0);
Vars: lastDate(0), c1(0), c2(0);
Vars: posH(0), i_dwd(0), i_dwdMin(0);
//Vars: winDays(0), lossDays(0), flatDays(0), opEq(0), lastEq(0), lastClose(0);
//Vars: txtID(0), txtDate(0), txtTime(0), txtMax(0), txtMin(0);
//Vars: winPerc(0), lossPerc(0), NetPerc(0);

Arrays: dwd$s[8](0);


//opEq = i_OpenEquity;

if i_OpenEquity > maxEq then begin
	for c1 = 0 to 7 begin
		if minDwd$ <= dwd$s[c1] then begin
			for c2 = 6 downto c1 begin
				dwd$s[c2 + 1] = dwd$s[c2];
			end;
			dwd$s[c1] = minDwd$;
			c1 = 7;
		end;
	end;
	maxEq = i_OpenEquity;
	minDwd$ = 0;
	dwd$ = 0;
end
else begin
	dwd$ = i_OpenEquity - maxEq;
	if dwd$ < minDwd$ then minDwd$ = dwd$;
end;

if ShowIndexDWD then begin
	if Close > posH then posH = Close;
	i_dwd = Close - posH;
	if i_dwd >= 0 then
		i_dwdMin = 0
	else
	if i_dwd < i_dwdMin then
		i_dwdMin = i_dwd;
	Plot30(i_dwd, "DWD_Index");
end;

if dwd$s[0] < 0 then Plot1(dwd$s[0] * EUROconv, "DWD$1");
if dwd$s[1] < 0 then Plot2(dwd$s[1] * EUROconv, "DWD$2");
if dwd$s[2] < 0 then Plot3(dwd$s[2] * EUROconv, "DWD$3");
if dwd$s[3] < 0 then Plot4(dwd$s[3] * EUROconv, "DWD$4");
if dwd$s[4] < 0 then Plot5(dwd$s[4] * EUROconv, "DWD$5");
if dwd$s[5] < 0 then Plot6(dwd$s[5] * EUROconv, "DWD$6");
if dwd$s[6] < 0 then Plot7(dwd$s[6] * EUROconv, "DWD$7");
if dwd$s[7] < 0 then Plot8(dwd$s[7] * EUROconv, "DWD$8");
Plot9(dwd$ * EUROconv, "DWD$_now");
Plot10(0, "Zero");
if ShowEquity then
	Plot20(i_OpenEquity * EUROconv, "Equity");
