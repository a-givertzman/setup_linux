-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: localhost    Database: 
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!50606 SET @OLD_INNODB_STATS_AUTO_RECALC=@@INNODB_STATS_AUTO_RECALC */;
/*!50606 SET GLOBAL INNODB_STATS_AUTO_RECALC=OFF */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `crane_data_server`
--

/*!40000 DROP DATABASE IF EXISTS `crane_data_server`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `crane_data_server` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `crane_data_server`;

--
-- Table structure for table `app_user`
--

DROP TABLE IF EXISTS `app_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group` enum('admin','operator') CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL DEFAULT 'operator' COMMENT 'Признак группировки',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL COMMENT 'ФИО Потльзователя',
  `login` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL COMMENT ' Логин',
  `pass` varchar(2584) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Пароль',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`login`),
  UNIQUE KEY `login_UNIQUE` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=1002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Потльзователи';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event` (
  `id` decimal(24,12) NOT NULL DEFAULT '1.000000000000' COMMENT 'Идентификатор записи',
  `type` enum('bool','int','uint','dint','word','lint','real','time','dateandtime') CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL COMMENT 'S7DataType{bool, int, uInt, dInt, word, lInt, real, time, dateAndTime}',
  `path` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL COMMENT 'Путь тэга /server/line/ied/',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL COMMENT 'ФИО Потльзователя',
  `value` decimal(24,4) NOT NULL DEFAULT '0.0000' COMMENT 'Значение 24 знака, 4 из них после запятой',
  `status` int NOT NULL COMMENT 'DSStatus as int',
  `timestamp` timestamp(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx1` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin COMMENT='События';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`crane_data_server`@`%`*/ /*!50003 TRIGGER `autoincrement` BEFORE INSERT ON `event` FOR EACH ROW begin
	if (@event_id is null) then
		select ifnull(max(`id`), 1) into @event_id from `event`;
	end if;
	set @event_id = @event_id + 0.0000001;
	set new.id = @event_id;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `timestamp` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `code` int NOT NULL,
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `stack` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fault`
--

DROP TABLE IF EXISTS `fault`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fault` (
  `timestamp` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `winch1_load` decimal(8,2) NOT NULL DEFAULT '0.0' COMMENT 'Нагрузка лебедки 1 (тонны)',
  `cranemode_mops` TINYINT(1) NOT NULL,
  `cranemode_aops` TINYINT(1) NOT NULL,
  `cranemode_ahc` TINYINT(1) NOT NULL,
  `alarm_class` TINYINT(1) NOT NULL COMMENT 'Класс тревоги: 0 - норма, 1 - Авария, 4 - Предупреждение',
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Срезы параметров работы крана с частотой зависящей от велечины ключевых параметров';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fault`
--

DROP TABLE IF EXISTS `fault_sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fault` (
  `timestamp_begin` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT='Метка времени начала аварийного режима',
  `timestamp_end` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT='Метка времени начала аварийного режима',
  `winch1_load` decimal(8,2) NOT NULL DEFAULT '0.0' COMMENT 'Нагрузка лебедки 1 (тонны)',
  `winch1_load_awarage` decimal(8,2) NOT NULL DEFAULT '0.0' COMMENT 'Нагрузка лебедки 1 (тонны)',
  `alarm_class` TINYINT(1) NOT NULL COMMENT 'Класс тревоги: 0 - норма, 1 - Авария, 4 - Предупреждение',
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Рабочие циклы. Парамеьры работы крана расчитанные в период рабочего цикла';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `retain`
--

DROP TABLE IF EXISTS `retain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retain` (
  `parameter` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `value` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

DROP USER IF EXISTS 'crane_data_server'@'%';
CREATE USER 'crane_data_server'@'%' IDENTIFIED WITH mysql_native_password BY '00d0-25e4-*&s2-ccds';
  GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, TRIGGER, EXECUTE, REFERENCES, RELOAD 
  ON *.* 
  TO 'crane_data_server'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!50606 SET GLOBAL INNODB_STATS_AUTO_RECALC=@OLD_INNODB_STATS_AUTO_RECALC */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-07 16:59:18