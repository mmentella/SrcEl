
Inputs: Daily(false), FastAvgDays(5), SlowAvgDays(22);

if Daily then
	Plot1(AvgDailyRange(0), "DayRange");
Plot2(AvgDailyRange(SlowAvgDays), "SlowAvgRange");
Plot3(AvgDailyRange(FastAvgDays), "FastAvgRange");
