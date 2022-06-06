net stop spooler
del %systemroot%\system32\spool\printers* /q
net start spooler