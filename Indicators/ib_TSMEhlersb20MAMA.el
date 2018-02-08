[LegacyColorValue = TRUE];

{ TSM Ehlers MAMA
  from John F. Ehlers, "Rocket Science for Traders"
  (John Wiley & Sons, New York, 2001 }

inputs: 	price((H+L)/2), fastlimit(.5), slowlimit(.05);
vars:		smooth(0), detrender(0), i1(0), q1(0), ji(0), jq(0), i2(0), q2(0), re(0), im(0), period(0),
			smoothperiod(0), phase(0), deltaphase(0), alpha(0), MAMA(0), FAMA(0);

if currentbar > 5 then begin
	smooth = (4*price + 3*price[1] + 2*price[2] + price[3])/10;
	detrender = (.962*smooth + .5769*smooth[2] - .5769*smooth[4] - .0962*smooth[6])*(.075*period[1] + .54);
	
{ computer InPhase and Quadrature components }
	q1 = (.0962*detrender + .5769*detrender[2] + .5769*detrender[4] - .0962*detrender[6])*(.075*period[1] + .54);
	i1 = detrender[3];

{ advance the phase of i1 and q1 by 90 degrees }
   ji = (.0962*i1 + .5769*i1[2] - .5769*i1[4] - .0962*i1[6])*(.075*period[1] + .54);
   jq = (.0962*q1 + .5769*q1[2] - .5769*q1[4] - .0962*q1[6])*(.075*period[1] + .54);

{ phase addition for 3 bar averaging }
	i2 = i1 - jq;
	q2 = q1 + ji;

{ smooth the i and q components before applying }
	i2 = .2*i2 + .8*i2[1];
	q2 = .2*q2 + .8*q2[1];

{ hymodyne discriminator }
   re = i2*i2[1] + q2*q2[1];
	im = i2*q2[1] - q2*i2[1];
	re = .2*re + .8*re[1];
	im = .2*im + .8*im[1];
	if im <> 0 and re <> 0 then period = 360/arctangent(im/re);
	if period > 1.5*period[1] then period = 1.5*period[1];
	if period < 6 then period = 6;
	if period > 50 then period = 50;
	period = .2*period + .8*period[1];
	smoothperiod = .33*period + .67*smoothperiod[1];
	if i1 <> 0 then phase = (arctangent(q1/i1));
	deltaphase = phase[1] - phase;
	if deltaphase < 1 then deltaphase = 1;
	alpha = fastlimit / deltaphase; {fastlimit was "speed"}
	if alpha < slowlimit then alpha = slowlimit;
	MAMA = alpha*price + (1 - alpha)*MAMA[1];
	FAMA = .5*alpha*MAMA + (1 - .5*alpha)*FAMA[1];

	plot1(MAMA,"MAMA");
	plot2(FAMA,"FAMA");
	end;
