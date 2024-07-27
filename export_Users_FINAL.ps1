# Указываем путь к CSV файлу
$csvFile = "C:\Windows_users_for_work.csv"

# Импортируем CSV файл
$data = Import-Csv -Path $csvFile

# Функция для создания группы, если она не существует
function CreateGroupIfNotExists {
    param (
        [string]$groupName
    )
    #Параметр -ErrorAction SilentlyContinue указывает PowerShell не выводить ошибки на экран
    $group = Get-LocalGroup -Name $groupName -ErrorAction SilentlyContinue
    if (-not $group) {
        New-LocalGroup -Name $groupName
        Write-Output "Group '$groupName' created."
    } else {
        Write-Output "Group '$groupName' already exists."
    }
}

# Проходим по каждой строке в CSV файле
foreach ($row in $data) {
    # Создаем переменные для каждого параметра
    $username = $row.username
    $firstname = $row.firstname
    $lastname = $row.lastname
    $password = $row.password
    $group = $row.Group
    $description = $row.description
    $changePasswordAtNextLogon = $row.'User must change password at next logon' -eq 'TRUE'
    $cannotChangePassword = $row.'User cannot chage password' -eq 'TRUE'
    $passwordNeverExpires = $row.'Password never expires' -eq 'TRUE'
    $accountDisabled = $row.'Account is disable' -eq 'TRUE'
    $homeDir = "C:\Users\$username"

    # Проверяем и создаем группу, если она не существует
    CreateGroupIfNotExists -groupName $group

    try {
        # Создаем команду для создания пользователя
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        New-LocalUser -Name $username -Password $securePassword -FullName "$firstname $lastname" -Description $description

        Write-Output "User '$username' created."

        # Устанавливаем домашний каталог
        # Этот фрагмент кода устанавливает домашний каталог пользователя в системе Windows с использованием команды net user.
        # Команда net user в данном случае используется для управления пользователями в системе Windows. 
        # Параметр /homedir указывает на домашний каталог пользователя, который вы хотите установить, а $homeDir
        net user $username /homedir:$homeDir

        # Добавляем пользователя в группу
        Add-LocalGroupMember -Group $group -Member $username
        Add-LocalGroupMember -Group Users -Member $username
        Write-Output "User '$username' added to group '$group'."

        # Устанавливаем флаги учетной записи
        # Формируем команду для управления учетной записью пользователя
        $netUserCommand = "net user `"$username`""
        if ($changePasswordAtNextLogon) {
            $netUserCommand += " /logonpasswordchg:yes"
        } else {
            $netUserCommand += " /logonpasswordchg:no"
        }
        if ($cannotChangePassword) {
            $netUserCommand += " /passwordchg:no"
        } else {
            $netUserCommand += " /passwordchg:yes"
        }
        if ($passwordNeverExpires) {
            $netUserCommand += " /expires:never"
        }
        if ($accountDisabled) {
            $netUserCommand += " /active:no"
        } else {
            $netUserCommand += " /active:yes"
        }

        # Выполняем команду net user, если есть параметры для установки
        # -ne в PowerShell - это оператор сравнения, который означает "не равно"b
        if ($netUserCommand -ne "net user `"$username`"") {
        #Команда Invoke-Expression в PowerShell выполняет строку как выражение или команду
        # Выполняем команду, хранящуюся в переменной $netUserCommand
            Invoke-Expression $netUserCommand
            Write-Output "Account settings updated for user '$username'."
        }

    } catch {
        Write-Error "Failed to create user '$username': $_"
    }
}

Write-Output "Script execution completed."
