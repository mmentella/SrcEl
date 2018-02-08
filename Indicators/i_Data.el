input:
	UpColor(Green),
	DnColor(Red),
	NtColor(White),
	Automatic(True);
	
if LastBarOnChart then                                           
begin

	var: last_(0), prevclose_(0),
	     _UpColor(0),_DnColor(0),_NtColor(0);
	     
	if (Automatic) Then
	  begin
		switch(GetBackgroundColor)
		begin
			case rgb(149,182,88)	 : _UpColor=darkgreen;_DnColor=red;_NtColor=white; 	{Green Gradient}
			case rgb(207,207,207) : _UpColor=darkgreen;_DnColor=red;_NtColor=black;  	{White Gradient}
			case rgb(255,255,255) : _UpColor=darkgreen;_DnColor=red;_NtColor=black;	{White} 	
			case rgb(150,230,150) : _UpColor=darkgreen;_DnColor=red;_NtColor=black;	{Green} 
			default:_UpColor=green;_DnColor=red;_NtColor=white;
		end;
	  end
	else
	  begin
		_UpColor=UpColor;_DnColor=DnColor;_NtColor=NtColor;
	  end;
	
	last_ = last;
	prevclose_ = prevclose;

	NoPlot(1);
	if ( last_ <> 0 ) then
	begin
		value1 = _NtColor;
		if ( last_ > prevclose_ ) then
			value1 = _UpColor
		else if ( last_ < prevclose_ ) then
			value1 = _DnColor;
				
		plot1 (last_, "Last", value1);
	end;
	
	NoPlot(2);
	NoPlot(3);
	if ( last_ <> 0 ) and ( prevclose_ <> 0 ) then
	begin
		value2 = last_ - prevclose_;
		value3 = value2 / prevclose_ * 100;
		plot2 (value2, "Net Chg", value1);
		plot3 (value3, "Net %Chg", value1);
	end;

	var: insidebid_(0), insideask_(0), dailyhigh_(0), dailylow_(0);
	
	insidebid_ = insidebid;
	if (insidebid_ <> 0) then
		plot4 (insidebid_, "Bid",_NtColor)
	else
		NoPlot(4);
		 
	insideask_ = insideask;
	if (insideask_ <> 0) then
		plot5 (insideask_, "Ask",_NtColor)
	else
		NoPlot(5);

	dailyhigh_ = dailyhigh;
	if (dailyhigh_ <> 0) then
		plot6 (dailyhigh_, "High",_NtColor)
	else
		NoPlot(6);

	dailylow_ = dailylow;
	if (dailylow_ <> 0) then
		plot7 (dailylow_, "Low",_NtColor)
	else
		NoPlot(7);

end;
