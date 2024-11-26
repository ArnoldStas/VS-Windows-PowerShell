cd c:\Windows\System32
#1. Atrinkite einamojo aplanko tekstinius failus (.txt), kurie buvo sukurti iki 2022-09-19. Išveskite atrinktų failų vardus.
$date = Get-Date -Year 2022 -Month 09 -Day 19
Get-ChildItem -file *.txt | Where-Object {$_.CreationTime -le "$date"} | Select-Object Name

#2. Atrinkite einamojo aplanko failus, kurie buvo sukurti ne anksčiau kaip prieš 10 dienų ir kurių ilgis yra > 1kb. Išveskite atrinktų failų vardus ir ilgius.
$dat = (Get-Date).AddDays(-10)
Get-ChildItem -file | Where-Object {$_.CreationTime -ge $dat -and $_.Length -gt 1kb} | Select-Object Name, Length

#3. Sukurkite kintamąjį vardu 3lab, kuriam priskirti žodžius "3 laboratorinis" ir šios dienos datą (GetDate), išvestą nurodytu formatu:
[string]$3lab = "3 laboratorinis $(Get-Date -Format yyyy-MM-dd)"
$3lab

#4. Sukurkite kintamąjį string, kuriam priskirkite kintamąjį 3lab ir simbolių (----) eilutę. Simbolių (----) eilutės ilgis turi sutapti su kintamojo 3lab ilgiu (naudokite eilutės savybę Length).
$string = "$3lab `n" + '-' * $3lab.Length
$string

#5. Sukurkite kintamąjį n = 190. Naudojant kabutes ir duomenų tipo keitimą išveskite:
$n = 190
$tekstas = "`$n = $n, Unicode $n simbolis - $([char]$n)"
$tekstas = '$n = ' + "$n" + ", Unicode $n simbolis - " + [char]$n
$tekstas

#6. Išveskite einamojo aplanko failų ilgių (savybė Length) sąrašą:
#• ilgius išreikškite kilobaitais,
#• surūšiuokite juos mažėjančia tvarka,
#• išveskite pirmus 5 ilgius.
$n = Get-ChildItem -file | Sort-Object {$_.Length} -Descending | Select-Object -ExpandProperty length -First 5
$n | ForEach-Object{$_/1kb}

#7. Sukurkite masyvą a = 1,2, "3",$true
#Išveskite trumpą informaciją apie kiekvieno elemento duomenų tipą (GetType().Fullname) taip,
#kaip parodyta:
$a = 1,2,"3", $true
$a | ForEach-Object {"{0,-4}`t{1}" -f $_, $_.GetType().FullName}

#8. Sukurkite masyvą array, kuriam priskirkite reikšmes nuo 1 iki 5.
#Konvejerio arba metodo pagalba pakeiskite masyvo array reikšmes tų reikšmių kvadratais.
#Išveskite masyvo array reikšmes:
$array = 1..5
$array = $array.ForEach({$_*$_})
$array

#9. Sukurkite Users masyvą su reikšmėmis:
#"Dejuan Lindgren"
#"dejuan_lindgren68@gmail.com"
#"Lloyd Anderson"
#"lloyd_anderson@yahoo.com"
#"Jamie Bednar"
#jamie.bednar25@hotmail.com
#Metodo Where() pagalba sugrupuokite sukurtą masyvą į du masyvus (names ir email):
$Users = "Dejuan Lindgren", "dejuan_lindgren68@gmail.com", "Lloyd Anderson", "lloyd_anderson@yahoo.com", "Jamie Bednar", "jamie.bednar25@hotmail.com"
$Users
$names = $Users.Where({$_ -notlike "*@*"})
$emails = $Users.Where({$_ -like "*@*"})
$names
$emails

#10. Sukurkite maišos lentelę Name_Age. Priskirkite reikšmes:
#Kevin = 36
#Alex = 19
#Deborah = 23
#Brian = 72
#Marie = 40
#Konvejerio pagalba išveskite tekstą:
$name_age = @{}
$name_age["Kevin"]= 36
$name_age["Alex"]= 19
$name_age["Deborah"]= 23
$name_age["Brain"]= 72
$name_age["Marie"]= 40

$name_age.GetEnumerator() | ForEach-Object{"{0} is {1} years old." -f $_.key, $_.value}
