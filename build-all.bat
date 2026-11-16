@echo off
setlocal
cd /d "%~dp0"
if not exist "..\RexPermsGuard\pom.xml" (
  echo Clone ivdsh1/RexPermsGuard beside RexPerms first.
  exit /b 1
)
call mvn -B -f bundle/pom.xml clean verify %*
exit /b %errorlevel%
