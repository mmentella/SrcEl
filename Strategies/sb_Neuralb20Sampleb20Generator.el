vars: filename("C:\Portafoglio\Sviluppo\Neural Sample\NNSamples_"),s(""),id(0);

if currentbar = 1 then begin
 filename = filename + getsymbolname + ".txt";
 FileDelete(filename);
 id = text_new(d,t,c,"ALL DONE");
 //text_new(d,t,c,"FIRST BAR");
end;

//if currentbar > MaxBarsBack then begin
 s = NumToStr(currentbar+MaxBarsBack,0)+ " ";
 
 //OHLC
 s = s + NumToStr(o,log(pricescale)/log(10)) + " ";
 s = s + NumToStr(h,log(pricescale)/log(10)) + " ";
 s = s + NumToStr(l,log(pricescale)/log(10)) + " ";
 s = s + NumToStr(c,log(pricescale)/log(10)) + " ";
 
 //RANGE
 s = s + NumToStr(range,log(pricescale)/log(10)) + " ";
 
 //ADX
 s = s + NumToStr(adx(14),log(pricescale)/log(10)) + " ";
 
 //RSI
 s = s + NumToStr(rsi(c,14),log(pricescale)/log(10)) + " ";
 
 //VOLATILITY
 s = s + NumToStr(Volatility(14),log(pricescale)/log(10)) + " ";
 
 //INTRADAY INTENSITY
 s = s + NumToStr(IntradayIntensity(14),log(pricescale)/log(10)) + " ";
 
 //VOLUME
 s = s + NumToStr(iff(bartype>=2,volume,ticks),log(pricescale)/log(10)) + " ";
 
 FileAppend(filename,s+newline);
//end;

if LastBarOnChart then text_setlocation(id,d,t,c);
