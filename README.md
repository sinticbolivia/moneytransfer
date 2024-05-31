#Requirements

Vala 0.56
Lib DesktopFramework
glib-2.0
gee-0.8
json-glib-1.0
libxml-2.0
sqlite3
mysqlclient or mariadbclient
libpq (postgres)
libsoup-3.0 or libsoup-2.4

#Compilation

meson build
cd build
meson compile

#Compile microservice server

Into DesktopFramework repository

make api

copy the compiled api file into moneytransfer repository

#Config file

Open config.xml and set 
- database configuracion
- Microservices endpoints
- SMTP Config
- Modules path for server loading
