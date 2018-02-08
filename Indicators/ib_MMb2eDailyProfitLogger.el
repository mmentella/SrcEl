vars: filename("C:\MM.LOG\Log.txt"),start(0),now(0),id("["+getsymbolname+"]"),csv(","),s(""),txtid(0);

if d <> d[1] then begin
 
 if d = currentdate then begin
  s = id + csv + MM.ELDateToString_IT(d[1]) + csv + NumToStr(now-start,2) + NewLine;
  
  FileAppend(filename,s);
 end;
 
 start = now;
 
end;

now = i_OpenEquity;

if LastBarOnChart then begin
 if txtid = 0 then txtid = text_new(d,t,c,"[MMDPL] => ALL DONE")
 else text_setlocation(txtid,d,t,c);
end;
