[LegacyColorValue = true]; 

Vars:		var0(0),var1(0);

                    
var0=Average((h+l)/2,5)-Average((h+l)/2,34);

                                     
var1=var0-Average(var0,5);

if currentbar>=5 then
	if var1>var1[1] then plot1(var1,"+AC")
	else plot2(var1,"-AC");
