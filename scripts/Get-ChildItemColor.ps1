function Get-ChildItemColor {
    if (($Args.Count -gt 0) -And (($Args[0] -eq "-a") -Or ($Args[0] -eq "--all"))) {
        $Args[0] = "-Force"
    }

    $width =  $host.UI.RawUI.WindowSize.Width
    $cols = 3
    $color_fore = $Host.UI.RawUI.ForegroundColor

    $compressed_list = @(".zip", ".tar", ".gz", ".rar", ".7z")
    $executable_list = @(".exe", ".bat", ".cmd", ".ps1", ".psm1", ".vbs", ".reg", ".fsx", ".dll", ".pdb")
    $text_files_list = @(".txt", ".csv", ".lg", ".md")
    $configs_list = @(".cfg", ".config", ".conf", ".ini")
    $code_list = @(".rb", ".cs", ".vb", ".aspx", ".py", ".pl", ".php", ".htm", ".html", ".css", ".scss", ".js", ".sql", ".json")
    $image_list = @(".png", ".jpg", ".jpeg", ".bmp", ".gif", ".ico")
    $project_list = @(".csproj", ".vbproj", ".sln")

    $color_table = @{}
    foreach ($Extension in $compressed_list) {
        $color_table[$Extension] = "Yellow"
    }   

    foreach ($Extension in $executable_list) {
        $color_table[$Extension] = "Blue"
    }

    foreach ($Extension in $text_files_list) {
        $color_table[$Extension] = "Cyan"
    }

    foreach ($Extension in $configs_list) {
        $color_table[$Extension] = "DarkCyan"
    }

    foreach ($Extension in $code_list) {
        $color_table[$Extension] = "Magenta"
    }

    foreach ($Extension in $project_list) {
        $color_table[$Extension] = "DarkMagenta"
    }

    foreach ($Extension in $image_list) {
        $color_table[$Extension] = "Red"
    }

    $i = 0
    $pad = [int]($width / $cols) - 1

    Invoke-Expression ("Get-ChildItem $Args") |
    %{
        $c = $null;
        if ($_.GetType().Name -eq 'DirectoryInfo') {
            $c = $color_fore
        } else {
            $c = $color_table[$_.Extension]

            if ($c -eq $null) {
                $c = 'Green'
            }`  
        }

        $Host.UI.RawUI.ForegroundColor = $c
        echo $_
        $Host.UI.RawUI.ForegroundColor = $color_fore
    }
}
