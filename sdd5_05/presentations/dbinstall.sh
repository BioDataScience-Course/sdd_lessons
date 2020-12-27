#! /bin/bash
sudo echo "=== SDD5 Database installation ==="

# Install SQLiteStudio 3.2.1
mkdir -p /home/sv/bin
cd /home/sv/bin
wget -O sqlitestudio.tar.xz "https://sqlitestudio.pl/files/sqlitestudio3/complete/linux64/sqlitestudio-3.2.1.tar.xz"
tar xf sqlitestudio.tar.xz
rm sqlitestudio.tar.xz
echo "[Desktop Entry]
Version=3.2.1
Type=Application
Name=SQLite Studio
Comment=SQLite Frontend
Icon=/home/sv/bin/SQLiteStudio/app_icon/sqlitestudio.svg
Exec=/home/sv/bin/SQLiteStudio/sqlitestudio
NoDisplay=false
Categories=Development;
StartupNotify=true
Terminal=false
" > ~/.local/share/applications/sqlitestudio.desktop

# Install unixodbc, the SQLite driver and a general SQLite database
sudo apt install -y unixodbc unixodbc-dev --install-suggests
# Install drivers (uncomment those you need)
# SQL Server ODBC Drivers (Free TDS)
#sudo apt install -y tdsodbc
# PostgreSQL ODBC ODBC Drivers
#sudo apt install -y odbc-postgresql
# MySQL ODBC Drivers
#sudo apt install -y libmyodbc
# SQLite ODBC Drivers
sudo apt install -y libsqliteodbc
# Know where the config files are: odbcinst -j
# /etc/odbcinst.ini is populated by the installer
# Check drivers are available in R with odbc::odbcListDrivers()
# /etc/odbc.ini set up system-wide databases (initially empty)
# ~/.odbc.ini set up users databases
# Create one SQLite3 database for sv in ~/shared/database.sqlite
touch ~/shared/database.sqlite
echo "
[database.sqlite]
Driver   = SQLite3 Driver
Database = /home/sv/shared/database.sqlite
" > ~/.odbc.ini

