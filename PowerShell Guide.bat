# PowerShell Guide
Практические скрипты для работы с политикой выполнения, маппингом сетевых дисков, копированием данных и управлением томами через DiskPart.

---

## 1. Политика выполнения скриптов
Проверка текущей политики:
Get-ExecutionPolicy

Изменение политики для разрешения выполнения всех скриптов:
Set-ExecutionPolicy Bypass -Force

---

## 2. Маппинг сетевых дисков
Удаление всех текущих подключений:
net use * /delete /yes

Подключение сетевых папок:
net use G: \\192.168.17.2\share_1
net use H: \\192.168.17.2\share_2

Альтернативное подключение:
net use Z: \\192.168.10.0\share

---

## 3. Копирование и очистка пользовательских данных

### Копирование данных с резервной копии на рабочий стол:
cd C:\new_drive\all_users\$env:UserName
cp * C:\Users\$env:UserName\Desktop\$env:UserName

### Обратное копирование данных обратно в резервную папку:
cd C:\Users\$env:UserName\Desktop\$env:UserName
cp * C:\new_drive\all_users\$env:UserName

### Очистка папки на рабочем столе после копирования:
cd C:\Users\$env:UserName\Desktop\$env:UserName
Remove-Item C:\Users\$env:UserName\Desktop\$env:UserName\* -Recurse

> **Важно:** команда `Remove-Item` полностью удаляет содержимое указанной папки, будьте внимательны!

---

## 4. Работа с дисками через DiskPart

### Создание простого тома
1. Открыть PowerShell от имени администратора.
2. Выполнить команды:
diskpart
list disk
select disk N
convert dynamic
create volume simple
format fs=ntfs quick
assign letter=E

Если нужно замонтировать в папку:
assign mount="Path"

---

### Создание RAID 1 (зеркальный том)

**Вариант 1 — через add disk:**
diskpart
list disk
select disk 1
convert dynamic
create volume simple
select disk 2
convert dynamic
create volume simple
list volume
select volume 1
add disk=2
format fs=ntfs quick
assign letter=E
exit

**Вариант 2 — сразу создание зеркала:**
diskpart
list disk
select disk 1
convert dynamic
select disk 2
convert dynamic
select disk 1
create volume mirrored disk=2
format fs=ntfs quick
assign letter=E
exit

---

# Примечания
- Перед запуском скриптов необходимо выполнить `Set-ExecutionPolicy Bypass -Force`.
- Скрипты подключения дисков можно сохранять в `.bat` или `.ps1` файлы.
- Для работы с дисками всегда использовать PowerShell с правами администратора.
- После копирования данных рекомендуется вручную проверить корректность переноса перед очисткой.

