#1. Išveskite sąrašą tarnybų (komanda Get-Service), kurių savybės Status reikšmė yra "Stopped"
get-service | where {$_.Status -eq "Stopped"} | Format-List

#2. Išveskite sąrašą tarnybų (komanda Get-Service), kurių savybės Status reikšmė yra "Running" ir vardas prasideda raidėmis Win
Get-Service | where-object {$_.Status -eq "Running" -and $_.Name -like "win*"} | Format-List

#3. Išveskite einamojo aplanko tik failų (be aplankų) sąrašą, surūšiuotą pagal savybę Extension.
cd c:\Windows\System32
dir -file | sort-object Extension | Format-List

#4. Sudarykite procesų sąrašą ir surūšiuokite jį mažėjančia tvarka pagal naudojamą procesoriaus laiką (CPU). Išveskite pirmas penkias reikšmes.
Get-Process | sort-object -Descending CPU | Select-Object -first 5 | Format-list

#5. Sukurkite scenarijų (script), kuris:
#1. Paleidžia Notepad (komanda notepad.exe).
#2. Sukuria konvejerį, kuris:
#Išveda procesų, kurių vardai prasideda raide "n" sąrašą.
#Paklausia ar sutinkate uždaryti sąrašo procesus (klausia apie kiekvieną procesą).
#Sutikite uždaryti procesą vardu "Notepad".

notepad.exe
Get-Process | Where-Object {$_.name -like "n*"}
Get-Process | Where-Object {$_.name -like "n*"} | Stop-Process -confirm

#6. Išveskite informaciją (ProcessName, Id) apie procesus, kurių savybės ProcessName pavadinimas prasideda raidėmis Wmi. Informaciją išveskite kaip sąrašą.
Get-Process | Where-Object {$_.Name -like "Wmi*"} | Format-list Processname, Id 

#7. Išveskite sąrašą failų, kurių ilgis yra > 1000.
cd c:\Windows\System32
dir | Where-Object {$_.Length -gt 1000} | Format-List

#8. Sugrupuokite aplanko failus pagal plėtinį (Extension). Surūšiuokite stulpelio Count reikšmes didėjančia tvarka.
dir | Group-Object Extension | Sort-Object count

#9. Sukurkite failų plėtinių sąrašą. Išveskite tik unikalias plėtinių reikšmes.
dir -file -recurse | Select-Object Extension -unique

#10. Parašykite scenarijų, kuris išveda informaciją apie einamojo aplanko failus:
"Largest file"
dir -file | Sort-Object Length -Descending | Select-Object -First 1 -ExpandProperty Name
(dir -file | Measure-Object Length -Maximum).Maximum
" "
"Smallest file"
dir -file | Sort-Object Length | Select-Object -First 1 -ExpandProperty Name
(dir -file | Measure-Object Length -Minimum).Minimum

#11. Sukurkite konvejerį, kuris: atrenka komandas, kurių tipas yra Cmdlet ir kurie prasideda žodžiu "Update", į update.txt failą išveda atrinktų komandų savybių CommandType ir Name reikšmes:
Get-Command -CommandType Cmdlet | Where-Object {$_.Name -like "Update*"} | Select-Object CommandType, Name | Out-file update.txt
Get-command | Where-object {$_.CommandType -eq "Cmdlet" -and $_.Name -like "Update*"} | Select-object CommandType, Name | Out-File update.txt
cat .\update.txt

#12. Sukurkite konvejerį, kuris: Atrenka komandų istorijos savybę CommandLine; Išveda atrinktas savybes kaip sąrašą (List):
Get-History | Select-Object CommandLine | Format-List

#Atliktų veiksmų istoriją išsaugokite faile 2lab_history.txt
cd "OneDrive - Vilniaus Gedimino technikos universitetas"
cd "Antras kursas VGTU"
cd "Operacinės sistemos - laboratorinis"
Get-History | Select-Object CommandLine | Format-List | Out-file 2lab_history.txt
cat .\2lab_history.txt