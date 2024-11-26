#1.
#Nuskaitykite iš ekrano eilutę skaičių, atskirtų kableliais arba tarpais.
#Paverskite nuskaitytą eilutę sveikųjų (int32) skaičių masyvu.
#Išveskite kiekvieno masyvo elemento duomenų tipą (.GetType().Name).
$array = (Read-Host "Enter an array") -split(",") -split(" ")
$array = [int[]]$array
$array | ForEach-Object {"$_ `t$($_.GetType().Name)"}

#2.
#Išveskite tarnybų (Get-Service) vardų sąrašą.
#Jeigu tarnybos būsena yra "Running", išvedamą eilutę nuspalvinkite žaliai,
#jeigu būsena yra "Stopped" – raudonai baltame fone.
$a = Get-Service
$a | ForEach {
    if ($_.Status -like "Running") {Write-Host $_.Name -ForegroundColor Green}
    else {Write-Host $_.Name -ForegroundColor Red -BackgroundColor White}
}

#3.
#Parašykite scenarijų, kuris paprašo įvesti:
#proceso pavadinimą;
#keliu proceso savybių (Property) vardus (Get-Process | gm, stulpelis Names).
#Išveda procesus su nurodytomis reikšmėmis.
$ProcessName = Read-Host "Enter process name"
$ProcessProperties = (Read-Host "Enter properties") -split(" ")
Get-Process $Processname | Select-Object $ProcessProperties

#4.
#Parašykite scenarijų, kuris patikrina ar Notepad procesas yra paleistas.
#Jeigu procesas paleistas – raudonai išveda atitinkamą pranešima,
#jeigu ne – paleidžia Notepad.
notepad.exe
$np = [bool](Get-Process notepad -ErrorAction SilentlyContinue)
if ($np) {Write-Host "Notepad is running" -ForegroundColor Red}
else {
    notepad.exe
    $np = [bool](Get-Process notepad -ErrorAction SilentlyContinue)
}

#5.
#Sukurkite meniu su raktiniais žodžiais, kuriuos galima rasti komandose (pvz., Variable,
#ExecutionPolicy, Computer).
#Priklausomai nuo pasirinkimo, išveskite:
#Visas komandas, kuriose yra nurodytas raktinis žodis;
#Pranešimą apie netinkamą pasirinkimą.
#Jeigu buvo pasirinktas raktinis žodis, po komandų išvedimo paklauskite, ar reikia išvesti trumpą
#informaciją apie kiekvieną komandą (Get-Help).
#Priklausomai nuo pasirinkimo:
#Išveskite komandų pavadinimus (spalvotai) ir aprašymus;
#Atsisveikinkite.
$menu = @"
    1. Variable
    2. ExecutionPolicy
    3. Computer
       Choose a number
"@

$number = Read-Host $menu

if ($number -eq 1) {
    Write-Host "COMMANDS" -ForegroundColor Cyan -BackgroundColor Gray
    $command = Get-Command *Variable*
    $command
}
elseif ($number -eq 2) {
    Write-Host "COMMANDS" -ForegroundColor Cyan -BackgroundColor Gray
    $command = Get-Command *ExecutionPolicy*
    $command
}
elseif ($number -eq 3) {
    Write-Host "COMMANDS" -ForegroundColor Cyan -BackgroundColor Gray
    $command = Get-Command *Computer*
    $command
}
else {
    Write-Host "Wrong choice!" -ForegroundColor Red
    return
}

:OUTER while($true) {
        $help = Read-Host "`nDo you need Help? (Y/N)"
        Write-Host "`n"
        if ($help -eq "Y") {
            ForEach ($cmd in $command) {
                Write-Host $cmd -BackgroundColor Green
                Get-help $cmd
            }
            break OUTER
        }
        elseif ($help -eq "N") {
            Write-Host "Goodbye!" -ForegroundColor Yellow
            break OUTER
        }
        else {
            Write-Host "Wrong choice! Try again!" -ForegroundColor Red
            continue OUTER
        }
}

#6.
#Sukurkite scenarijų (script), kuris
#randa aplanko tekstinius (.txt) failus, kuriose yra nurodyti žodžiai (pavyzdžiui "file" ir "Mozilla");
#išveda visų tikrintų failų vardus.
$keywords = (Read-Host "Enter the keywords (comma-separated)") -split ',' | ForEach-Object { $_.Trim() }
$directory = Get-Location

foreach ($keyword in $keywords) {
    Get-ChildItem -Path $directory -Filter *.txt | 
    Select-String -Pattern $keyword | 
    Group-Object Path | 
    ForEach-Object {
        Write-Host ($_.Name -split '\\')[-1] -ForegroundColor Cyan
        Write-Host ""
        $_.Group | ForEach-Object { Write-Host $_.Line }
        Write-Host ""
    }
}

#7.
#Sukurkite scenarijų (script), kuris:
#atrenka failo names.txt eilutes, kuriose yra žodžiai gmail.com arba verizon.net;
#išveda atrinktų eilučių eilės numerius (eilutės numeruojamos nuo 0).
$path = "C:\PowerShell\names.txt"
$array = @()
$array = Get-Content $path -Force
$array

Write-Host "gmail.com" -ForegroundColor Cyan
$gmail = @()
for ($i = 0; $i -lt $array.Length; $i++) {
    if ($array[$i] -like "*gmail.com*") {
        $gmail = $gmail + $i
    }
}
$gmail

Write-Host "`nverizon.net" -ForegroundColor Cyan
$verizon = @()
for ($i = 0; $i -lt $array.Length; $i++) {
    if ($array[$i] -like "*verizon.net*") {
        $verizon = $verizon + $i
    }
}
$verizon

#8.
#Sukurkite scenarijų (script), kuris:
#leidžia nuskaityti skaičius iš ekrano;
#nustato kiek vienodų skaičių buvo įvesta;
#ignoruoja tuščias eilutes;
#išveda rezultatą kaip parodyta.
$a = "Enter number (Press X to Quit)"
Write-Host $a
$RealArray = @()
$NumberArray = @()
:OUTER while ($true)
{
    $skaicius = Read-Host
    if ($skaicius -like "X") {
        break OUTER
    }
    else {
        if ($skaicius -ne "") {
        $RealArray = $RealArray + $skaicius
        if ($NumberArray -notcontains $skaicius) {
            $NumberArray = $NumberArray + $skaicius
        }
      }
    }
}

if ($RealArray.Length -gt 0) {Write-Host "`n------------------------------`n"}

$NumberArray = $NumberArray | Sort-Object {[int]$_}
$count = 0;
for ($i = 0; $i -lt $NumberArray.Length; $i++)
{
    $h = $i
    for ($j = 0; $j -lt $RealArray.Length; $j++)
    {
        if ($NumberArray[$i] -eq $RealArray[$j]) {
            $count = $count + 1
        }
    }
    Write-Host ("{0,5}: {1}" -f $NumberArray[$h], $count)
    $count = 0
}

#9.
#Sukurkite scenarijų (script), kuris atlieka veiksmus su einamojo aplanko tekstiniais (.txt) failais:
#Išveda failo vardą ekrane;
#Išveda meniu, kuris:
#Leidžia išvesti failo turinį ekrane;
#Leidžia ištrinti failą (Remove-Item arba del), jeigu vartotojas sutinka.
#Leidžia pereiti prie sekančio failo;
#Leidžia baigti darbą.
#Išveda pranešimą apie netinkamą pasirinkimą.
$files = @()
$r = dir -file *.txt
$files = $files + $r

$menu = @"
`n
1. File will be displayed
2. File will be deleted
3. Next file
4. Exit
Select a command
"@

$count = 0
$count1
:OUTER while ($count -lt $files.Length)
{
    if ($count1 -ne $count) {
        Write-Host $files[$count].Name -ForegroundColor Magenta
    }
    $count1 = $count
    $choice = Read-Host $menu

    if ($choice -eq 1) {
        Write-Host "`nFile contents`n" -ForegroundColor Cyan
        Get-Content $files[$count]
        continue OUTER
    }
    elseif ($choice -eq 2) {
        Write-Host "`nFile will be deleted`n" -ForegroundColor Cyan
        Remove-item $files[$count] -Confirm
        $count = $count + 1
        continue OUTER
    }
    elseif ($choice -eq 3) {
        $count = $count + 1
        continue OUTER
    }
    elseif ($choice -eq 4) {
        return
    }
    else {
        Write-Host "`nInvalid Entry" -ForegroundColor Red
    }
}