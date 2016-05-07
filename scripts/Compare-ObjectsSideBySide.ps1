function Compare-ObjectsSideBySide ($lhs, $rhs) {
  $lhsMembers = $lhs | Get-Member -MemberType NoteProperty, Property | Select-Object -ExpandProperty Name
  $rhsMembers = $rhs | Get-Member -MemberType NoteProperty, Property | Select-Object -ExpandProperty Name
  $combinedMembers = ($lhsMembers + $rhsMembers) | Sort-Object -Unique


  $combinedMembers | ForEach-Object {
    $properties = @{
      'Property' = $_;
    }

    if ($lhsMembers.Contains($_)) {
      $properties['Left'] = $lhs | Select-Object -ExpandProperty $_;
    }

    if ($rhsMembers.Contains($_)) {
      $properties['Right'] = $rhs | Select-Object -ExpandProperty $_;
    }

    New-Object PSObject -Property $properties
  }
}
