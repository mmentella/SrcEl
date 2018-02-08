[LegacyColorValue = true]; 

Inputs:
	Jaw(13),
	JawOffset(8),
	Teeth(8),
	TeethOffset(5),
	Lip(5),
	LipOffset(3),
	Value((High+Low)/2);

               
value1=Average(value,Jaw)[JawOffset];
value2=Average(value,Teeth)[TeethOffset];
value3=Average(value,Lip)[LipOffset];

if currentbar>=21 then
begin
	plot1(value1,"BLblue");
	plot2(value2,"BLred");
	plot3(value3,"BLgreen");
end;
