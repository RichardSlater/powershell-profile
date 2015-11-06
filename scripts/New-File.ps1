# for creating empty files, UNIX like
Function New-File($file) {
  if (Test-Path $file) {
    $date = Get-Date;
    Get-Item $file | ForEach-Object {
      $_.LastAccessTime = $date;
      $_.LastWriteTime = $date;
    }
  } else {
    [String]::Empty | Out-File $file -Encoding ASCII;
  }
}