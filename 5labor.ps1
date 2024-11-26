#1.
#Atskirti failo data.txt stulpelius kableliais/kabliataškiais ir rezultatą įrašyti į failą data.csv.
$line = (cat .\data.txt) -replace "\s+", ';' | set-content data.csv
$line

#2.
#Sukurkite scenarijų (script), kuris:
#a) failą res.txt paverčia .csv failu;
#b) atrenka eilutes, kuriose PING TEST reikšmė nėra GOOD ir išveda rezultatą į kitą .csv failą
$pf = (cat .\res.txt) -replace ',', ';' | set-content res.csv
$pf
$atr = (cat .\res.txt) -notmatch "PING TEST: GOOD" -replace ',', ';' | set-content resfixed.csv
$atr

#3.
#Komandleto Select-String pagalba iš failų names.txt ir contacts.txt atrinkti ir išvesti unikalius e-pašto
#adresus
Get-Content .\contacts.txt
Get-Content .\names.txt

$emails = Get-Content .\names.txt | Select-String -Pattern "[A-Za-z0-9]+@[A-Za-z0-9]+.[A-Za-z]{3}"
$emails += Get-Content .\contacts.txt | Select-String -Pattern "[A-Za-z0-9]+@[A-Za-z0-9]+.[A-Za-z]{3}"
$emails

$uniqueEmails = $emails.Matches.Value | Sort-Object -Unique
$uniqueEmails

Get-Content .\names.txt | Select-String -Pattern "[A-Za-z0-9]+@[A-Za-z0-9]+.[A-Za-z]{3}"

$emails = (cat .\names.txt) | Select-String -Pattern "\b[A-Za-z0-9+-_%]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}"
$emails += (cat .\contacts.txt) | Select-String -Pattern "\b[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b"
$uniqueEmails = $emails.Matches.Value | Sort-Object -Unique
$uniqueEmails						

#4.
#Sukurkite scenarijų (script), kuris išveda failo names.txt turinį kaip parodyta:
$name = (cat ./names.txt) | Select-String -Pattern "\b([A-Za-z]+\s*)+\b"
$phone =  (cat ./names.txt) | Select-String -Pattern '\(?[0-9)]+-[0-9]{3}-[0-9]+'
$email = (cat ./names.txt) | Select-String -Pattern "\b[A-Za-z0-9+-_%]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}"
$i = 0
$name | ForEach-Object {
    $i
    "NAME:   "+$_.Matches.Value
    "PHONE:  "+$phone.Matches.value.GetValue($i)
    "EMAIL:  "+$email.Matches.Value.GetValue($i)
    $i=$i+1
    "`n"
}					

#5.
#Duotas masyvas $arr = "08:30:00#10-03-2022","10:20:05#10-30-2022","12:10:15#12-01-2022" .
#Parašykite komandų konvejerį, kuris pakeičia masyvo elementus ir išveda juos [datetime] formatu.
$arr = "08:30:00#10-03-2022","10:20:05#10-30-2022","12:10:15#12-01-2022"
$arr | ForEach-Object{
    $time = $_ -split "#"
    get-date "$($time[1]) $($time[0])"

}						
#6.Parašykite scenarijų (script), kuris iš failo info.txt atrenka miestų pavadinimus ir pašto kodus ir išveda kaip parodyta:							
$address = cat .\info.txt | Select-String -Pattern "\b[A-Za-z\s]+,\s[A-Z]{2}\s\d{5}\b"							
$address.Matches.Value