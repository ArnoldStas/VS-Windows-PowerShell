#1. Paleiskite PowerShell konsolę.
POWERSHELL

#2. Sukurkite naują aplanką ir pereikite į jį.
md A

#3. Išveskite visas komandas, prasidedančias žodžiais New, Get, Out.
Get-Command -Name New*, Get*, Out*

#4. Išveskite tik komandletų (cmdlet) sąrašą.
Get-Command -CommandType Cmdlet

#5. Išveskite tik komandletus (cmdlet), kuriuose yra žodis Item. Išveskite komandletų sąrašą į failą item.txt. Išveskite failo item.txt turinį Notepad lange.
Get-Command -CommandType Cmdlet -Name *Item* > item.txt
cat .\item.txt

#6. Išveskite komadleto, kurio slapyvardis cd, vardą.
Get-Alias cd

#7. Išveskite informaciją apie komandą New-Item „Microsoft“ svetainės lange.
Get-Help New-Item -Online

#8. Išveskite komandų, skirtų darbui su slapyvardžiais (Alias), sąrašą
Get-Command -CommandType cmdlet *-Alias*

#9. Sukurkite aplankų DIR1 - DIR5 struktūrą:
md DIR1, DIR2\DIR3, DIR2\DIR4\DIR5

#9.1 Aplanke DIR4 sukurkite failus file1.txt, file2.txt, file3.txt.
cd DIR2\DIR4
New-Item file1.txt, file2.txt, file3.txt

#9.2 Į failą file1.txt įrašykite savo vardą ir pavardę.
Add-Content file1.txt "Arnoldas Stasiūnas"

#9.3 Papildykite failą file1.txt įrašydami datą ir laiką.
Add-Content file1.txt (Get-Date)

#9.4 Išspausdinkite failo file1.txt turinį ekrane.
cat .\file1.txt

#9.5 Perkelkite failus file2.txt ir file3.txt į aplanką DIR1. Komandoje naudokite šabloną [ ].
Move-Item file[2-3].txt -Destination C:\Users\arnol\A\DIR1

#9.6 Nukopijuokite failą file1.txt į aplanką DIR2.
Copy-Item DIR2\DIR4\file1.txt DIR2

#9.7 Išveskite rekursinį visų failų sąrašą.
dir -file -Recurse

#9.8 Išveskite aplankų ir failų medį:
tree /f

#10 Atliktų veiksmų istoriją išsaugokite faile 1lab_history.txt
Get-History > 1lab_history.txt
cat .\1lab_history.txt