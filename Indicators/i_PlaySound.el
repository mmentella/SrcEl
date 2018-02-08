[IntrabarOrderGeneration = true];

vars: intrabarpersist oldposition(0),intrabarpersist newposition(0);
vars: intrabarpersist filename("C:\MCLOG\LOG_"),
      intrabarpersist message(""),intrabarpersist header(""),intrabarpersist footer(";"),intrabarpersist start(false);

if getappinfo(airealtimecalc) = 1 {and getappinfo(aistrategyauto) = 1} then begin
 
 if not start then begin
  filename = filename + NumToStr(dayofmonth(currentdate),0) + ".";
  filename = filename + NumToStr(Month(currentdate),0) + ".";
  filename = filename + NumToStr(Year(currentdate)+1900,0) + ".txt";
  
  start = true;
 end;

 newposition = i_CurrentContracts*i_MarketPosition;
 if newposition <> oldposition then begin  
  header   = "[" + MM.CurrentDateTimeToStr_IT + " => " + getsymbolname+ "]";
  message  = getsymbolname+ " Filled Order at ";
  message  = message + numtostr(i_avgentryprice,log(pricescale)/log(10)) + " " + NumToStr(i_MarketPosition*i_CurrentContracts,0);
    
  //FileAppend(filename,header+message+footer+newline);
  
  alert;
 end;
 oldposition = newposition;

end;
