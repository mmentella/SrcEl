
Vars: gap(0), min(0), max(0);

if High < Low[1] then gap = High - Low[1]
else
if Low > High[1] then gap = Low - High[1]
else
gap = 0;

gap = Round(gap / Close[1] * 100, 2);

if gap > max then max = gap
else
if gap < min then min = gap;

Plot1(gap, "Gap %");
Plot2(min, "Max Neg %");
Plot3(max, "Max Pos %");
Plot4(0, "Zero");
{
if LastBarOnChart then begin
	Plot2(min, "Max Neg Gap");
	Plot3(max, "Max Pos Gap");
end;
}
