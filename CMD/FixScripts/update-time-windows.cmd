@ECHO OFF
REM ------------------------
REM SCRIPT BY TRISHTECH.COM
REM ------------------------

w32tm /register

sc start W32Time

w32tm /config /update /manualpeerlist:"pool.ntp.org"
