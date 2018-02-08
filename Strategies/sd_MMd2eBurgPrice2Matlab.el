Inputs: Price(medianprice),Path("C:\Portafoglio\Sviluppo\MATLAB\");

vars: _path(Path),filename(getsymbolname+".txt");

if currentbar = 1 then begin
 if RightStr(path,1) <> "\" then _path = Path + "\";
 FileDelete(_path+filename);
end;

value1 = MM.MesaFilter(Price);

print(file(_path+filename),NumToStr(value1,IntPortion(log(pricescale)/log(10))));
