cd C:\Users\$env:UserName\Desktop\$env:UserName
cp * C:\new_drive\all_users\$env:UserName
cd C:\Users\$env:UserName\Desktop\$env:UserName
Remove-Item C:\Users\$env:UserName\Desktop\$env:Username\* -Recurse
