@echo off
setlocal
cd /d "%~dp0"
py -3 gui.py
if errorlevel 1 (
    echo Could not start the GUI. See the error above.
    echo Install dependencies with: py -3 -m pip install -r requirements.txt
    pause
)
