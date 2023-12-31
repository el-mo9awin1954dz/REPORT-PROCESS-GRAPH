Function Out-ConsoleGraph {

#comment based help goes here

[cmdletbinding()]
Param (
[parameter(Position=0,ValueFromPipeline=$True)]
[object]$Inputobject,
[parameter(Mandatory=$True,HelpMessage="Enter a property name to graph")]
[ValidateNotNullorEmpty()]
[string]$Property,
[string]$CaptionProperty="Name",
[string]$Title="$Property Report - $(Get-Date)",
[ValidateNotNullorEmpty()]
[System.ConsoleColor]$GraphColor="Green",
[alias("cls")]
[switch]$ClearScreen
)

Begin {
    Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  
    #get the current window width so that our lines will be proportional
    $Width = $Host.UI.RawUI.BufferSize.Width
    Write-Verbose "Width = $Width"
    
    #initialize an array to hold data
    $data=@()
} #begin

Process {
    #get the data
    $data += $Inputobject

} #end process

End {
    #get largest property value
    Write-Verbose "Getting largest value for $property"
    Try {
        $largest = $data | sort $property | Select -ExpandProperty $property -last 1 -ErrorAction Stop
        Write-Verbose $largest
    }
    Catch {
        Write-Warning "Failed to find property $property"
        Return
    }
    If ($largest) {
        #get length of longest object property used for the caption so we can pad
        #This must be a string so we can get the length
        Write-Verbose "Getting longest value for $CaptionProperty"
        $sample = $data |Sort @{Expression={($_.$CaptionProperty -as [string]).Length}} |
        Select -last 1
        Write-Verbose ($sample | out-string)
        [int]$longest = ($sample.$CaptionProperty).ToString().length
        Write-Verbose "Longest caption is $longest"

        #get remaining available window width, dividing by 100 to get a 
        #proportional width. Subtract 4 to add a little margin.
        $available = ($width-$longest-4)/100
        Write-Verbose "Available value is $available"
    
        if ($ClearScreen) {
            Clear-Host
        }
        Write-Host "$Title`n"
        foreach ($obj in $data) {
            #define the caption
            [string]$caption = $obj.$captionProperty

            <#
             calculate the current property as a percentage of the largest 
             property in the set. Then multiply by the remaining window width
            #>
            if ($obj.$property -eq 0) {
                #if property is actually 0 then don't display anything for the graph
                [int]$graph=0
            }
            else {
                $graph = (($obj.$property)/$largest)*100*$available
            }
            if ($graph -ge 2) {
                [string]$g=[char]9608
            }
            elseif ($graph -gt 0 -AND $graph -le 1) {
                #if graph value is >0 and <1 then use a short graph character
                [string]$g=[char]9612
                #adjust the value so something will be displayed
                $graph=1
            }
            
            Write-Verbose "Graph value is $graph"
            Write-Verbose "Property value is $($obj.$property)"
            Write-Host $caption.PadRight($longest) -NoNewline
            #add some padding between the caption and the graph
            Write-Host "  " -NoNewline
            Write-Host ($g*$graph) -ForegroundColor $GraphColor
        } #foreach
           #add a blank line
           Write-Host `n
    } #if $largest
    Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
} #end

} #end Out-ConsoleGraph
