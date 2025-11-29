# посмотреть название всех папок
Get-ChildItem "C:\Users\Esclinor\Desktop\clicker\Waifu" -Directory | Select-Object -ExpandProperty Name

# извлечь название и присвоить адйи и создать их в CSV файле
$path = "C:\Users\Esclinor\Desktop\clicker\Waifu"
$output = "C:\Users\Esclinor\Desktop\folder_list.csv"

$folders = Get-ChildItem -Path $path -Directory
$data = @()

$i = 1
foreach ($folder in $folders) {
    $data += [PSCustomObject]@{
        ID = $i
        Name = $folder.Name
    }
    $i++
}

$data | Export-Csv -Path $output -NoTypeInformation -Encoding UTF8

Write-Host "CSV создан: $output"

# из CSV файла создать новые папки а существеюзие не трогать
$csvPath = "C:\Users\Esclinor\Desktop\folder_list.csv"
$targetRoot = "C:\Users\Esclinor\Desktop\clicker\Waifu"

# Читаем CSV
$folders = Import-Csv -Path $csvPath

foreach ($item in $folders) {
    $folderName = $item.Name
    $fullPath = Join-Path $targetRoot $folderName

    if (-Not (Test-Path $fullPath)) {
        New-Item -Path $fullPath -ItemType Directory | Out-Null
        Write-Host "Создана папка: $folderName"
    } else {
        Write-Host "Уже существует: $folderName (пропущена)"
    }
}
