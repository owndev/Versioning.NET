# Introducing
This project is for automatic versioning of Visual Studio (WPF, WinUI and Xamarin Forms) projects.
All GitHooks scripts run the PowerShell scripts that contain the functions.

# Get started
- Paste all files into GitHook's folder (\.git\hooks).
- If versions should be visible in README.md -> add chapter ***Buildversion*** (In Markdown -> # Buildversion)
- Add a find.me File to the Project Folder (it's contain a File with .csproj) 
  - For **Xamarin Forms** add another find.me.android in Project Folder of the Android Project 
  - For **Uno Platfrom** add another find.me.mobile in Project Mobile Folder of the Ubo Platfrom Project.

## And now for each commit:
- The version number written in the commit
- A releasenotes.txt is written (only if ***Buildversion*** in README.md | otherwise only current commit is written). This file is written as a markdown table.
- If ***Buildversion*** in README.md then the commit is written as a markdown table under ***Buildversion***
