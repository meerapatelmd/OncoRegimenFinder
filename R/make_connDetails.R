#' Make connectionDetails
#' @description Wrapper around the DatabaseConnector::createConnectionDetails function.
#' @return connectionDetail object
#' @import DatabaseConnector
#' @export

make_connDetails <-
        function(dbms = "postgresql",
                 server,
                 user,
                 password,
                 port) {

                DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                           server = server,
                                                           user = user,
                                                           password = password,
                                                           port = port)
}
