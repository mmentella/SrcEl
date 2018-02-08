[LegacyColorValue = true]; 

Inputs:
	Jaw(13),
	JawOffset(8),
	Teeth(8),
	TeethOffset(5),
	Lip(5),
	LipOffset(3),
	Value((High+Low)/2),
	ValueUp(Green),
	ValueDown(Red);

               
value1=Average(value,Jaw)[JawOffset];
value2=Average(value,Teeth)[TeethOffset];
value3=Average(value,Lip)[LipOffset];

if currentbar>=21 then
begin
	value11 = absvalue(value1-value2);
	if value11>value11[1] then begin
		plot1(value11,"BLblue",ValueUp);
	end
	else
		plot1(value11,"BLblue",ValueDown);
		
	value12 = -absvalue(value2-value3);
	if value12>value12[1] then begin
		plot2(value12,"BLred",ValueUp);
	end
	else
		plot2(value12,"BLred",ValueDown);
end;
