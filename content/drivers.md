
Installation
------------

For Unix and MacOS ODBC drivers should be compiled against [unixODBC](http://www.unixodbc.org/). Drivers compiled against [iODBC](http://www.iodbc.org/) *may* also work, but are not fully supported.

After installation of the driver manager and driver, you will have to register the driver in a [odbcinst.ini](#dsn-configuration-files) file for it to appear in `odbc::odbcListDrivers()`.

### Windows

Windows is bundled with ODBC libraries however drivers for each database need to be installed separately. Windows ODBC drivers typically include an installer that needs to be run and will install the driver to the proper locations.

### MacOS

[homebrew](http://brew.sh/) can be used to easily install database drivers on MacOS.

#### UnixODBC - Required for all databases

``` shell
# Install the unixODBC library
brew install unixodbc
```

#### Common DB drivers

``` shell
# SQL Server ODBC Drivers (Free TDS)
brew install freetds --with-unixodbc

# PostgreSQL ODBC ODBC Drivers
brew install psqlodbc

# MySQL ODBC Drivers (and database)
brew install mysql

# SQLite ODBC Drivers
brew install sqliteodbc
```

### Linux - Debian / Ubuntu

[apt-get](https://wiki.debian.org/Apt) can be used to easily install database drivers on Linux distributions which support it, such as Debian and Ubuntu.

#### UnixODBC - Required for all databases

``` shell
# Install the unixODBC library
apt-get install unixodbc unixodbc-dev
```

#### Common DB drivers

``` shell
# SQL Server ODBC Drivers (Free TDS)
apt-get install tdsodbc

# PostgreSQL ODBC ODBC Drivers
apt-get install odbc-postgresql

# MySQL ODBC Drivers
apt-get install libmyodbc

# SQLite ODBC Drivers
apt-get install libsqliteodbc
```

### R

``` r
# Install the latest odbc release from CRAN:
install.packages("odbc")

# Or the the development version from GitHub:
# install.packages(devtools)
devtools::install_github("rstats-db/odbc")
```

Connecting to a Database
------------------------

Databases can be connected by specifying a connection string directly, or with DSN configuration files.

### Connection Strings

Specify a connection string as named arguments directly in the `dbConnect()` method.

``` r
library(DBI)
con <- dbConnect(odbc::odbc(),
  driver = "PostgreSQL Driver",
  database = "test_db",
  uid = "postgres",
  pwd = "password",
  host = "localhost",
  port = 5432)
```

Alternatively you can pass a complete connection string as the `.connection_string` argument. [The Connection Strings Reference](https://www.connectionstrings.com) is a useful resource that has example connection strings for a large variety of databases.

``` r
library(DBI)
con <- dbConnect(odbc::odbc(),
  .connection_string = "Driver={PostgreSQL Driver};Uid=postgres;Pwd=password;Host=localhost;Port=5432;Database=test_db;")
```

### DSN Configuration files

ODBC configuration files are another option to specify connection parameters and allow one to use a Data Source Name (DSN) to make it easier to connect to a database.

``` r
con <- dbConnect(odbc::odbc(), "PostgreSQL")
```

#### Windows

The [ODBC Data Source Administrator](https://msdn.microsoft.com/en-us/library/ms714024(v=vs.85).aspx) application is used to manage ODBC data sources on Windows.

#### MacOS / Linux

On MacOS and Linux there are two separate text files that need to be edited. UnixODBC includes a command line executable `odbcinst` which can be used to query and modify the DSN files. However these are plain text files you can also edit by hand if desired.

There are two different files used to setup the DSN information.

-   `odbcinst.ini` - which defines driver options
-   `odbc.ini` - which defines connection options

The DSN configuration files can be defined globally for all users of the system, often at `/etc/odbc.ini` or `/opt/local/etc/odbc.ini`, the exact location depends on what option was used when compiling unixODBC. `odbcinst -j` can be used to find the exact location. Alternatively the `ODBCSYSINI` environment variable can be used to specify the location of the configuration files. Ex. `ODBCSYSINI=~/ODBC`

A local DSN file can also be used with the files `~/.odbc.ini` and `~/.odbcinst.ini`.

##### odbcinst.ini

Contains driver information, particularly the name of the driver library. Multiple drivers can be specified in the same file.

``` ini
[PostgreSQL Driver]
Driver          = /usr/local/lib/psqlodbcw.so

[SQLite Driver]
Driver          = /usr/local/lib/libsqlite3odbc.dylib
```

##### odbc.ini

Contains connection information, particularly the username, password, database and host information. The Driver line corresponds to the driver defined in `odbcinst.ini`.

``` ini
[PostgreSQL]
Driver              = PostgreSQL Driver
Database            = test_db
Servername          = localhost
UserName            = postgres
Password            = password
Port                = 5432

[SQLite]
Driver          = SQLite Driver
Database=/tmp/testing
```

See also: [unixODBC without the GUI](http://www.unixodbc.org/odbcinst.html) for more information and examples. NA \`\`\`