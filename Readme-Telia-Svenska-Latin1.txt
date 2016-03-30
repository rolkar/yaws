YAWS F�R CALLGUIDE
------------------------------------------------------------------
I Subversion ska det ligga en katalog <Third Party Tools\yaws-vsn>, d�r "vsn" byts ut mot aktuell version av Yaws. N�r vi byter till en ny version av Yaws l�ter vi den gamla ligga kvar (t.ex. "yaws-1.96") i Subversion, och l�gger till en ny katalog (t.ex. "yaws-1.97").

Katalogen skall inneh�lla nedanst�ende kataloger/filer:

.\Third Party Tools\yaws-vsn\make.cmd
.\Third Party Tools\yaws-vsn\Readme.txt
.\Third Party Tools\yaws-vsn\ebin
.\Third Party Tools\yaws-vsn\include\*.hrl
.\Third Party Tools\yaws-vsn\priv\*.xsd, mime.types
.\Third Party Tools\yaws-vsn\src\*.erl, *.hrl, Makefile
.\Third Party Tools\yaws-vsn\templateFiles\sed.erl
.\Third Party Tools\yaws-vsn\templateFiles\vsn.config
.\Third Party Tools\yaws-vsn\templateFiles\*.src, *.template
.\Third Party Tools\yaws-vsn\templateFiles\yaws-vsn.tar.gz
.\Third Party Tools\yaws-vsn\templateFiles\src\*.erl, *.hrl

N�r man skapar en releasekatalog av Yaws f�r CallGuide kommer nedanst�ende kataloger att skapas. Releasekatalogen <yaws> �r den som ska anv�ndas vid bygge av installationsprogram.

.\Third Party Tools\yaws-vsn\release\yaws\
.\Third Party Tools\yaws-vsn\release\yaws\ebin
.\Third Party Tools\yaws-vsn\release\yaws\include
.\Third Party Tools\yaws-vsn\release\yaws\priv

INSTRUKTIONER
------------------------------------------------------------------

SKAPA RELEASKATALOG: H�mta ut senaste versionen av yaws-vsn fr�n Subversion, �ppna ett kommandof�nster p� toppniv� och g�r "make compile". N�r detta �r klart har filer kompilerats, installerats, och kopierats till en releaskatalog.

HANTERA CONFIG-FILER: Konfigurationsfilen <yaws.conf> kan se olika ut beroende p� vem som anv�nder den, s� denna m�ste hanteras separat av respektive delprodukts installationsprgram. Normalt ligger det en <yaws.conf> incheckat i Subversion f�r den delprodukten.

UPPGRADERA YAWS: F�r att uppgradera Yaws g�r man en kopia av nuvarande katalog i Subversion och d�per om den med nytt versionsnummer, t.ex. <yaws-1.97>. Sedan g�r man f�ljande:

* Ladda ner arkvifil med senaste versionen av Yaws och ers�tt <templateFiles\yaws-vsn.tar.gz> med denna.
* Packa upp arkvifil (p� annan plats, t.ex. <C:\yaws-1.97>.
* Radera filer i katalogerna <include>, <priv> och <src>, och ers�tt med filer fr�n ny Yaws.
* Kontrollera om *.src och *.template-filer i <templateFiles> har �ndrats i ny Yaws.
* Se till att v�ra egna �ndringar i <templateFiles\src> l�ggs till i motsvarande filer i ny Yaws. Just denna operation kan vara lite trixig. I det enklaste fallet har det inte gjorts n�gra �ndringar i ny Yaws, och d� kan du helt enkelt kopiera �ver v�ra �ndrade filer till <src>. Men om detta inte �r fallet anv�nder du f�rslagsvis ett verktyg (typ DiffMerge) f�r att se vad som skiljer sig mellan tv� filer. Till din hj�lp har du �ven en beskrivning i huvudet p� �ndrad fil som anger vad vi (p� Telia) har gjort f�r �ndringar.

�NDRA I YAWS K�LLKOD: Om vi beh�ver g�ra egna �ndringar i Yaws k�llkod m�ste vi ha ordentlig koll p� vad vi har �ndrat. En kopia av �ndrad fil m�ste d�rf�rt ALLTID ligga i katalogen <templateFiles\src>. I filhuvudet skall man �ven ange vad det �r man har �ndrat. 

V�RA EGNA �NDRINGAR: I huvudet p� v�ra egna �ndrade filer finns en beskrivning av vad som har �ndrats.

F� MED V�RA �NDRINGAR I YAWS: M�let m�ste alltid vara att inte ha n�gra egna �ndringar alls, utan att alltid anv�nda urspringlig Yaws. F�r att uppn� detta b�r vi s� snart som m�jligt f�rs�ka f� in v�ra �ndringar i �ppna k�llkoden. Mejla Klacke/etc p�: erlyaws-list@lists.sourceforge.net

STATUS P� V�RA EGNA �NDRINGAR I OFFICIELL YAWS (2013-08-28): �ppen k�llkod f�r Yaws ligger p� Github (https://github.com/klacke/yaws). Tidigare i v�ras skickade jag in v�ra �ndringar till erlyaws-list (https://lists.sourceforge.net/lists/listinfo/erlyaws-list) f�r �versyn. Steve Vinoski (vinoski@ieee.org) tog sig an att f�ra in dessa i en egen branch (https://github.com/klacke/yaws/tree/soap-concurrency). F�rst vid n�sta release av Yaws kommer (f�rhoppningsvis) v�ra �ndringar med, och d� kan vi ta bort dessa �ndringar och ist�llet k�ra p� officiell kod, men endast f�r de �ndringar som kommit med!

De �ndringar som inte kommit med i denna branch �r s�na som varit v�ldigt specifika f�r oss och d�rmed inte bara kan inkluderas i officiell kod. S�k p� "telia" i f�ljande filer:
- yaws_rpc.erl: Hantering av charset.
- yaws_soap_srv_worker.erl: Konvertering av resultat till utf8.

Vid n�sta version av Yaws kommer vi allts� att beh�va se till att ovanst�ende tv� �ndringar inkluderas i k�llkoden. L�ngsiktigt vore det naturligtvis b�st att jobba f�r att f� med dessa �ndringar i officiell kod.

�VRIGA N�DV�NDIGA BIBLIOTEK: Erlsom kr�vs f�r Yaws. Se eget paket f�r detta i Subversion.

MAKE-FILE: F�ljande kommandon finns:

* make compile: St�dar upp, kompilerar och installerar filer, samt skapar en releaskatalog.
* make clean: St�dar upp och raderar alla releasefiler, tempfiler, etc. Detta kommando �r bra att k�ra innan man ska checka in �ndringar i Subversion.
* make release: Skapar en releasekatalog med alla filer som beh�vs f�r en installation.

PROGRAMVERSION: Vid Telias interna s�kerhetsvalidering fick vi tidigare bakl�xa f�r att vi exponerade version av Yaws. Numera har vi ist�llet ett versionsnummer "CallGuide_Internal_Version". Detta anges i filen <templateFiles\vsn.config> innan man kompilerar.

BYGGA INSTALLATIONSPROGRAM: F�ljande g�ller f�r b�de Yaws och Erlsom.

* Tidigare har Yaws installerats i <3p_lib\yaws> och Erlsom i <3p_lib\erlsom-1.2.1>. Fr�n och med CallGuide 8.4.1 kommer vi �ven att installera Yaws med versionsnummer, dvs <3p_lib\yaws-1.96>. Det kommer d� (vid uppgradering) att finnas tv� yaws-kataloger, men Erlang anv�nder per default den med st�rst versionsnummer, och <yaws-1.96> tolkas som st�rre �n <yaws>.
* N�r man skapar en releaskatalog med make-filen skapas en katalog utan versionsnummer (<yaws>, <erlsom>). Du f�r sj�lv l�gga till versionsnummer i katalognamnet n�r du skapar installationsprogram.
* F�r Erlsom g�ller att k�llkoden har uppdaterats �ven fast versionsnummret inte har gjort det. Installationspprgrammet m�ste d�rf�r vara nogrann med att skriva �ver gamla filer med nya!
