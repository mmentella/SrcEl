[LegacyColorValue = TRUE];

input: Strategia("TEST"),Tipo("STRATEGIE");
var:Massimi(-9999999),DWD(99999),DWDStorico(99999),Perc(0);
var: NomeFileDWD("TEST"),simboloDWD(""),nomefilex(""),ultimaDWD(""),attualeDWD(""),NomeFileTrade("");

input: Euro(true),QuotEuroDollar(0.68),File2anni(false);
var: Utile(0),Chiusure(0),UtilePrecedente(0),OpenE(0),NomeFile1(""),NomeFile2(""),Simbolo(""),ultima(""),attuale("");
var: ValoreEuro(0),ValoreCEuro(0),utiler(0);







SimboloDWD= LeftStr(GetSymbolName, 5);
nomefilex= SimboloDWD+"@"+Strategia;

NomeFileDWD= "c:\DWD"+Tipo+"\"+nomefilex+".txt";




if currentbar=1 then
begin
	FileDelete(NomeFileDWD);
	end;

if currentbar>1 then
	begin
if I_OpenEquity>=Massimi then
	begin
		Massimi=I_OpenEquity;
	end;

if I_OpenEquity<Massimi then
	begin
		DWD=I_OpenEquity-Massimi;
	end;

if DWD<DWDStorico then
	begin
		DWDStorico=DWD;
	end;

	if DWDStorico<99999 then
		begin
Perc= (DWD*100)/DWDStorico;
		end
	else
		begin
			Perc=0;
		end;

if d<>d[1] then
begin
	FileAppend(NomeFileDWD,ELDateToString(d[1])+"|"+numtostr(time,2)+"|"+numtostr(DWDStorico,0)+"|"+numtostr(DWD,0)+"|"+numtostr(Perc,0)+newline);
	ultimaDWD = ELDateToString(d[1])+"|"+numtostr(time,2)+"|"+numtostr(DWDStorico,0)+"|"+numtostr(DWD,0)+"|"+numtostr(Perc,0);
end;

if lastbaronchart  then
begin
	attualeDWD = ELDateToString(d)+"|"+numtostr(time,2)+"|"+numtostr(DWDStorico,0)+"|"+numtostr(DWD,0)+"|"+numtostr(Perc,0);
	if attualeDWD<>ultimaDWD then
		begin
	FileAppend(NomeFileDWD,ELDateToString(d)+"|"+numtostr(time,2)+"|"+numtostr(DWDStorico,0)+"|"+numtostr(DWD,0)+"|"+numtostr(Perc,0)+newline);
	end;
	end;

	plot1(DWDStorico,"DWDStorico");
	plot2(DWD,"DWD");
	plot3(Perc,"Perc");

	end;





Simbolo= LeftStr(GetSymbolName, 5);
NomeFile1= Simbolo+"@"+Strategia;
if File2anni then
	begin
NomeFile2= "c:\Tiretti2Anni\"+NomeFile1+".txt";
	end
else
	begin
		NomeFile2= "c:\"+Tipo+"\"+NomeFile1+".txt";
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
			ValoreEuro=(I_OpenEquity*QuotEuroDollar);
			ValoreCEuro=(I_ClosedEquity*QuotEuroDollar);
			utiler= (Utile*QuotEuroDollar);
			ultima = ELDateToString(d[1])+"|"+numtostr(time,0)+"|"+numtostr(utiler,2)+"|"+numtostr(ValoreCEuro,2)+"|"+numtostr((ValoreEuro),2);
			FileAppend(NomeFile2,ELDateToString(d[1])+"|"+numtostr(time,0)+"|"+numtostr(utiler,2)+"|"+numtostr(ValoreCEuro,2)+"|"+numtostr(ValoreEuro,2)+newline);
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
			ValoreEuro=(I_OpenEquity*QuotEuroDollar);
			ValoreCEuro=(I_ClosedEquity*QuotEuroDollar);
			utiler= (Utile*QuotEuroDollar);
			attuale=ELDateToString(d)+"|"+numtostr(time,0)+"|"+numtostr(utiler,2)+"|"+numtostr(ValoreCEuro,2)+"|"+numtostr(ValoreEuro,2);
			if attuale<>ultima then
				begin
			FileAppend(NomeFile2,ELDateToString(d)+"|"+numtostr(time,0)+"|"+numtostr(utiler,2)+"|"+numtostr(ValoreCEuro,2)+"|"+numtostr(ValoreEuro,2)+newline);
				end;
			end;
	end;





