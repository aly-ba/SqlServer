@echo off
SqlCmd -E -d pubs -Q "drop table Position"
if errorlevel 1 goto ReportError
goto End
:ReportError
echo Project error: A tool returned an error code from the build event
exit 1
:End