cd $PSScriptRoot
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
function Test-RegistryKeyValue
{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        # The path to the registry key where the value should be set.  Will be created if it doesn't exist.
        $Path,

        [Parameter(Mandatory=$true)]
        [string]
        # The name of the value being set.
        $Name
    )

    if( -not (Test-Path -Path $Path -PathType Container) )
    {
        return $false
    }

    $properties = Get-ItemProperty -Path $Path 
    if( -not $properties )
    {
        return $false
    }

    $member = Get-Member -InputObject $properties -Name $Name
    if( $member )
    {
        return $true
    }
    else
    {
        return $false
    }

}

function Show-Menu
{
     param (
           [string]$Title = 'My Menu'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "0: Press '0' to download the necessary files."
     Write-Host "1: Press '1' to export your current video registry."
     Write-Host "2: Press '2' to run display driver uninstaller."
     Write-Host "3: Press '3' to Disable Ulps and DisableCrossFireAutoLink."
     Write-Host "4: Press '4' to import powerplay tables. (Make sure to edit 'VegaPowerPlayTable.txt'. Do not modify ZZzz.)"
     Write-Host "5: Press '5' to set Overdrive profile for Vegas."
     Write-Host "6: Press '6' to disable and re-enable all Vegas."
     Write-Host "7: Press '7' to run cast-xmr."
     Write-Host "Q: Press 'Q' to quit."
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '0' {
                cls
                'You chose option #0: Download necessary files.'
                $confirmation = Read-Host "Are you sure you want to download the files? (Y/N):"
                    if ($confirmation -eq 'y') {
                    New-Item -ItemType Directory -Force -Path Downloads
                           Get-Content downloads.txt | Foreach-Object {Write-Host $_; $filename = $_ -replace '\[','' -replace '\]','' | Split-Path -Leaf; Invoke-WebRequest -Uri "$_" -OutFile "Downloads\$filename"}

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip $PSScriptRoot\Downloads\7za920.zip $PSScriptRoot\Downloads\.

Downloads\7za.exe x Downloads\*.zip -oTools\* -r -aou
Downloads\7za.exe x Downloads\*.7z -oTools\* -r -aou


Downloads\7za.exe x Tools\Guru*\*.exe -oTools\* -r -aou
$webconfirmation = Read-Host "Type Y and hit enter to open the AMD website to download the blockchain drivers."
                    if ($webconfirmation -eq 'y') {
                       Start-Process -FilePath "http://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-Crimson-ReLive-Edition-Beta-for-Blockchain-Compute-Release-Notes.aspx"   
                       
                    Write-host "After download is complete, run the EXE file and install the AMD drivers."

                    }



                    }
           } '1' {
                cls
                'You chose option #1: Export current video registry settings.'
                $confirmation = Read-Host "Are you sure you want to export current video registry settings? (Y/N):"
                    if ($confirmation -eq 'y') {
                           $filename = "VideoRegistryBackup$(Get-Date -UFormat "%m-%d-%Y %I-%M-%S").reg"
                           New-Item -ItemType Directory -Force -Path RegFiles
                          $regexport = Reg export "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" $PSScriptRoot\regfiles\$filename
                          if ($regexport -like 'The operation completed successfully.')
{
"Your file has been saved as $filename"
}
else
{
  "The registry backup failed. Error message is: $regexport"
}
                    }
           } '2' {
                cls
                "You chose option #2: Run display driver uninstaller."

                $confirmation = Read-Host "Are you sure you want to run display driver uninstaller? (Y/N):"
                    if ($confirmation -eq 'y') {
                            cd Tools\DDU*
                            cmd.exe /c “Display Driver Uninstaller.exe" -silent -restart -cleanamd
                    }
                
           } '3' {
                cls
                'You chose option #3: Disable Ulps and DisableCrossFireAutoLink'
                $confirmation = Read-Host "Are you Sure You Want To Disable Ulps and DisableCrossFireAutoLink? (Y/N):"
                    if ($confirmation -eq 'y') {
                    $videocards = Get-ChildItem "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -ErrorAction Ignore | select -ExpandProperty Name
$registrychanges = 0 
Foreach ($videocard in $videocards) {
	$cardnumber = ""
	$cardnumber = ($videocard -split "{4d36e968-e325-11ce-bfc1-08002be10318}")[1]
	$cardpath = ""
	$cardpath = Test-RegistryKeyValue -Path "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}$cardnumber" -Name 'EnableUlps'
	
	if ($cardpath -eq 'True') { Set-ItemProperty -Path "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}$cardnumber" -Name EnableUlps -Value 0; 
                                Set-ItemProperty -Path "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}$cardnumber" -Name EnableCrossFireAutoLink -Value 0
                                $registrychanges++
                              } ;
	}
    "$registrychanges cards' registry settings were modified."
                    }



           } '4' {
                cls
                'You chose option #4: Import powerplay tables. (Make sure to edit "VegaPowerPlayTable.txt". Do not modify ZZzz.)'
                $confirmation = Read-Host "Are you sure you want to import powerplay tables from 'VegaPowerPlayTable.txt? (Y/N):"
                    if ($confirmation -eq 'y') {
                    $powerplaytable = (Get-Content $PSScriptRoot\VegaPowerPlayTable.txt )
                    $videocards = Get-ChildItem "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -ErrorAction Ignore | select -ExpandProperty Name
$registrychanges = 0 
Foreach ($videocard in $videocards) {
	$cardnumber = ""
	$cardnumber = ($videocard -split "{4d36e968-e325-11ce-bfc1-08002be10318}")[1]
	$cardpath = ""
	$cardpath = Test-RegistryKeyValue -Path "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}$cardnumber" -Name 'EnableUlps'
	
	if ($cardpath -eq 'True') { $powerplaytable.Replace('ZZzz',$cardnumber) | Out-File $PSScriptRoot\regfiles\$cardnumber.reg
                                regedit /s $PSScriptRoot\regfiles\$cardnumber.reg
                                $registrychanges++
                              } ;
	}
    "$registrychanges cards' registry settings were modified."
                    }



           } '5' {
                cls
                'You chose option #5: Set Overdrive profile for Vegas.'

                    cd $PSScriptRoot\tools\overdrive*
                    cp ..\..\overdriventool.ini .\
                    $overdriveini = (Get-Content OverdriveNTool.ini)
                    $overdriveprofiles = (Get-Content OverdriveNTool.ini | Where-Object { $_.Contains("Name=") } | foreach {$_ -replace 'Name=', ''})
                    
                    
                    

$menu = @{}
for ($i=1;$i -le $overdriveprofiles.count; $i++) 
{ Write-Host "$i. $($overdriveprofiles[$i-1])" 
$menu.Add($i,($overdriveprofiles[$i-1]))}
[int]$ans = Read-Host 'Enter selection'
$selection = $menu.Item($ans) ; 


$pattern = "Name=$selection(.*?)\[Profile_"
$string = Get-Content OverdriveNTool.ini
$selectionsettings = [regex]::match($string, $pattern).Groups[1].Value
$selectionsettings = $selectionsettings -replace ' ',"`r`n"
$selectionsettings
if ($selectionsettings -eq '') {
    $pattern = "Name=$selection(.*)"
$string = Get-Content OverdriveNTool.ini
$selectionsettings = [regex]::match($string, $pattern).Groups[1].Value
$selectionsettings = $selectionsettings -replace ' ',"`r`n"
$selectionsettings
}
$confirmation = Read-Host "Are you sure you want to Set Overdrive profile $selection for all Vegas? (Y/N):"



                    if ($confirmation -eq 'y') {
$cmd = ''
$videocards = Get-WmiObject Win32_VideoController | select -ExpandProperty Name
$count = $videocards | measure

$cardchanges = 0 
For ($i=0; $i -le $count.Count; $i++) {
    
    if ($videocards[$i] -eq 'Radeon RX Vega') { $cardchanges++; $cmd = $cmd + ' -r' + $i + ' -p' + $i + $selection;} ;
    }
$cmd
$cmd = "OverdriveNTool.exe $cmd"

cmd.exe /c $cmd
	                "$cardchanges cards' settings were modified to the profile $selection"
           }

                    


           } '6' {
                cls
                "You chose option #6: Disable and re-enable all Vegas."

                $confirmation = Read-Host "Are you sure you want to disable and re-enable all Vegas? (Y/N):"
                    if ($confirmation -eq 'y') {
                    cd $PSScriptRoot\tools\devman*
                            $cmd1 = 'DevManView.exe /disable "PCI\VEN_1002&DEV_687F&*" /use_wildcard'
                            $cmd2 = 'TIMEOUT 5'
                            $cmd3 = 'DevManView.exe /enable "PCI\VEN_1002&DEV_687F&*" /use_wildcard'
                            $cmd1
                            $cmd2
                            $cmd3
                            cmd.exe /c $cmd1
                            cmd.exe /c $cmd2
                            cmd.exe /c $cmd3 
                    }
                
           } '7' {
                cls
                "You chose option #7: Run cast-xmr."
                
                $confirmation = Read-Host "Are you sure you want to run cast-xmr? (Y/N):"
                    if ($confirmation -eq 'y') {
                    cd $PSScriptRoot\tools\cast*
                    $cardlist = ""
                    $videocards = Get-ChildItem "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -ErrorAction Ignore | select -ExpandProperty Name
                    $cardlistarray = @()
                    $cardindex = 0
                    $cardindexarray = @()
Foreach ($videocard in $videocards) {
	$cardnumber = ""
	$cardnumber = ($videocard -split '{4d36e968-e325-11ce-bfc1-08002be10318}\\')[1]
	$cardpath = ""
	$cardpath = Test-RegistryKeyValue -Path "hklm:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\$cardnumber" -Name 'EnableUlps'
	
	if ($cardpath -eq 'True') { $cardlistarray += ,$cardnumber; $cardindexarray += ,$cardindex; $cardindex++ 
                              } ;
	}
        $ofs = ','
        $cardlist = "$cardlistarray"
        $cardindexes = "$cardindexarray"


        Get-Content ..\..\castxmr_settings.txt | foreach { 
if($_ -match "wallet:") {$wallet = ($_ -split "wallet:")[1]} 
if($_ -match "pooladdress:") {$pooladdress = ($_ -split "pooladdress:")[1]} 
if($_ -match "poolpassword:") {$poolpassword = ($_ -split "poolpassword:")[1]} 
}
        $xmrcastcommand = "cast_xmr-vega -G $cardindexes -S $pooladdress -u $wallet -p $poolpassword %*"
        write-host $xmrcastcommand
                            cmd.exe /c $xmrcastcommand

                    }
                
           } 

           
           'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')