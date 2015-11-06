# for finding files, UNIX like
Function Trace-Command($name) {
  Get-Command $name | Select-Object Definition;
}