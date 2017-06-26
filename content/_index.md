Using databases with R
======================

<img src="/homepage/header.png"   align="right">

<p>
    RStudio makes it easier to access and analyze your data with R.  There are tools and best practices that are needed when working with data in databases.  Additionally, a new approach is needed to be more effective at 'getting to know' the information found in databases, this website is dedicated to cover such approach.

</p>

Focus on **dplyr**
------------------

The `dplyr` package simplifies data transformation. It provides a
consistent set of functions, called verbs, that can be used in
succession and interchangeably to gain understanding of the data
iteratively.

Another nice thing about `dplyr` is that it can **interact** with
databases directly. It accomplishes this by translating the `dplyr`
verbs into SQL queries. This incredibly convenient feature allows us to
‘speak’ directly with the database from R. Other advantages of this
approach are:

-   **Run data exploration over all of the data** - Instead of coming up
    with a plan to decide what data to import, we can focus on analyzing
    the data inside the database, which in turn should yield
    faster insights.

-   **Use the SQL Engine to run the data transformations** - We are, in
    effect, pushing the computation to the database because `dplyr` is
    sending SQL queries to the database.

-   **Collect a targeted dataset** - After become familiar with the data
    and choosing the data points that will either be shared or modeled,
    a final query can then be used to bring back only that data into
    memory in R.

-   **All your code is in R!** - Because we are using `dplyr` to
    communicate with the database, there is no need to change language,
    or tools, to perform the data exploration.

<center>
<img src="/homepage/interact.png"  height="250" width="420" >
</center>
<br/>

Connection Options
------------------

At the center of this approach is the `DBI` package. This package acts
as 'middle-ware' between packages that allow connectivity with the
database and the user or other packages. It provides a consistent set of
functions regardless of the database type we are connecting to. The
`dplyr` package depends on the `DBI` package for communication with
databases.

There are packages that enables a direct connection between the an
open-source database and R. Currently, such packages exist for the
following databases: MySQL, SQLite, PostgreSQL and bigquery. A
functional architecture would look something like this:

<center>
<img src="/homepage/open-source.png"  height="250" width="500" align="middle">
</center>
<br/>

Most commercial databases, like Oracle and Microsoft SQL Server, offer
ODBC drivers that allow you to connect your tool to the database. Even
though there are R packages that allow you to use ODBC drivers, the
connection will more likely not be compatible with DBI. The new `odbc`
package solves that problem by providing a, what is called, DBI-back-end
to any ODBC driver connection. The functional architecture for this mode
would look like this:

<center>
<img src="/homepage/commercial.png"  height="250" width="500" align = "middle">
</center>
<br/>

Quick Example
-------------

We will cover how to access a Microsoft SQL Server database from a
workstation that is running on Microsoft Windows.

There are three things that we will need to get started:

-   A database we can access

-   A database driver installed in either our workstation or RStudio
    Server

-   All of the required packages installed in R

### Database Driver

A **database driver** is a program that allows the workstation and the
database to communicate. In Microsoft Windows, the drivers that connect
to MS SQL databases are installed by default. We need the **name** of
the driver that will be used inside our code in R. The easiest way to do
this is to open the ODBC Data Source Administrator. To find it in your,
system please refer to this article: [Check the ODBC SQL Server Driver
Version
(Windows)](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/check-the-odbc-sql-server-driver-version-windows)
. Once the administrator program is open, click on the **Drivers** tab.
In my laptop, these are the drivers available. I will use **SQL Server**
for the Driver argument in my connection in R.

<center>
<img src="/homepage/odbc.png"  height="270" width="450" align="middle">
</center>
### R packages

Besides `dplyr`, the following packages are required:

-   `odbc` - This is the interface between the database driver and R
-   `DBI` - Standardizes the functions related to database operations
-   `dbplyr` - Enables `dplyr` to interact with databases. It also
    contains the vendor-specific SQL translations.

The database accessibility feature is still being developed, so we will
use the development versions of `dbplyr` and `dplyr`.

    install.packages("dplyr")
    install.packages("odbc")
    install.packages("dbplyr")
    install.packages("DBI")

### Connect to the database

We will use the `dbConnect()` function from the `DBI` package to connect
to the database. The value for the `Driver` argument is the name we
determined in the *Database Driver* section above.


    con <- DBI::dbConnect(odbc::odbc(),
                       Driver    = "SQL Server", 
                       Server    = "localhost",
                       Database  = "airontime",
                       UID       = [My User ID],
                       PWD       = [My Password],
                       Port      = 1433)

A very useful function in `DBI` is `dbListTables()`, which retrieves the
names of available tables.

    dbListTables(con)

`[1] "airlines" "airport"  "airports" "faithful" "flights"  "iris"`

Another useful function is the `dbListFields`, which returns a vector
with all of the column names in a table.

    dbListFields(con, "flights")

     [1] "year"           "month"          "day"            "dep_time"       "sched_dep_time"
     [6] "dep_delay"      "arr_time"       "sched_arr_time" "arr_delay"      "carrier"       
    [11] "flight"         "tailnum"        "origin"         "dest"           "air_time"      
    [16] "distance"       "hour"           "minute"         "time_hour"     

### Interacting with the data using dplyr

Using `dplyr`, we can easily preview a database. The `tbl()` command
creates a reference to the table.

    library(dplyr)
    tbl(con, "flights")

<br/>

    Source:     table<flights> [?? x 19]
    Database:   Microsoft SQL Server 12.00.4422[username@localhost/airontime]

        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay carrier flight tailnum origin  dest
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>     <dbl>   <chr>  <int>   <chr>  <chr> <chr>
    1   2013     1     1      517            515         2      830            819        11      UA   1545  N14228    EWR   IAH
    2   2013     1     1      533            529         4      850            830        20      UA   1714  N24211    LGA   IAH
    3   2013     1     1      542            540         2      923            850        33      AA   1141  N619AA    JFK   MIA
    4   2013     1     1      544            545        -1     1004           1022       -18      B6    725  N804JB    JFK   BQN
    5   2013     1     1      554            600        -6      812            837       -25      DL    461  N668DN    LGA   ATL
    6   2013     1     1      554            558        -4      740            728        12      UA   1696  N39463    EWR   ORD
    7   2013     1     1      555            600        -5      913            854        19      B6    507  N516JB    EWR   FLL
    8   2013     1     1      557            600        -3      709            723       -14      EV   5708  N829AS    LGA   IAD
    9   2013     1     1      557            600        -3      838            846        -8      B6     79  N593JB    JFK   MCO
    10  2013     1     1      558            600        -2      753            745         8      AA    301  N3ALAA    LGA   ORD
    # ... with more rows, and 5 more variables: air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

<br/> The `tally()` verb in `dplyr` returns the row count.

    tally(tbl(con, "flights"))

</br>

    Source:     lazy query [?? x 1]
    Database:   Microsoft SQL Server 12.00.4422[username@localhost/airontime]

           n
       <int>
    1 336776

<br/> When used against a database, the previous function is converted
to a SQL query that works with MS SQL Server. The `show_query()`
function displays the translation.

    show_query(tally(tbl(con, "flights")))

`<SQL> SELECT COUNT(*) AS "n" FROM "flights"`

### Bringing it all together

The last code sample shows how easy it is to find out what the top
airlines are by number of flights. Additionally, we wish to see the
names of the airlines and not their codes. The steps taken are:

-   Start with the `flights` table and join it to the `carrier` table to
    obtain the airline name

-   Group the data by the airline `name`

-   Tally the total rows by airline `name`

-   Order the data by the resulting tallies in a descending order

All of these steps are translated into a SQL statement and processed
inside the database. We do not need to import the tables into R memory
at any time, we just use `dplyr` to get the results quickly.

    tbl(con, "flights") %>%
      left_join(tbl(con, "airlines"), by = "carrier") %>%
      group_by(name) %>%
      tally %>%
      arrange(desc(n))

<br/>

    Source:     lazy query [?? x 2]
    Database:   Microsoft SQL Server 12.00.4422[username@localhost/airontime]
    Ordered by: desc(n)

    # S3: tbl_dbi
                           name     n
                          <chr> <int>
     1    United Air Lines Inc. 58665
     2          JetBlue Airways 54635
     3 ExpressJet Airlines Inc. 54173
     4     Delta Air Lines Inc. 48110
     5   American Airlines Inc. 32729
     6                Envoy Air 26397
     7          US Airways Inc. 20536
     8        Endeavor Air Inc. 18460
     9   Southwest Airlines Co. 12275
    10           Virgin America  5162
    # ... with more rows
