#' Process Regimen Table
#' @import SqlRender
#' @import pg13
#' @export

processRegimenTable <- 
        function(conn,
                 writeDatabaseSchema,
                 regimenTable,
                 date_lag_input = 30,
                 regimen_repeats = 5) {
                
                sql <- SqlRender::render(SqlRender::readSql(paste0(system.file(package = "OncoRegimenFinder"), "/sql/processRegimens.sql")),
                                         writeDatabaseSchema = writeDatabaseSchema,
                                         regimenTable = regimenTable,
                                         date_lag_input = date_lag_input)
                
                for( i in 1:regimen_repeats) {
                        
                        pg13::execute(conn = conn,
                                      sql_statement = sql)
                        
                        Sys.sleep(0.2)
                        
                }
                
        }

