#Pfad
$fullProjectPath = (Get-ChildItem -Include find.me.android -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
$assemblyPath = "$fullProjectPath\Properties\AssemblyInfo.cs" #Pfad zum AssemblyInfo.cs
$file = Get-Content $assemblyPath #File öffnen

#Version suchen und ersetzen
for ($i = 0; $i -lt $file.Length; $i++)
{
    #AssemblyVersion
    if ($file[$i].Contains("AssemblyVersion") -and !$file[$i].Contains("//"))
    {
        $oldLine = $file[$i]

        #Version erstellen
        $oldVersion = $oldLine.Substring($oldLine.IndexOf('"') + 1, $oldLine.LastIndexOf('"') - $oldLine.IndexOf('"') - 1) #Alte Version auslesen
        $newVersion = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen

        $newLine = "[assembly: AssemblyVersion("+'"'+$newVersion+'"'+")]"
        $file = $file.Replace($oldLine, $newLine)
    }
    #AssemblyFileVersion
    if ($file[$i].Contains("AssemblyFileVersion"))
    {
        $oldLine = $file[$i]
        $newLine = "[assembly: AssemblyFileVersion("+'"'+$newVersion+'"'+")]"
        $file = $file.Replace($oldLine, $newLine)
    }
}
$file | Out-File $assemblyPath -Force #File schreiben

#Version in Xamarin Hauptprojekt ändern
$fullXamarinProjectPath = (Get-ChildItem -Include find.me -Recurse | Select-Object DirectoryName).DirectoryName #Projektpfad herausfinden
#Projektdatei finden
$xamarinProject = Get-ChildItem -Path $fullXamarinProjectPath -Filter *.csproj -Recurse | Select-Object -First 1
$xamarinProjectPath = "$fullXamarinProjectPath\$xamarinProject"
$fileXamarinProject = Get-Content $xamarinProjectPath #File öffnen

#Version suchen und ersetzen
for ($i = 0; $i -lt $fileXamarinProject.Length; $i++)
{
    #AssemblyVersion
    if ($fileXamarinProject[$i].Contains("<AssemblyVersion>") -and !$fileXamarinProject[$i].Contains("//"))
    {
        $oldLine = $fileXamarinProject[$i]

        #Version erstellen
        $oldVersion = $oldLine.Substring($oldLine.IndexOf('>') + 1, $oldLine.LastIndexOf('<') - $oldLine.IndexOf('>') - 1) #Alte Version auslesen
        $newVersion = $oldVersion.Substring(0, $oldVersion.LastIndexOf('.')) + "." + ([int]$oldVersion.Substring($oldVersion.LastIndexOf('.') + 1) + 1) #Neue Version erstellen

        $newLine = "<AssemblyVersion>" + $newVersion + "</AssemblyVersion>"
        $fileXamarinProject = $fileXamarinProject.Replace($oldLine, $newLine)
    }
    #AssemblyFileVersion
    if ($fileXamarinProject[$i].Contains("<FileVersion>"))
    {
        $oldLine = $fileXamarinProject[$i]
        $newLine = "<FileVersion>" + $newVersion + "</FileVersion>"
        $fileXamarinProject = $fileXamarinProject.Replace($oldLine, $newLine)
    }
}
$fileXamarinProject | Out-File $xamarinProjectPath -Force #File schreiben

#In Git erneut hinzufügen
git add $assemblyPath
git add $xamarinProjectPath

#Temp .commit erstellen
Out-File ".commit" -Force