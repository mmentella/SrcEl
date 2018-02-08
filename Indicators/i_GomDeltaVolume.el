
inputs:
	DeltaCalculationMode(1),	// 0 - AskBidType, 1 - UpDnVolumeType

	AskDataNumber(1),
	BidDataNumber(2);

inputs:
	ShowTotalVolume(true);


variables:
	total_volume(0),
	up_volume(0),
	down_volume(0),
	delta_volume(0),

	initialized(false);


if initialized then begin

	delta_volume = DeltaVolume(DeltaCalculationMode, AskDataNumber, BidDataNumber);
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


