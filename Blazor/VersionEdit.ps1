#Pfad
$fullProjectPath = (Get-ChildItem -Include *.csproj -Recurse | Select-Object FullName).FullName #Projektdatei suchen

#.csproj
if (Test-Path $fullProjectPath) 
{
    [xml]$xml = Get-Content $fullProjectPath #File öffnen

    #Version suchen und ersetzen
    foreach ($propertyGroup in $xml.Project.PropertyGroup)
    {
        if ($propertyGroup.AssemblyVersion -and $propertyGroup.FileVersion)
        {
            $oldVersion = $propertyGroup.AssemblyVersion #Alte Version auslesen
            $newVersion = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen
            $propertyGroup.AssemblyVersion = $newVersion
            $propertyGroup.FileVersion = $newVersion
        }
    }
    $xml.Save($fullProjectPath)
}

#In Git erneut hinzufügen
git add $fullProjectPath

#Temp .commit erstellen
Out-File ".commit" -Force