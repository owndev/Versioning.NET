#Uno Platform

#Pfad zu Mobile
$fullProjectPath = (Get-ChildItem -Include find.me.mobile -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
$androidManifestPath = "$fullProjectPath\Android\AndroidManifest.xml" #Pfad zum AndroidManifest.cs
$unoPlatformMobileProject = Get-ChildItem -Path $fullProjectPath -Filter *.csproj -Recurse | Select-Object -First 1
$unoPlatformMobileProjectPath = "$fullProjectPath\$unoPlatformMobileProject"

#Version in AndroidManifest.xml ändern
$manifest = Get-Content $androidManifestPath
$version = [regex]::Match($manifest, 'android:versionName="([\d\.]+)"').Groups[1].Value
$versionParts = $version -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newVersion = $versionParts -join '.'
$newManifest = $manifest -replace ('android:versionName="([\d\.]+)"', "android:versionName=`"$newVersion`"")
$newManifest | Set-Content $androidManifestPath

#Version in Uno Platform Mobile Hauptprojekt ändern
$project = Get-Content $unoPlatformMobileProjectPath

$assemblyVersion = [regex]::Match($project, '<AssemblyVersion>([\d\.]+)</AssemblyVersion>').Groups[1].Value
$fileVersion = [regex]::Match($project, '<FileVersion>([\d\.]+)</FileVersion>').Groups[1].Value
$version = [regex]::Match($project, '<Version>([\d\.]+)</Version>').Groups[1].Value

$versionParts = $assemblyVersion -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newAssemblyVersion = $versionParts -join '.'

$versionParts = $fileVersion -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newFileVersion = $versionParts -join '.'

$versionParts = $version -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newVersion = $versionParts -join '.'

$newProject = $project -replace ('<AssemblyVersion>([\d\.]+)</AssemblyVersion>', "<AssemblyVersion>$newAssemblyVersion</AssemblyVersion>")
$newProject = $newProject -replace ('<FileVersion>([\d\.]+)</FileVersion>', "<FileVersion>$newFileVersion</FileVersion>")
$newProject = $newProject -replace ('<Version>([\d\.]+)</Version>', "<Version>$newVersion</Version>")

$newProject | Set-Content $unoPlatformMobileProjectPath


#Pfad Hauptprojekt
$fullProjectPath = (Get-ChildItem -Include find.me -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
$unoPlatformProject = Get-ChildItem -Path $fullProjectPath -Filter *.csproj -Recurse | Select-Object -First 1
$unoPlatformProjectPath = "$fullProjectPath\$unoPlatformProject"

#Version in Uno Platform Hauptprojekt ändern
$project = Get-Content $unoPlatformProjectPath

$assemblyVersion = [regex]::Match($project, '<AssemblyVersion>([\d\.]+)</AssemblyVersion>').Groups[1].Value
$fileVersion = [regex]::Match($project, '<FileVersion>([\d\.]+)</FileVersion>').Groups[1].Value
$version = [regex]::Match($project, '<Version>([\d\.]+)</Version>').Groups[1].Value

$versionParts = $assemblyVersion -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newAssemblyVersion = $versionParts -join '.'

$versionParts = $fileVersion -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newFileVersion = $versionParts -join '.'

$versionParts = $version -split '\.'
$lastPart = [int]$versionParts[-1]
$lastPart++
$versionParts[-1] = $lastPart.ToString()
$newVersion = $versionParts -join '.'

$newProject = $project -replace ('<AssemblyVersion>([\d\.]+)</AssemblyVersion>', "<AssemblyVersion>$newAssemblyVersion</AssemblyVersion>")
$newProject = $newProject -replace ('<FileVersion>([\d\.]+)</FileVersion>', "<FileVersion>$newFileVersion</FileVersion>")
$newProject = $newProject -replace ('<Version>([\d\.]+)</Version>', "<Version>$newVersion</Version>")

$newProject | Set-Content $unoPlatformProjectPath

#In Git erneut hinzufügen
git add $androidManifestPath
git add $unoPlatformMobileProjectPath
git add $unoPlatformProjectPath

#Temp .commit erstellen
Out-File ".commit" -Force