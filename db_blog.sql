-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: blog_db
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `commentlikes`
--

DROP TABLE IF EXISTS `commentlikes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentlikes` (
  `comment_id` int NOT NULL,
  `liker_id` int NOT NULL,
  `like_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`,`liker_id`) USING BTREE,
  KEY `commentlikes_ibfk_2` (`liker_id`) USING BTREE,
  CONSTRAINT `commentlikes_ibfk_1` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `commentlikes_ibfk_2` FOREIGN KEY (`liker_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `commentreports`
--

DROP TABLE IF EXISTS `commentreports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentreports` (
  `reporter_id` int NOT NULL,
  `comment_id` int NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `report_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'pending',
  `is_handled` tinyint(1) DEFAULT '0',
  `report_id` int NOT NULL AUTO_INCREMENT,
  `rpttype` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`report_id`) USING BTREE,
  KEY `commentreports_ibfk_1` (`reporter_id`) USING BTREE,
  KEY `commentreports_ibfk_2` (`comment_id`) USING BTREE,
  CONSTRAINT `commentreports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `commentreports_ibfk_2` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `commenter_id` int DEFAULT NULL,
  `post_id` int DEFAULT NULL,
  `parent_comment_id` int DEFAULT NULL,
  `comment_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `like_count` int DEFAULT '0',
  `reply_count` int DEFAULT '0',
  `top_parentid` int DEFAULT NULL,
  PRIMARY KEY (`comment_id`) USING BTREE,
  KEY `comments_ibfk_1` (`commenter_id`) USING BTREE,
  KEY `comments_ibfk_2` (`post_id`) USING BTREE,
  KEY `comments_ibfk_3` (`parent_comment_id`) USING BTREE,
  KEY `comments_ibfk_4` (`top_parentid`) USING BTREE,
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`commenter_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comments_ibfk_4` FOREIGN KEY (`top_parentid`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=31481 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postfavorites`
--

DROP TABLE IF EXISTS `postfavorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postfavorites` (
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `favorite_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`,`user_id`) USING BTREE,
  KEY `postfavorites_ibfk_2` (`user_id`) USING BTREE,
  CONSTRAINT `postfavorites_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `postfavorites_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postlikes`
--

DROP TABLE IF EXISTS `postlikes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postlikes` (
  `post_id` int NOT NULL,
  `liker_id` int NOT NULL,
  `like_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`,`liker_id`) USING BTREE,
  KEY `postlikes_ibfk_2` (`liker_id`) USING BTREE,
  CONSTRAINT `postlikes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `postlikes_ibfk_2` FOREIGN KEY (`liker_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postreports`
--

DROP TABLE IF EXISTS `postreports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postreports` (
  `reporter_id` int NOT NULL,
  `post_id` int NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `report_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'pending',
  `is_handled` tinyint(1) DEFAULT '0',
  `report_id` int NOT NULL AUTO_INCREMENT,
  `rpttype` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`report_id`) USING BTREE,
  KEY `postreports_ibfk_1` (`reporter_id`) USING BTREE,
  KEY `postreports_ibfk_2` (`post_id`) USING BTREE,
  CONSTRAINT `postreports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `postreports_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `post_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `publish_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `images` json DEFAULT NULL,
  `comment_count` int DEFAULT '0',
  `view_count` int DEFAULT '0',
  `like_count` int DEFAULT '0',
  `favorite_count` int DEFAULT '0',
  `friend_see` tinyint(1) DEFAULT NULL,
  `post_subject` json DEFAULT NULL,
  PRIMARY KEY (`post_id`) USING BTREE,
  KEY `posts_ibfk_1` (`user_id`) USING BTREE,
  FULLTEXT KEY `idx_content` (`content`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postviews`
--

DROP TABLE IF EXISTS `postviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postviews` (
  `viewer_id` int NOT NULL,
  `post_id` int DEFAULT NULL,
  `view_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`viewer_id`,`view_time`) USING BTREE,
  KEY `postviews_ibfk_2` (`post_id`) USING BTREE,
  CONSTRAINT `postviews_ibfk_1` FOREIGN KEY (`viewer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `postviews_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysinfo`
--

DROP TABLE IF EXISTS `sysinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysinfo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `time` datetime DEFAULT CURRENT_TIMESTAMP,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_sysinfo_users` (`uid`) USING BTREE,
  CONSTRAINT `fk_sysinfo_users` FOREIGN KEY (`uid`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userfollows`
--

DROP TABLE IF EXISTS `userfollows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userfollows` (
  `follower_id` int NOT NULL,
  `followed_id` int NOT NULL,
  `follow_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followed_id`) USING BTREE,
  KEY `userfollows_ibfk_2` (`followed_id`) USING BTREE,
  CONSTRAINT `userfollows_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `userfollows_ibfk_2` FOREIGN KEY (`followed_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usermutes`
--

DROP TABLE IF EXISTS `usermutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usermutes` (
  `user_id` int NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `type` int DEFAULT NULL,
  KEY `usermutes_fk` (`user_id`) USING BTREE,
  CONSTRAINT `usermutes_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `usermutes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `Uname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `password` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `birthday` date DEFAULT '1999-01-01',
  `registration_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `sex` tinyint(1) DEFAULT NULL,
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `school` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `major` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `edutime` date DEFAULT '1999-01-01',
  `eduleval` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `companyname` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `positionname` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `industry` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `interests` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `likenum` int DEFAULT '0',
  `attionnum` int DEFAULT '0',
  `fansnum` int DEFAULT '0',
  `showlike` tinyint(1) DEFAULT '0',
  `showcollect` tinyint(1) DEFAULT '0',
  `showphone` tinyint(1) DEFAULT '0',
  `showmail` tinyint(1) DEFAULT '0',
  `peimission` int DEFAULT '0',
  `token` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE KEY `unique_email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `verificationcodes`
--

DROP TABLE IF EXISTS `verificationcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verificationcodes` (
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expiration` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-10 23:26:25
