YAWS FÖR CALLGUIDE
------------------------------------------------------------------
I Subversion ska det ligga en katalog <Third Party Tools\yaws-vsn>, där "vsn" byts ut mot aktuell version av Yaws. När vi byter till en ny version av Yaws låter vi den gamla ligga kvar (t.ex. "yaws-1.96") i Subversion, och lägger till en ny katalog (t.ex. "yaws-1.97").

Katalogen skall innehålla nedanstående kataloger/filer:

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

När man skapar en releasekatalog av Yaws för CallGuide kommer nedanstående kataloger att skapas. Releasekatalogen <yaws> är den som ska användas vid bygge av installationsprogram.

.\Third Party Tools\yaws-vsn\release\yaws\
.\Third Party Tools\yaws-vsn\release\yaws\ebin
.\Third Party Tools\yaws-vsn\release\yaws\include
.\Third Party Tools\yaws-vsn\release\yaws\priv

INSTRUKTIONER
------------------------------------------------------------------

SKAPA RELEASKATALOG: Hämta ut senaste versionen av yaws-vsn från Subversion, öppna ett kommandofönster på toppnivå och gör "make compile". När detta är klart har filer kompilerats, installerats, och kopierats till en releaskatalog.

HANTERA CONFIG-FILER: Konfigurationsfilen <yaws.conf> kan se olika ut beroende på vem som använder den, så denna måste hanteras separat av respektive delprodukts installationsprgram. Normalt ligger det en <yaws.conf> incheckat i Subversion för den delprodukten.

UPPGRADERA YAWS: För att uppgradera Yaws gör man en kopia av nuvarande katalog i Subversion och döper om den med nytt versionsnummer, t.ex. <yaws-1.97>. Sedan gör man följande:

* Ladda ner arkvifil med senaste versionen av Yaws och ersätt <templateFiles\yaws-vsn.tar.gz> med denna.
* Packa upp arkvifil (på annan plats, t.ex. <C:\yaws-1.97>.
* Radera filer i katalogerna <include>, <priv> och <src>, och ersätt med filer från ny Yaws.
* Kontrollera om *.src och *.template-filer i <templateFiles> har ändrats i ny Yaws.
* Se till att våra egna ändringar i <templateFiles\src> läggs till i motsvarande filer i ny Yaws. Just denna operation kan vara lite trixig. I det enklaste fallet har det inte gjorts några ändringar i ny Yaws, och då kan du helt enkelt kopiera över våra ändrade filer till <src>. Men om detta inte är fallet använder du förslagsvis ett verktyg (typ DiffMerge) för att se vad som skiljer sig mellan två filer. Till din hjälp har du även en beskrivning i huvudet på ändrad fil som anger vad vi (på Telia) har gjort för ändringar.

ÄNDRA I YAWS KÄLLKOD: Om vi behöver göra egna ändringar i Yaws källkod måste vi ha ordentlig koll på vad vi har ändrat. En kopia av ändrad fil måste därfört ALLTID ligga i katalogen <templateFiles\src>. I filhuvudet skall man även ange vad det är man har ändrat. 

VÅRA EGNA ÄNDRINGAR: I huvudet på våra egna ändrade filer finns en beskrivning av vad som har ändrats.

FÅ MED VÅRA ÄNDRINGAR I YAWS: Målet måste alltid vara att inte ha några egna ändringar alls, utan att alltid använda urspringlig Yaws. För att uppnå detta bör vi så snart som möjligt försöka få in våra ändringar i öppna källkoden. Mejla Klacke/etc på: erlyaws-list@lists.sourceforge.net

STATUS PÅ VÅRA EGNA ÄNDRINGAR I OFFICIELL YAWS (2013-08-28): Öppen källkod för Yaws ligger på Github (https://github.com/klacke/yaws). Tidigare i våras skickade jag in våra ändringar till erlyaws-list (https://lists.sourceforge.net/lists/listinfo/erlyaws-list) för översyn. Steve Vinoski (vinoski@ieee.org) tog sig an att föra in dessa i en egen branch (https://github.com/klacke/yaws/tree/soap-concurrency). Först vid nästa release av Yaws kommer (förhoppningsvis) våra ändringar med, och då kan vi ta bort dessa ändringar och istället köra på officiell kod, men endast för de ändringar som kommit med!

De ändringar som inte kommit med i denna branch är såna som varit väldigt specifika för oss och därmed inte bara kan inkluderas i officiell kod. Sök på "telia" i följande filer:
- yaws_rpc.erl: Hantering av charset.
- yaws_soap_srv_worker.erl: Konvertering av resultat till utf8.

Vid nästa version av Yaws kommer vi alltså att behöva se till att ovanstående två ändringar inkluderas i källkoden. Långsiktigt vore det naturligtvis bäst att jobba för att få med dessa ändringar i officiell kod.

ÖVRIGA NÖDVÄNDIGA BIBLIOTEK: Erlsom krävs för Yaws. Se eget paket för detta i Subversion.

MAKE-FILE: Följande kommandon finns:

* make compile: Städar upp, kompilerar och installerar filer, samt skapar en releaskatalog.
* make clean: Städar upp och raderar alla releasefiler, tempfiler, etc. Detta kommando är bra att köra innan man ska checka in ändringar i Subversion.
* make release: Skapar en releasekatalog med alla filer som behövs för en installation.

PROGRAMVERSION: Vid Telias interna säkerhetsvalidering fick vi tidigare bakläxa för att vi exponerade version av Yaws. Numera har vi istället ett versionsnummer "CallGuide_Internal_Version". Detta anges i filen <templateFiles\vsn.config> innan man kompilerar.

BYGGA INSTALLATIONSPROGRAM: Följande gäller för både Yaws och Erlsom.

* Tidigare har Yaws installerats i <3p_lib\yaws> och Erlsom i <3p_lib\erlsom-1.2.1>. Från och med CallGuide 8.4.1 kommer vi även att installera Yaws med versionsnummer, dvs <3p_lib\yaws-1.96>. Det kommer då (vid uppgradering) att finnas två yaws-kataloger, men Erlang använder per default den med störst versionsnummer, och <yaws-1.96> tolkas som större än <yaws>.
* När man skapar en releaskatalog med make-filen skapas en katalog utan versionsnummer (<yaws>, <erlsom>). Du får själv lägga till versionsnummer i katalognamnet när du skapar installationsprogram.
* För Erlsom gäller att källkoden har uppdaterats även fast versionsnummret inte har gjort det. Installationspprgrammet måste därför vara nogrann med att skriva över gamla filer med nya!
