





readHemOncIngredients <-
        function() {
                sql <- SqlRender::render(SqlRender::readSql("inst/sql/CancerIngredientTable.sql"),
                                         schema = "public")
                sql <- SqlRender::render(SqlRender::readSql("inst/sql/HOComponentClasses.sql"),
                                         schema = "public")
                conn <- chariot::connectAthena()
                pg13::query(conn = conn,
                            sql_statement = sql)
                pg13::execute(conn = conn,
                            sql_statement = sql)
                
                chariot::dcAthena(conn = conn)
                
        }
