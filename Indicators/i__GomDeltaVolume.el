

inputs:
	ShowTotalVolume(true);


variables:
	total_volume(0),
	up_volume(0),
	down_volume(0),
	delta_volume(0),

	initialized(false);


if {initialized} 1=1 then begin

	delta_volume = upticks - downticks;
	total_volume = ticks;

	if ( delta_volume > 0 ) then begin
		up_volume = delta_volume;
		down_volume = 0;
	end
	else begin
		up_volume = 0;
		down_volume = delta_volume;
	end;

	if ShowTotalVolume then
		plot1(total_volume, "TotalVolume");

	plot2(up_volume, "UpVolume");
	plot3(down_volume, "DownVolume");

end;

initialized = initialized or lastbaronchart_s and barstatus = 2;


