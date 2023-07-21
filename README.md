# REPORT-PROCESS-GRAPH
GENERATE A CLI BASED REPORT GRAPH ABOUT PROCESS IN SELECTED TIME 

get-process | where {$_.company -notmatch "microsoft"} | out-consolegraph -property WorkingSet -cls
