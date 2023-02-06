Start-Transcript "C:\Users\gstancu\OneDrive - ENDAVA\Documents\Firewall.txt"

Write-Output "Creare fisiere JSON..."
$rules = Get-NetFirewallRule
for ($i = 0; $i -lt $rules.Length; $i++)
{ 
       try
       {
           $rules[$i] | Select-Object -Property * | ConvertTo-JSON > "C:\Users\gstancu\folderJSON\$($rules[$i].Name).JSON"
       }
       catch
       {
           $string = -join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_})
           $rules[$i] | Select-Object -Property * | ConvertTo-JSON > "C:\Users\gstancu\folderJSON\$string.JSON"
       }
}

$files = Get-ChildItem -File -Recurse -Path C:\Users\gstancu\folderJSON

Write-Output "Numar de fisiere JSON create si numarul total de linii JSON:"
($files | foreach {Get-Content $_ | Measure-Object -Line}).Lines | Measure-Object -Sum 

Write-Output "Numar de fisiere JSON ce contin UDP in denumire:"
($files | Where-Object {$_.Name -like "*UDP*"} | Measure-Object).Count

Write-Output "Numar de fisiere JSON ce contin TCP in denumire:"
($files | Where-Object {$_.Name -like "*TCP*"} | Measure-Object).Count

Write-Output "Numar de linii JSON ce contin { sau }:"
(($files | foreach {Get-Content $_.Name  | Select-String -Pattern "[{}]" -Encoding ASCII | Measure-Object -Line}).Lines | Measure-Object -Sum).Sum

Write-Output "Timpul de executie al ultimei comenzi in milisecunde:"
(Measure-Command { (($files | foreach {Get-Content $_.Name  | Select-String -Pattern "[{}]" -Encoding ASCII | Measure-Object -Line}).Lines | Measure-Object -Sum).Sum }).Milliseconds

Stop-Transcript