@ECHO OFF

echo "Running initial DISM scan."
DISM.exe /Online /Cleanup-image /Scanhealth

echo "Running DISM scan with /RestoreHealth"
DISM.exe /Online /Cleanup-image /Restorehealth