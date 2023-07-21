# REPORT-PROCESS-GRAPH
GENERATE A CLI BASED REPORT GRAPH ABOUT PROCESS IN SELECTED TIME 

get-process | where {$_.company -notmatch "microsoft"} | out-consolegraph -property WorkingSet -cls

Get-ChildItem C:\Scripts -Directory | foreach {
  $data = Get-ChildItem $_.FullName -Recurse -File | Measure-Object -Property Length -sum
  $_ | Select Name,@{Name="Size";Expression={$data.sum}}
} | Out-ConsoleGraph -Property Size -Title "Scripts Folder Report" -GraphColor Cyan



