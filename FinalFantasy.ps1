# Create users
for ($i = 21; $i -le 25; $i++) {
    $username = "User$i"
    $passw = "UuoBriar1650TI" + "User$i"
    # Truncate the number to a maximum of 15 characters
    $truncatedUser = $username.Substring(0, [Math]::Min($username.Length, 15))
    $password = ConvertTo-SecureString $passw -AsPlainText -Force
    #try исключение
    try {
        $user = New-LocalUser -Name $truncatedUser -Password $password -FullName "MegaTraxtor $truncatedUser" -Description "All Users 110 $truncatedUser" -PasswordNeverExpires -ErrorAction Stop
        Write-Host "User $truncatedUser created successfully."
    } catch {
        Write-Host "Failed to create user"
    }
}
try {
    New-LocalGroup -Name "managers" -Description "Group Managers"
} catch {
    $group = "managers"
    for ($i = 21; $i -le 25; $i++) {
        $username = "User$i"
        Add-LocalGroupMember -Group $group -Member "$username"
        Write-Host "User $username added to group $group."
    }
}

$group ="Users"
for ($i =21; $i -le 25; $i++){
    $username ="User$i"
    Add-LocalGroupMember -group $group -member "$username"
    write-host "user $username added le group $group,"
}
