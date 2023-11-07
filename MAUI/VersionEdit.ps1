#Pfad
$fullProjectPath = (Get-ChildItem -Include *.csproj -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
$projectFile = $fullProjectPath + "\" + (Get-ChildItem -Include *.csproj -Recurse | Select-Object Name).Name #Projektdatei herausfinden

#Windows
$assemblyPathWindows = "$fullProjectPath\Platforms\Windows\app.manifest" #Pfad zum app.manifest
$packagePathWindows = "$fullProjectPath\Platforms\Windows\Package.appxmanifest" #Pfad zum Package.appxmanifest

#Android
$androidManifest = "$fullProjectPath\Platforms\Android\AndroidManifest.xml" #Pfad zum AndroidManifest.xml

#iOS
#$iosPlist = "$fullProjectPath\Platforms\iOS\Info.plist" #Pfad zum Info.plist



### Windows ###

#app.manifest
if (Test-Path $assemblyPathWindows) 
{
    [xml]$xml = Get-Content $assemblyPathWindows #File öffnen

    #Version suchen und ersetzen
    $oldVersion = $xml.assembly.assemblyIdentity.version #Alte Version auslesen
    $xml.assembly.assemblyIdentity.version = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen
    $xml.Save($assemblyPathWindows)
}

#Package.appxmanifest
if (Test-Path $packagePathWindows) 
{
    [xml]$xml = Get-Content $packagePathWindows #File öffnen

    #Version suchen und ersetzen
    $oldVersion = $xml.Package.Identity.Version #Alte Version auslesen
    $xml.Package.Identity.Version = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen
    $xml.Save($packagePathWindows)
}


### Android ###
$applicationVersion = 0 #Variabel für Version des Android Projekts
if (Test-Path $androidManifest) 
{
    [xml]$xml = Get-Content $androidManifest #File öffnen

    #Version suchen und ersetzen
    $oldVersion = $xml.manifest.GetAttribute("versionName", "http://schemas.android.com/apk/res/android") #Alte Version auslesen
    $newVersion = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen
    $applicationVersion = [int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1
    $xml.manifest.SetAttribute("versionName", "http://schemas.android.com/apk/res/android", $newVersion)
    $xml.manifest.SetAttribute("versionCode", "http://schemas.android.com/apk/res/android", $applicationVersion)
    $xml.Save($androidManifest)
}

#Android VersionCode erhöhen in .csproj
if (Test-Path $projectFile) 
{
    # Open the file with UTF8 encoding
    $content = Get-Content $projectFile -Encoding UTF8

    # Find the text <ApplicationVersion>2</ApplicationVersion> and replace the number with the value of $applicationVersion
    $content = $content -replace '(<ApplicationVersion>)\d+(</ApplicationVersion>)', "`${1}$applicationVersion`$2"

    # Save the file with UTF8 encoding and BOM
    [System.IO.File]::WriteAllLines($projectFile, $content, [System.Text.Encoding]::UTF8)
}


### iOS ### Nicht implementiert, weil zu kompliziert
<#
if (Test-Path $iosPlist) 
{
    [xml]$xml = Get-Content $iosPlist #File öffnen

    # Aktuellen Wert von CFBundleShortVersionString auslesen
    $oldVersion = $plist.plist.dict.key | Where-Object { $_.InnerText -eq "CFBundleShortVersionString" }
    $currentVersion = $oldVersion.GetElementsByTagName("string").InnerText

    # Die aktuelle Version in ihre Teile aufteilen
    $versionParts = $oldVersion -split '\.'

    # Die letzte Komponente der Version erhöhen (Annahme, dass es immer eine numerische Komponente ist)
    $lastComponent = [int]$versionParts[-1]
    $lastComponent++
    $versionParts[-1] = $lastComponent.ToString()

    # Die neue Version zusammensetzen
    $newVersion = $versionParts -join '.'

    # Den aktualisierten Wert für CFBundleShortVersionString setzen
    $xml.plist.dict.CFBundleShortVersionString = $newVersion

    # Die Änderungen speichern
    $xml.Save($plistPath)
}
#>

#In Git erneut hinzufügen
git add $assemblyPathWindows
git add $packagePathWindows
git add $androidManifest
git add $projectFile
#git add $iosPlist

#Temp .commit erstellen
Out-File ".commit" -Force