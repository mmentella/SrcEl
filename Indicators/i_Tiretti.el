[LegacyColorValue = TRUE];

input: Strategia("TEST"),Euro(true),QuotEuroDollar(0.68),File2anni(true);
var: Utile(0),Chiusure(0),UtilePrecedente(0),OpenE(0),NomeFile1(""),NomeFile2(""),Simbolo(""),ultima(""),attuale("");


Simbolo= LeftStr(GetSymbolName, 5);
NomeFile1= Simbolo+"@"+Strategia;
if File2anni then
	begin
NomeFile2= "c:\Tiretti2Anni\"+NomeFile1+".txt";
	end
else
	begin
		NomeFile2= "c:\TirettiCompleti\"+NomeFile1+".txt";
		end;



if currentbar=1 then
begin
	FileDelete(NomeFile2);
	end;

if d<>d[1] then
begin
	Utileprecedente= OpenE;
	if(euro) then
		begin
			ultima = ELDateToString(d[1])+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr(I_OpenEquity,2);
		FileAppend(NomeFile2,ELDateToString(d[1])+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr(I_OpenEquity,2)+newline);
		end
	else
		begin
			ultima = ELDateToString(d[1])+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr((I_OpenEquity)*QuotEuroDollar,2);
			FileAppend(NomeFile2,ELDateToString(d[1])+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr((I_OpenEquity)*QuotEuroDollar,2)+newline);
			end;
	end;


OpenE = I_OpenEquity;
Utile=I_OpenEquity-Utileprecedente;
Chiusure= I_ClosedEquity;

plot1(Utile);

if lastbaronchart  then
begin
	if(euro) then
		begin
			attuale=ELDateToString(d)+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr(I_OpenEquity,2);
			if attuale <> ultima then
				begin
			FileAppend(NomeFile2,ELDateToString(d)+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr(I_OpenEquity,2)+newline);
		end;
			end
	else
		begin
			attuale=ELDateToString(d)+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr((I_OpenEquity)*QuotEuroDollar,2);
			if attuale<>ultima then
				begin
			FileAppend(NomeFile2,ELDateToString(d)+"|"+numtostr(time,0)+"|"+numtostr(Utile,2)+"|"+numtostr(I_ClosedEquity,2)+"|"+numtostr((I_OpenEquity)*QuotEuroDollar,2)+newline);
				end;
			end;
	end;




