[LegacyColorValue = TRUE];

Inputs: Len(80), Trig(.7);

Vars: WavCount(0), Osc(0);

Osc = ElliottWaveOsc;
WavCount = Wave345Elliott(Len, Trig);

IF WavCount = 3 AND WavCount[1] <= 0 Then
	Buy Next Bar at Open;

IF WavCount = 5 AND WavCount[1] = 4 Then
	Buy Next Bar at Open;

IF WavCount = 3 AND WavCount[1] = 5 Then 
	Buy Next Bar at Open;

IF Osc < 0 Then
	sell Next Bar at Open;
