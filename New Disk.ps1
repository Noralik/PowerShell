Set-ExecutionPolicy Bypass -Force

powershell in administrators

1 ) 	DISKPART
2 ) 	list disk
3 ) 	select disk N (1)
4 ) 	convert dynamic 
5 ) 	create volume simple
6 ) 	format fs=ntfs quick
7 ) 	assign letter=E
8 ) 	"если Нужно замаунтить то" assign Mount="Path"
9 ) 	
10 )	
11 )	

N-number
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Raid 1 ** variant 1

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
"если Нужно замаунтить то" assign Mount="Path"

exit
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Raid 1 ** variant 2


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
"если Нужно замаунтить то" assign Mount="Path"

exit



