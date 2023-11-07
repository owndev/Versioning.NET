#Pfad
$fullProjectPath = (Get-ChildItem -Include find.me -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
$assemblyPath = "$fullProjectPath\app.manifest" #Pfad zum app.manifest
$packagePath = "$fullProjectPath\Package.appxmanifest" #Pfad zum Package.appxmanifest

#app.manifest
if (Test-Path $assemblyPath) 
{
    [xml]$xml = Get-Content $assemblyPath #File öffnen

    #Version suchen und ersetzen
    $oldVersion = $xml.assembly.assemblyIdentity.version #Alte Version auslesen
    $xml.assembly.assemblyIdentity.version = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen
    $xml.Save($assemblyPath)
}

#Package.appxmanifest
if (Test-Path $packagePath) 
{
    [xml]$xml = Get-Content $packagePath #File öffnen

    #Version suchen und ersetzen
    $oldVersion = $xml.Package.Identity.Version #Alte Version auslesen
    $xml.Package.Identity.Version = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen
    $xml.Save($packagePath)
}

#In Git erneut hinzufügen
git add $assemblyPath
git add $packagePath

#Temp .commit erstellen
Out-File ".commit" -Force