
Param
(
  [string]$SQLServer,
  [string]$SQLDBName
)
function getLastLogin {

Param
(
      [string]$SQLServer,
      [string]$SQLDBName
)

$SqlQuery = "SELECT MAX(login_time) AS [Last Login Time], login_name [Login]
FROM sys.dm_exec_sessions
GROUP BY login_name;"


$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
 
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
 
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
 
$SqlConnection.Close()
 
clear


for ($i = 0; $i -lt $DataSet.Tables[0].Rows.Count; $i++) 
{

    $DataSet.Tables[0].Rows[$i]
}
}
getLastLogin -SQLServer $SQLServer -SQLDBName $SQLDBName

