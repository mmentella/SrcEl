[LegacyColorValue = true]; 

Vars:		var0(0),var1(0);

                    
var0=Average((h+l)/2,5)-Average((h+l)/2,34);

                                     
var1=var0-Average(var0,5);

Plot3( 0, "ZeroLine" ) ;

if currentbar>=1 then
	if var0>var0[1] then plot1(var0,"+AO")
	else plot2(var0,"-AO")
	
	

