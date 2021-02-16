<?php
include_once "database.php";

class functions
{
    function dbExecute($sql,$param_array){
        $database= new database();
        $database->getconnection();
        $myCon=$database->conn;
        $stm= $myCon->prepare($sql);
        $stm->execute($param_array);
        return $stm;
    }

}