param ($commitPath) #Übergabeparameter -> ".\.git\COMMIT_EDITMSG"

#Pfad
$readmePath = ".\README.md" #Pfad zur README.md
$releasenotesPath = ".\releasenotes.txt" #Pfad zur releasenotes.txt
$fullProjectPath = (Get-ChildItem -Include find.me -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
$assemblyPath = "$fullProjectPath\Properties\AssemblyInfo.cs" #Pfad zum AssemblyInfo.cs

$file = Get-Content $assemblyPath #File öffnen

#Version holen
for ($i = 0; $i -lt $file.Length; $i++)
{
    #AssemblyVersion holen
    if ($file[$i].Contains("AssemblyVersion") -and !$file[$i].Contains("//"))
    {
        $oldLine = $file[$i]

        #Version ausslesen
        $oldVersion = $oldLine.Substring($oldLine.IndexOf('"') + 1, $oldLine.LastIndexOf('"') - $oldLine.IndexOf('"') - 1) #Alte Version auslesen
        $newVersion = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1)) #Neue Version erstellen
    }
}

#Commit-Message
$commitFile = Get-Content $commitPath -Encoding utf8 #File öffnen

#Version in Commit schreiben
$newCommitFile = "V" + $newVersion + " - " + $commitFile
$newCommitFile | Out-File $commitPath -Encoding utf8 -Force #Commit File schreiben

#Version in README schreiben
$readmeFile = Get-Content $readmePath -Encoding utf8 #File öffnen

$newReadmeFile = @() #Array erstellen

$versions = @() #Array erstellen
$isInVersion = $false #Variable für die Erkennung ob im Versionsbereich

#Suchen und hinzufügen der Version
for ($i = 0; $i -lt $readmeFile.Length; $i++)
{
    $newReadmeFile += $readmeFile[$i]
    if ($readmeFile[$i].Contains("# Buildversion"))
    {
        $isInVersion = $true

        #Tabellen Header schreiben
        $newReadmeFile += "| Version | Release Notes |"
        $newReadmeFile += "|--|--|"
        $newLine = "| " + $newVersion + " | " + $commitFile + " |"
        $newReadmeFile += $newLine

        #Versionsnummern in Array speichern
        $versions += "# Buildversion"
        $versions += "| Version | Release Notes |"
        $versions += "|--|--|"
        $versions += $newLine

        #Index hochzählen
        $i += 2
    }

    else 
    {
        #Versionsbereich ist bei nächster Überschrift fertig
        if($isInVersion -and $readmeFile[$i].Contains("#"))
        {
            $isInVersion = $false
        }

        #Alle Versionen in releasenotes schreiben
        if($isInVersion)
        {
            $versions += $readmeFile[$i]
        }
    }    
}
$newReadmeFile | Out-File $readmePath -Encoding utf8 -Force #Readme File schreiben

#releasenotes.txt schreiben
if ($versions.Length -gt 0)
{
    $versions | Out-File $releasenotesPath -Encoding utf8 -Force
}
#Nur die aktuelle Version einfügen
else
{
    $versionNoReadme = @() #Array erstellen
    $versionNoReadme += "# Buildversion"
    $versionNoReadme += "| Version | Release Notes |"
    $versionNoReadme += "|--|--|"
    $versionNoReadme += "| " + $newVersion + " | " + $commitFile + " |"
    $versionNoReadme | Out-File $releasenotesPath -Encoding utf8 -Force
}
