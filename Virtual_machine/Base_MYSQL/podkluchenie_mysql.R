library(RJDBC)
drv <- JDBC("com.mysql.jdbc.Driver",
            "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
dbGetQuery(con, "SELECT * FROM energo.test1")
d <- dbReadTable(con, "TEST_TABLE")
dbWriteTable(con, "TEST_TABLE", test_table)
dbDisconnect(con)
