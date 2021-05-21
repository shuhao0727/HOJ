/*
SQLyog Professional v12.09 (64 bit)
MySQL - 5.7.34 : Database - hoj
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE IF NOT EXISTS`hoj` DEFAULT CHARACTER SET utf8;

USE `hoj`;

/*Table structure for table `announcement` */

DROP TABLE IF EXISTS `announcement`;

CREATE TABLE `announcement` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` longtext,
  `uid` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0可见，1不可见',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  CONSTRAINT `announcement_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `auth` */

DROP TABLE IF EXISTS `auth`;

CREATE TABLE `auth` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '权限名称',
  `permission` varchar(100) DEFAULT NULL COMMENT '权限字符串',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0可用，1不可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Table structure for table `category` */

DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `code_template` */

DROP TABLE IF EXISTS `code_template`;

CREATE TABLE `code_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL,
  `lid` bigint(20) unsigned NOT NULL,
  `code` longtext NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `lid` (`lid`),
  CONSTRAINT `code_template_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `code_template_ibfk_2` FOREIGN KEY (`lid`) REFERENCES `language` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `comment` */

DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` bigint(20) unsigned DEFAULT NULL COMMENT 'null表示无引用比赛',
  `did` int(11) DEFAULT NULL COMMENT 'null表示无引用讨论',
  `content` longtext COMMENT '评论内容',
  `from_uid` varchar(32) NOT NULL COMMENT '评论者id',
  `from_name` varchar(255) DEFAULT NULL COMMENT '评论者用户名',
  `from_avatar` varchar(255) DEFAULT NULL COMMENT '评论组头像地址',
  `from_role` varchar(20) DEFAULT NULL COMMENT '评论者角色',
  `like_num` int(11) DEFAULT '0' COMMENT '点赞数量',
  `status` int(11) DEFAULT '0' COMMENT '是否封禁或逻辑删除该评论',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`from_uid`),
  KEY `from_avatar` (`from_avatar`),
  KEY `comment_ibfk_7` (`did`),
  KEY `cid` (`cid`),
  CONSTRAINT `comment_ibfk_6` FOREIGN KEY (`from_avatar`) REFERENCES `user_info` (`avatar`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `comment_ibfk_7` FOREIGN KEY (`did`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comment_ibfk_8` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

/*Table structure for table `comment_like` */

DROP TABLE IF EXISTS `comment_like`;

CREATE TABLE `comment_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `cid` int(11) NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `cid` (`cid`),
  CONSTRAINT `comment_like_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `comment_like_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `comment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `contest` */

DROP TABLE IF EXISTS `contest`;

CREATE TABLE `contest` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL COMMENT '比赛创建者id',
  `author` varchar(255) DEFAULT NULL COMMENT '比赛创建者的用户名',
  `title` varchar(255) DEFAULT NULL COMMENT '比赛标题',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0为acm赛制，1为比分赛制',
  `description` longtext COMMENT '比赛说明',
  `source` int(11) DEFAULT '0' COMMENT '比赛来源，原创为0，克隆赛为比赛id',
  `auth` int(11) NOT NULL COMMENT '0为公开赛，1为私有赛（访问有密码），2为保护赛（提交有密码）',
  `pwd` varchar(255) DEFAULT NULL COMMENT '比赛密码',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `duration` bigint(20) DEFAULT NULL COMMENT '比赛时长(s)',
  `seal_rank` tinyint(1) DEFAULT '0' COMMENT '是否开启封榜',
  `seal_rank_time` datetime DEFAULT NULL COMMENT '封榜起始时间，一直到比赛结束，不刷新榜单',
  `status` int(11) DEFAULT NULL COMMENT '-1为未开始，0为进行中，1为已结束',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`uid`),
  KEY `uid` (`uid`),
  CONSTRAINT `contest_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1002 DEFAULT CHARSET=utf8;

/*Table structure for table `contest_announcement` */

DROP TABLE IF EXISTS `contest_announcement`;

CREATE TABLE `contest_announcement` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `aid` bigint(20) unsigned NOT NULL COMMENT '公告id',
  `cid` bigint(20) unsigned NOT NULL COMMENT '比赛id',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `contest_announcement_ibfk_1` (`cid`),
  KEY `contest_announcement_ibfk_2` (`aid`),
  CONSTRAINT `contest_announcement_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contest_announcement_ibfk_2` FOREIGN KEY (`aid`) REFERENCES `announcement` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `contest_explanation` */

DROP TABLE IF EXISTS `contest_explanation`;

CREATE TABLE `contest_explanation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cid` bigint(20) unsigned NOT NULL,
  `uid` varchar(32) NOT NULL COMMENT '发布者（必须为比赛创建者或者超级管理员才能）',
  `content` longtext COMMENT '内容(支持markdown)',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `contest_explanation_ibfk_1` (`cid`),
  CONSTRAINT `contest_explanation_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contest_explanation_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `contest_problem` */

DROP TABLE IF EXISTS `contest_problem`;

CREATE TABLE `contest_problem` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `display_id` varchar(255) NOT NULL COMMENT '该题目在比赛中的顺序id',
  `cid` bigint(20) unsigned NOT NULL COMMENT '比赛id',
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id',
  `display_title` varchar(255) NOT NULL COMMENT '该题目在比赛中的标题，默认为原名字',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`cid`,`pid`),
  UNIQUE KEY `display_id` (`display_id`,`cid`,`pid`),
  KEY `contest_problem_ibfk_1` (`cid`),
  KEY `contest_problem_ibfk_2` (`pid`),
  CONSTRAINT `contest_problem_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contest_problem_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `contest_record` */

DROP TABLE IF EXISTS `contest_record`;

CREATE TABLE `contest_record` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cid` bigint(20) unsigned DEFAULT NULL COMMENT '比赛id',
  `uid` varchar(255) NOT NULL COMMENT '用户id',
  `pid` bigint(20) unsigned DEFAULT NULL COMMENT '题目id',
  `cpid` bigint(20) unsigned DEFAULT NULL COMMENT '比赛中的题目的id',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `realname` varchar(255) DEFAULT NULL COMMENT '真实姓名',
  `display_id` varchar(255) DEFAULT NULL COMMENT '比赛中展示的id',
  `submit_id` bigint(20) unsigned NOT NULL COMMENT '提交id，用于可重判',
  `status` int(11) DEFAULT NULL COMMENT '提交结果，0表示未AC通过不罚时，1表示AC通过，-1为未AC通过算罚时',
  `submit_time` datetime NOT NULL COMMENT '具体提交时间',
  `time` bigint(20) unsigned DEFAULT NULL COMMENT '提交时间，为提交时间减去比赛时间',
  `score` int(11) DEFAULT NULL COMMENT 'OI比赛的得分',
  `first_blood` tinyint(1) DEFAULT '0' COMMENT '是否为一血AC',
  `checked` tinyint(1) DEFAULT '0' COMMENT 'AC是否已校验',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`submit_id`),
  KEY `uid` (`uid`),
  KEY `pid` (`pid`),
  KEY `cpid` (`cpid`),
  KEY `submit_id` (`submit_id`),
  KEY `index_cid` (`cid`),
  KEY `index_time` (`time`),
  CONSTRAINT `contest_record_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `contest_record_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `contest_record_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `contest_record_ibfk_4` FOREIGN KEY (`cpid`) REFERENCES `contest_problem` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `contest_record_ibfk_5` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

/*Table structure for table `contest_register` */

DROP TABLE IF EXISTS `contest_register`;

CREATE TABLE `contest_register` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cid` bigint(20) unsigned NOT NULL COMMENT '比赛id',
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `status` int(11) DEFAULT '0' COMMENT '默认为0表示正常，1为失效。',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`cid`,`uid`),
  UNIQUE KEY `cid_uid_unique` (`cid`,`uid`),
  KEY `contest_register_ibfk_2` (`uid`),
  CONSTRAINT `contest_register_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contest_register_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `contest_score` */

DROP TABLE IF EXISTS `contest_score`;

CREATE TABLE `contest_score` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cid` bigint(20) unsigned NOT NULL,
  `last` int(11) DEFAULT NULL COMMENT '比赛前的score得分',
  `change` int(11) DEFAULT NULL COMMENT 'Score比分变化',
  `now` int(11) DEFAULT NULL COMMENT '现在的score',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`cid`),
  KEY `contest_score_ibfk_1` (`cid`),
  CONSTRAINT `contest_score_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `discussion` */

DROP TABLE IF EXISTS `discussion`;

CREATE TABLE `discussion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL COMMENT '分类id',
  `title` varchar(255) DEFAULT NULL COMMENT '讨论标题',
  `description` varchar(255) DEFAULT NULL COMMENT '讨论简介',
  `content` longtext COMMENT '讨论内容',
  `pid` varchar(255) DEFAULT NULL COMMENT '关联题目id',
  `uid` varchar(32) NOT NULL COMMENT '发表者id',
  `author` varchar(255) NOT NULL COMMENT '发表者用户名',
  `avatar` varchar(255) DEFAULT NULL COMMENT '发表讨论者头像',
  `role` varchar(25) DEFAULT 'user' COMMENT '发表者角色',
  `view_num` int(11) DEFAULT '0' COMMENT '浏览数量',
  `like_num` int(11) DEFAULT '0' COMMENT '点赞数量',
  `top_priority` tinyint(1) DEFAULT '0' COMMENT '优先级，是否置顶',
  `status` int(1) DEFAULT '0' COMMENT '是否封禁该讨论',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `discussion_ibfk_4` (`avatar`),
  KEY `discussion_ibfk_1` (`uid`),
  KEY `pid` (`pid`),
  CONSTRAINT `discussion_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `discussion_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `discussion_ibfk_4` FOREIGN KEY (`avatar`) REFERENCES `user_info` (`avatar`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `discussion_ibfk_6` FOREIGN KEY (`pid`) REFERENCES `problem` (`problem_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `discussion_like` */

DROP TABLE IF EXISTS `discussion_like`;

CREATE TABLE `discussion_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `did` int(11) NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `did` (`did`),
  KEY `uid` (`uid`),
  CONSTRAINT `discussion_like_ibfk_1` FOREIGN KEY (`did`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `discussion_like_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `discussion_report` */

DROP TABLE IF EXISTS `discussion_report`;

CREATE TABLE `discussion_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `did` int(11) DEFAULT NULL COMMENT '讨论id',
  `reporter` varchar(255) DEFAULT NULL COMMENT '举报者的用户名',
  `content` varchar(255) NOT NULL COMMENT '举报内容',
  `status` tinyint(1) DEFAULT '0' COMMENT '是否已读',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `did` (`did`),
  KEY `reporter` (`reporter`),
  CONSTRAINT `discussion_report_ibfk_1` FOREIGN KEY (`did`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `discussion_report_ibfk_2` FOREIGN KEY (`reporter`) REFERENCES `user_info` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `file` */

DROP TABLE IF EXISTS `file`;

CREATE TABLE `file` (
  `id` bigint(32) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` varchar(32) DEFAULT NULL COMMENT '用户id',
  `name` varchar(255) NOT NULL COMMENT '文件名',
  `suffix` varchar(255) NOT NULL COMMENT '文件后缀格式',
  `folder_path` varchar(255) NOT NULL COMMENT '文件所在文件夹的路径',
  `file_path` varchar(255) DEFAULT NULL COMMENT '文件绝对路径',
  `type` varchar(255) DEFAULT NULL COMMENT '文件所属类型，例如avatar',
  `delete` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  CONSTRAINT `file_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

/*Table structure for table `judge` */

DROP TABLE IF EXISTS `judge`;

CREATE TABLE `judge` (
  `submit_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id',
  `display_pid` varchar(255) NOT NULL COMMENT '题目展示id',
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `submit_time` datetime NOT NULL COMMENT '提交的时间',
  `status` int(11) DEFAULT NULL COMMENT '结果码具体参考文档',
  `share` tinyint(1) DEFAULT '0' COMMENT '0为仅自己可见，1为全部人可见。',
  `error_message` mediumtext COMMENT '错误提醒（编译错误，或者vj提醒）',
  `time` int(11) DEFAULT NULL COMMENT '运行时间(ms)',
  `memory` int(11) DEFAULT NULL COMMENT '运行内存（kb）',
  `score` int(11) DEFAULT NULL COMMENT 'IO判题则不为空',
  `length` int(11) DEFAULT NULL COMMENT '代码长度',
  `code` longtext NOT NULL COMMENT '代码',
  `language` varchar(30) DEFAULT NULL COMMENT '代码语言',
  `cid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '比赛id，非比赛题目默认为0',
  `cpid` bigint(20) unsigned DEFAULT '0' COMMENT '比赛中题目排序id，非比赛题目默认为0',
  `judger` varchar(20) DEFAULT NULL COMMENT '判题机ip',
  `ip` varchar(20) DEFAULT NULL COMMENT '提交者所在ip',
  `version` int(11) NOT NULL DEFAULT '0' COMMENT '乐观锁',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`submit_id`,`pid`,`display_pid`,`uid`,`cid`),
  KEY `pid` (`pid`),
  KEY `uid` (`uid`),
  KEY `username` (`username`),
  CONSTRAINT `judge_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `judge_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `judge_ibfk_3` FOREIGN KEY (`username`) REFERENCES `user_info` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;

/*Table structure for table `judge_case` */

DROP TABLE IF EXISTS `judge_case`;

CREATE TABLE `judge_case` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submit_id` bigint(20) unsigned NOT NULL COMMENT '提交判题id',
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id',
  `case_id` bigint(20) DEFAULT NULL COMMENT '测试样例id',
  `status` int(11) DEFAULT NULL COMMENT '具体看结果码',
  `time` int(11) DEFAULT NULL COMMENT '测试该样例所用时间ms',
  `memory` int(11) DEFAULT NULL COMMENT '测试该样例所用空间KB',
  `score` int(11) DEFAULT NULL COMMENT 'IO得分',
  `input_data` longtext COMMENT '样例输入，比赛不可看',
  `output_data` longtext COMMENT '样例输出，比赛不可看',
  `user_output` longtext COMMENT '用户样例输出，比赛不可看',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`submit_id`,`uid`,`pid`),
  KEY `case_id` (`case_id`),
  KEY `judge_case_ibfk_1` (`uid`),
  KEY `judge_case_ibfk_2` (`pid`),
  KEY `judge_case_ibfk_3` (`submit_id`),
  CONSTRAINT `judge_case_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `judge_case_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `judge_case_ibfk_3` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

/*Table structure for table `judge_server` */

DROP TABLE IF EXISTS `judge_server`;

CREATE TABLE `judge_server` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '判题服务名字',
  `ip` varchar(255) NOT NULL COMMENT '判题机ip',
  `port` int(11) NOT NULL COMMENT '判题机端口号',
  `url` varchar(255) DEFAULT NULL COMMENT 'ip:port',
  `cpu_core` int(11) DEFAULT '0' COMMENT '判题机所在服务器cpu核心数',
  `task_number` int(11) NOT NULL DEFAULT '0' COMMENT '当前判题数',
  `max_task_number` int(11) NOT NULL COMMENT '判题并发最大数',
  `status` int(11) DEFAULT '0' COMMENT '0可用，1不可用',
  `version` bigint(20) DEFAULT '0' COMMENT '版本控制',
  `is_remote` tinyint(1) DEFAULT NULL COMMENT '是否为远程判题vj',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;

/*Table structure for table `language` */

DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content_type` varchar(255) DEFAULT NULL COMMENT '语言类型',
  `description` varchar(255) DEFAULT NULL COMMENT '语言描述',
  `name` varchar(255) DEFAULT NULL COMMENT '语言名字',
  `compile_command` mediumtext COMMENT '编译指令',
  `template` longtext COMMENT '模板',
  `code_template` longtext COMMENT '语言默认代码模板',
  `is_spj` tinyint(1) DEFAULT '0' COMMENT '是否可作为特殊判题的一种语言',
  `oj` varchar(255) DEFAULT NULL COMMENT '该语言属于哪个oj，自身oj用ME',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

/*Table structure for table `problem` */

DROP TABLE IF EXISTS `problem`;

CREATE TABLE `problem` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `problem_id` varchar(255) NOT NULL COMMENT '问题的自定义ID 例如（HOJ-1000）',
  `title` varchar(255) NOT NULL COMMENT '题目',
  `author` varchar(255) DEFAULT '未知' COMMENT '作者',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0为ACM,1为OI',
  `time_limit` int(11) DEFAULT '1000' COMMENT '单位ms',
  `memory_limit` int(11) DEFAULT '65535' COMMENT '单位kb',
  `description` longtext COMMENT '描述',
  `input` longtext COMMENT '输入描述',
  `output` longtext COMMENT '输出描述',
  `examples` longtext COMMENT '题面样例',
  `is_remote` tinyint(1) DEFAULT '0' COMMENT '是否为vj判题',
  `source` text COMMENT '题目来源',
  `difficulty` int(11) DEFAULT '0' COMMENT '题目难度,0简单，1中等，2困难',
  `hint` longtext COMMENT '备注,提醒',
  `auth` int(11) DEFAULT '1' COMMENT '默认为1公开，2为私有，3为比赛题目',
  `io_score` int(11) DEFAULT '100' COMMENT '当该题目为io题目时的分数',
  `code_share` tinyint(1) DEFAULT '1' COMMENT '该题目对应的相关提交代码，用户是否可用分享',
  `spj_code` longtext COMMENT '特判程序代码 空代表非特判',
  `spj_language` varchar(255) DEFAULT NULL COMMENT '特判程序的语言',
  `is_remove_end_blank` tinyint(1) DEFAULT '1' COMMENT '是否默认去除用户代码的文末空格',
  `open_case_result` tinyint(1) DEFAULT '1' COMMENT '是否默认开启该题目的测试样例结果查看',
  `case_version` varchar(40) DEFAULT '0' COMMENT '题目测试数据的版本号',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `author` (`author`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `problem_ibfk_1` FOREIGN KEY (`author`) REFERENCES `user_info` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1065 DEFAULT CHARSET=utf8;

/*Table structure for table `problem_case` */

DROP TABLE IF EXISTS `problem_case`;

CREATE TABLE `problem_case` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id',
  `input` longtext COMMENT '测试样例的输入',
  `output` longtext COMMENT '测试样例的输出',
  `score` int(11) DEFAULT NULL COMMENT '该测试样例的IO得分',
  `status` int(11) DEFAULT '0' COMMENT '0可用，1不可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  CONSTRAINT `problem_case_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;

/*Table structure for table `problem_count` */

DROP TABLE IF EXISTS `problem_count`;

CREATE TABLE `problem_count` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL,
  `total` int(10) unsigned DEFAULT '0',
  `ac` int(10) unsigned DEFAULT '0',
  `mle` int(10) unsigned DEFAULT '0' COMMENT '空间超限',
  `tle` int(10) unsigned DEFAULT '0' COMMENT '时间超限',
  `re` int(10) unsigned DEFAULT '0' COMMENT '运行错误',
  `pe` int(10) unsigned DEFAULT '0' COMMENT '格式错误',
  `ce` int(10) unsigned DEFAULT '0' COMMENT '编译错误',
  `wa` int(10) unsigned DEFAULT '0' COMMENT '答案错误',
  `se` int(10) unsigned DEFAULT '0' COMMENT '系统错误',
  `pa` int(11) DEFAULT '0' COMMENT '部分通过，OI题目',
  `version` bigint(20) NOT NULL DEFAULT '0' COMMENT '乐观锁',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`pid`),
  UNIQUE KEY `pid` (`pid`),
  CONSTRAINT `problem_count_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

/*Table structure for table `problem_language` */

DROP TABLE IF EXISTS `problem_language`;

CREATE TABLE `problem_language` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL,
  `lid` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `lid` (`lid`),
  CONSTRAINT `problem_language_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `problem_language_ibfk_2` FOREIGN KEY (`lid`) REFERENCES `language` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=786 DEFAULT CHARSET=utf8;

/*Table structure for table `problem_tag` */

DROP TABLE IF EXISTS `problem_tag`;

CREATE TABLE `problem_tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL,
  `tid` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `tid` (`tid`),
  CONSTRAINT `problem_tag_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `problem_tag_ibfk_2` FOREIGN KEY (`tid`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;

/*Table structure for table `reply` */

DROP TABLE IF EXISTS `reply`;

CREATE TABLE `reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) NOT NULL COMMENT '被回复的评论id',
  `from_uid` varchar(255) NOT NULL COMMENT '发起回复的用户id',
  `from_name` varchar(255) NOT NULL COMMENT '发起回复的用户名',
  `from_avatar` varchar(255) DEFAULT NULL COMMENT '发起回复的用户头像地址',
  `from_role` varchar(255) DEFAULT NULL COMMENT '发起回复的用户角色',
  `to_uid` varchar(255) NOT NULL COMMENT '被回复的用户id',
  `to_name` varchar(255) NOT NULL COMMENT '被回复的用户名',
  `to_avatar` varchar(255) DEFAULT NULL COMMENT '被回复的用户头像地址',
  `content` longtext COMMENT '回复的内容',
  `status` int(11) DEFAULT '0' COMMENT '是否封禁或逻辑删除该回复',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `comment_id` (`comment_id`),
  KEY `from_avatar` (`from_avatar`),
  KEY `to_avatar` (`to_avatar`),
  CONSTRAINT `reply_ibfk_1` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reply_ibfk_2` FOREIGN KEY (`from_avatar`) REFERENCES `user_info` (`avatar`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reply_ibfk_3` FOREIGN KEY (`to_avatar`) REFERENCES `user_info` (`avatar`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `role` varchar(50) NOT NULL COMMENT '角色',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '默认0可用，1不可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `role_auth` */

DROP TABLE IF EXISTS `role_auth`;

CREATE TABLE `role_auth` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `auth_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `auth_id` (`auth_id`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  CONSTRAINT `role_auth_ibfk_1` FOREIGN KEY (`auth_id`) REFERENCES `auth` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_auth_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

/*Table structure for table `session` */

DROP TABLE IF EXISTS `session`;

CREATE TABLE `session` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `user_agent` varchar(512) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;

/*Table structure for table `tag` */

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '标签名字',
  `color` varchar(10) DEFAULT NULL COMMENT '标签颜色',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

/*Table structure for table `user_acproblem` */

DROP TABLE IF EXISTS `user_acproblem`;

CREATE TABLE `user_acproblem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `pid` bigint(20) unsigned NOT NULL COMMENT 'ac的题目id',
  `submit_id` bigint(20) unsigned NOT NULL COMMENT '提交id',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `submit_id` (`submit_id`),
  KEY `uid` (`uid`),
  KEY `pid` (`pid`),
  CONSTRAINT `user_acproblem_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_acproblem_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_acproblem_ibfk_3` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=311 DEFAULT CHARSET=utf8;

/*Table structure for table `user_info` */

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
  `uuid` varchar(32) NOT NULL,
  `username` varchar(100) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(100) DEFAULT NULL COMMENT '昵称',
  `school` varchar(100) DEFAULT NULL COMMENT '学校',
  `course` varchar(100) DEFAULT NULL COMMENT '专业',
  `number` varchar(20) DEFAULT NULL COMMENT '学号',
  `realname` varchar(10) DEFAULT NULL COMMENT '真实姓名',
  `github` varchar(255) DEFAULT NULL COMMENT 'github地址',
  `blog` varchar(255) DEFAULT NULL COMMENT '博客地址',
  `cf_username` varchar(255) DEFAULT NULL COMMENT 'cf的username',
  `email` varchar(320) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `signature` mediumtext COMMENT '个性签名',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '0可用，1不可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `USERNAME_UNIQUE` (`username`),
  UNIQUE KEY `EMAIL_UNIQUE` (`email`),
  UNIQUE KEY `avatar` (`avatar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user_record` */

DROP TABLE IF EXISTS `user_record`;

CREATE TABLE `user_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `submissions` int(11) DEFAULT '0' COMMENT '总提交数',
  `total_score` int(11) DEFAULT '0' COMMENT 'IO题目总得分',
  `rating` int(11) DEFAULT NULL COMMENT 'cf得分',
  `version` int(11) DEFAULT '0' COMMENT '乐观锁',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`uid`),
  KEY `uid` (`uid`),
  CONSTRAINT `user_record_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=307 DEFAULT CHARSET=utf8;

/*Table structure for table `user_role` */

DROP TABLE IF EXISTS `user_role`;

CREATE TABLE `user_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8;

/* Trigger structure for table `contest` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `contest_trigger` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `contest_trigger` BEFORE INSERT ON `contest` FOR EACH ROW BEGIN
set new.status=(
	CASE 
	  WHEN NOW() < new.start_time THEN -1 
	  WHEN NOW() >= new.start_time AND NOW()<new.end_time THEN  0
	  WHEN NOW() >= new.end_time THEN 1
	END);
END */$$


DELIMITER ;

/*!50106 set global event_scheduler = 1*/;

/* Event structure for event `contest_event` */

/*!50106 DROP EVENT IF EXISTS `contest_event`*/;

DELIMITER $$

/*!50106 CREATE DEFINER=`root`@`localhost` EVENT `contest_event` ON SCHEDULE EVERY 1 SECOND STARTS '2021-04-18 19:04:49' ON COMPLETION PRESERVE ENABLE DO CALL contest_status() */$$
DELIMITER ;

/* Procedure structure for procedure `contest_status` */

/*!50003 DROP PROCEDURE IF EXISTS  `contest_status` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `contest_status`()
BEGIN
      UPDATE contest 
	SET STATUS = (
	CASE 
	  WHEN NOW() < start_time THEN -1 
	  WHEN NOW() >= start_time AND NOW()<end_time THEN  0
	  WHEN NOW() >= end_time THEN 1
	END);
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



/*Data for the table `auth` */

insert  into `auth`(`id`,`name`,`permission`,`status`,`gmt_create`,`gmt_modified`) values (1,'problem','problem_admin',0,'2020-10-25 00:17:17','2021-05-15 06:51:23'),(2,'submit','submit',0,'2020-10-25 00:17:22','2021-05-15 06:41:59'),(3,'contest','contest_admin',0,'2020-10-25 00:17:33','2021-05-15 06:51:28'),(4,'rejudge','rejudge',0,'2020-10-25 00:17:49','2021-05-15 06:50:55'),(5,'announcement','announcement_admin',0,'2021-05-15 06:54:28','2021-05-15 06:54:31'),(6,'user','user_admin',0,'2021-05-15 06:54:30','2021-05-15 06:55:04'),(7,'system_info','system_info_admin',0,'2021-05-15 06:57:34','2021-05-15 06:57:41'),(8,'dicussion','discussion_add',0,'2021-05-15 06:57:36','2021-05-15 07:50:45'),(9,'dicussion','discussion_del',0,'2021-05-15 07:01:02','2021-05-15 07:51:31'),(10,'dicussion','discussion_edit',0,'2021-05-15 07:02:15','2021-05-15 07:51:34'),(11,'comment','comment_add',0,'2021-05-15 07:03:48','2021-05-15 07:03:48'),(12,'reply','reply_add',0,'2021-05-15 07:04:55','2021-05-15 07:04:55');

/*Data for the table `category` */

insert  into `category`(`id`,`name`,`gmt_create`,`gmt_modified`) values (1,'闲聊','2021-05-06 11:25:24','2021-05-06 16:43:42'),(2,'题解','2021-05-06 11:25:36','2021-05-06 16:43:47'),(3,'求助','2021-05-06 11:25:40','2021-05-06 11:25:40'),(4,'建议','2021-05-06 11:25:56','2021-05-06 11:25:56'),(5,'记录','2021-05-06 11:26:02','2021-05-06 16:43:51');

/*Data for the table `language` */

insert  into `language`(`id`,`content_type`,`description`,`name`,`compile_command`,`template`,`code_template`,`is_spj`,`oj`,`gmt_create`,`gmt_modified`) values (1,'text/x-csrc','GCC 7.5.0','C','/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c11 {src_path} -lm -o {exe_path}','#include <stdio.h>\r\nint add(int a, int b) {\r\n    return a+b;\r\n}\r\nint main() {\r\n    printf(\"%d\", add(1, 2));    \r\n    return 0;\r\n}','//PREPEND BEGIN\r\n#include <stdio.h>\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\nint add(int a, int b) {\r\n  // Please fill this blank\r\n  return ___________;\r\n}\r\n//TEMPLATE END\r\n\r\n//APPEND BEGIN\r\nint main() {\r\n  printf(\"%d\", add(1, 2));\r\n  return 0;\r\n}\r\n//APPEND END',1,'ME','2020-12-12 23:11:44','2021-04-24 11:31:33'),(2,'text/x-c++src','G++ 7.5.0','C++','/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++14 {src_path} -lm -o {exe_path}','#include <iostream>\r\nint add(int a, int b) {\r\n    return a+b;\r\n}\r\nint main() {\r\n    std::cout << add(1, 2);\r\n    return 0;\r\n}','//PREPEND BEGIN\r\n#include <iostream>\r\nusing namespace std;\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\nint add(int a, int b) {\r\n  // Please fill this blank\r\n  return ___________;\r\n}\r\n//TEMPLATE END\r\n\r\n//APPEND BEGIN\r\nint main() {\r\n  cout << add(1, 2);\r\n  return 0;\r\n}\r\n//APPEND END',1,'ME','2020-12-12 23:12:44','2021-04-24 15:11:21'),(3,'text/x-java','OpenJDK 1.8','Java','/usr/bin/javac {src_path} -d {exe_dir} -encoding UTF8','import java.util.Scanner;\r\npublic class Main{\r\n    public static void main(String[] args){\r\n        Scanner in=new Scanner(System.in);\r\n        int a=in.nextInt();\r\n        int b=in.nextInt();\r\n        System.out.println((a+b));\r\n    }\r\n}','//PREPEND BEGIN\r\nimport java.util.Scanner;\r\n//PREPEND END\r\n\r\npublic class Main{\r\n    //TEMPLATE BEGIN\r\n    public static Integer add(int a,int b){\r\n        return _______;\r\n    }\r\n    //TEMPLATE END\r\n\r\n    //APPEND BEGIN\r\n    public static void main(String[] args){\r\n        System.out.println(add(a,b));\r\n    }\r\n    //APPEND END\r\n}\r\n',0,'ME','2020-12-12 23:12:51','2021-04-24 14:42:13'),(4,'text/x-python','Python 3.7.5','Python3','/usr/bin/python3 -m py_compile {src_path}','a, b = map(int, input().split())\r\nprint(a + b)','//PREPEND BEGIN\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\ndef add(a, b):\r\n    return a + b\r\n//TEMPLATE END\r\n\r\n\r\nif __name__ == \'__main__\':  \r\n    //APPEND BEGIN\r\n    a, b = 1, 1\r\n    print(add(a, b))\r\n    //APPEND END',0,'ME','2020-12-12 23:14:23','2021-04-24 14:53:53'),(5,'text/x-python','Python 2.7.17','Python2','/usr/bin/python -m py_compile {src_path}','a, b = map(int, raw_input().split())\r\nprint a+b','//PREPEND BEGIN\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\ndef add(a, b):\r\n    return a + b\r\n//TEMPLATE END\r\n\r\n\r\nif __name__ == \'__main__\':  \r\n    //APPEND BEGIN\r\n    a, b = 1, 1\r\n    print add(a, b)\r\n    //APPEND END',0,'ME','2021-01-26 11:11:44','2021-04-24 15:04:32'),(6,'text/x-csrc','GCC','GCC',NULL,NULL,NULL,0,'HDU','2021-02-18 21:32:34','2021-02-18 23:42:56'),(7,'text/x-c++src','G++','G++',NULL,NULL,NULL,0,'HDU','2021-02-18 21:32:58','2021-02-18 21:32:58'),(8,'text/x-c++src','C++','C++',NULL,NULL,NULL,0,'HDU','2021-02-18 21:33:11','2021-02-18 21:33:26'),(9,'text/x-csrc','C','C',NULL,NULL,NULL,0,'HDU','2021-02-18 21:33:41','2021-02-18 21:34:11'),(10,'text/x-pascal','Pascal','Pascal',NULL,NULL,NULL,0,'HDU','2021-02-18 21:34:33','2021-02-19 00:16:35'),(12,'text/x-csrc','GNU GCC C11 5.1.0','GNU GCC C11 5.1.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(13,'text/x-c++src','Clang++17 Diagnostics','Clang++17 Diagnostics',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(14,'text/x-c++src','GNU G++11 5.1.0','GNU G++11 5.1.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(15,'text/x-c++src','GNU G++14 6.4.0','GNU G++14 6.4.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(16,'text/x-c++src','GNU G++17 7.3.0','GNU G++17 7.3.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(17,'text/x-c++src','Microsoft Visual C++ 2010','Microsoft Visual C++ 2010',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(18,'text/x-c++src','Microsoft Visual C++ 2017','Microsoft Visual C++ 2017',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(19,'text/x-csharp','C# Mono 6.8','C# Mono 6.8',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:11:24'),(20,'text/x-d','D DMD32 v2.091.0','D DMD32 v2.091.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:11:15'),(21,'text/x-go','Go 1.15.6','Go 1.15.6',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:11:07'),(22,'text/x-haskell','Haskell GHC 8.10.1','Haskell GHC 8.10.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:58'),(23,'text/x-java','Java 1.8.0_241','Java 1.8.0_241',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:52'),(24,'text/x-java','Kotlin 1.4.0','Kotlin 1.4.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:45'),(25,'text/x-ocaml','OCaml 4.02.1','OCaml 4.02.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(26,'text/x-pascal','Delphi 7','Delphi 7',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(27,'text/x-pascal','Free Pascal 3.0.2','Free Pascal 3.0.2',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(28,'text/x-pascal','PascalABC.NET 3.4.2','PascalABC.NET 3.4.2',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(29,'text/x-perl','Perl 5.20.1','Perl 5.20.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(30,'text/x-php','PHP 7.2.13','PHP 7.2.13',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(31,'text/x-python','Python 2.7.18','Python 2.7.18',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:11'),(32,'text/x-python','Python 3.9.1','Python 3.9.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:09'),(33,'text/x-python','PyPy 2.7 (7.3.0)','PyPy 2.7 (7.3.0)',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:08'),(34,'text/x-python','PyPy 3.7 (7.3.0)','PyPy 3.7 (7.3.0)',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:06'),(35,'text/x-ruby','Ruby 3.0.0','Ruby 3.0.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:04'),(36,'text/x-rustsrc','Rust 1.49.0','Rust 1.49.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:02'),(37,'text/x-scala','Scala 2.12.8','Scala 2.12.8',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(38,'text/javascript','JavaScript V8 4.8.0','JavaScript V8 4.8.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(39,'text/javascript','Node.js 12.6.3','Node.js 12.6.3',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:09:56'),(40,'text/x-csharp','C# 8, .NET Core 3.1','C# 8, .NET Core 3.1',NULL,NULL,NULL,0,'CF','2021-03-25 21:17:39','2021-03-25 21:17:50'),(41,'text/x-java','Java 11.0.6','Java 11.0.6',NULL,NULL,NULL,0,'CF','2021-03-25 21:20:03','2021-03-25 21:20:08'),(42,'text/x-go','Golang 1.16','Golang','/usr/bin/go build -o {exe_path} {src_path}','package main\r\nimport \"fmt\"\r\n\r\nfunc main(){\r\n    var x int\r\n    var y int\r\n    fmt.Scanln(&x,&y)\r\n    fmt.Printf(\"%d\",x+y)  \r\n}\r\n','\r\npackage main\r\n\r\n//PREPEND BEGIN\r\nimport \"fmt\"\r\n//PREPEND END\r\n\r\n\r\n//TEMPLATE BEGIN\r\nfunc add(a,b int)int{\r\n    return ______\r\n}\r\n//TEMPLATE END\r\n\r\n//APPEND BEGIN\r\nfunc main(){\r\n    var x int\r\n    var y int\r\n    fmt.Printf(\"%d\",add(x,y))  \r\n}\r\n//APPEND END\r\n',0,'ME','2021-03-28 23:15:54','2021-04-24 15:00:50'),(43,'text/x-csharp','C# Mono 4.6.2','C#','/usr/bin/mcs -optimize+ -out:{exe_path} {src_path}','using System;\r\nusing System.Collections.Generic;\r\nusing System.Text;\r\nclass Solution\r\n{\r\n   static void Main(string[] args)\r\n   {\r\n       int a = int.Parse(Console.ReadLine());\r\n       int b = int.Parse(Console.ReadLine());\r\n       Console.WriteLine(a+b);\r\n   }\r\n}','//PREPEND BEGIN\r\nusing System;\r\nusing System.Collections.Generic;\r\nusing System.Text;\r\n//PREPEND END\r\n\r\nclass Solution\r\n{\r\n    //TEMPLATE BEGIN\r\n    static int add(int a,int b){\r\n        return _______;\r\n    }\r\n    //TEMPLATE END\r\n\r\n    //APPEND BEGIN\r\n    static void Main(string[] args)\r\n    {\r\n        int a ;\r\n        int b ;\r\n        Console.WriteLine(add(a,b));\r\n    }\r\n    //APPEND END\r\n}',0,'ME','2021-04-13 16:10:03','2021-04-24 16:24:02');

/*Data for the table `role` */

insert  into `role`(`id`,`role`,`description`,`status`,`gmt_create`,`gmt_modified`) values (00000000000000001000,'root','超级管理员',0,'2020-10-25 00:16:30','2020-10-25 00:16:30'),(00000000000000001001,'admin','管理员',0,'2020-10-25 00:16:41','2020-10-25 00:16:41'),(00000000000000001002,'default_user','默认用户',0,'2020-10-25 00:16:52','2021-05-15 07:39:05'),(00000000000000001003,'no_subimit_user','禁止提交用户',0,'2021-05-15 07:10:14','2021-05-15 07:39:14'),(00000000000000001004,'no_discuss_user','禁止发贴讨论用户',0,'2021-05-15 07:11:28','2021-05-15 07:39:16'),(00000000000000001005,'mute_user','禁言包括回复讨论发帖用户',0,'2021-05-15 07:12:51','2021-05-15 07:39:19'),(00000000000000001006,'no_submit_no_discuss_user','禁止提交同时禁止发帖用户',0,'2021-05-15 07:38:08','2021-05-15 07:39:34'),(00000000000000001007,'no_submit_mute_user','禁言禁提交用户',0,'2021-05-15 07:39:00','2021-05-15 07:39:26');

/*Data for the table `role_auth` */

insert  into `role_auth`(`id`,`auth_id`,`role_id`,`gmt_create`,`gmt_modified`) values (1,1,1000,'2020-10-25 00:18:17','2020-10-25 00:18:17'),(2,2,1000,'2020-10-25 00:18:38','2021-05-15 07:17:35'),(3,3,1000,'2020-10-25 00:18:48','2021-05-15 07:17:44'),(4,4,1000,'2021-05-15 07:17:56','2021-05-15 07:17:56'),(5,5,1000,'2021-05-15 07:18:20','2021-05-15 07:18:20'),(6,6,1000,'2021-05-15 07:18:29','2021-05-15 07:18:29'),(7,7,1000,'2021-05-15 07:18:42','2021-05-15 07:18:42'),(8,8,1000,'2021-05-15 07:18:59','2021-05-15 07:18:59'),(9,9,1000,'2021-05-15 07:19:07','2021-05-15 07:19:07'),(10,10,1000,'2021-05-15 07:19:10','2021-05-15 07:19:10'),(11,11,1000,'2021-05-15 07:19:13','2021-05-15 07:19:13'),(12,12,1000,'2021-05-15 07:19:18','2021-05-15 07:19:30'),(13,1,1001,'2021-05-15 07:19:29','2021-05-15 07:20:02'),(14,2,1001,'2021-05-15 07:20:25','2021-05-15 07:20:25'),(15,3,1001,'2021-05-15 07:20:33','2021-05-15 07:20:33'),(16,8,1001,'2021-05-15 07:21:56','2021-05-15 07:21:56'),(17,9,1001,'2021-05-15 07:22:03','2021-05-15 07:22:03'),(18,10,1001,'2021-05-15 07:22:10','2021-05-15 07:22:10'),(19,11,1001,'2021-05-15 07:22:17','2021-05-15 07:22:17'),(20,12,1001,'2021-05-15 07:22:21','2021-05-15 07:22:21'),(21,2,1002,'2021-05-15 07:22:40','2021-05-15 07:22:40'),(22,8,1002,'2021-05-15 07:23:49','2021-05-15 07:23:49'),(23,9,1002,'2021-05-15 07:24:10','2021-05-15 07:24:10'),(24,10,1002,'2021-05-15 07:24:14','2021-05-15 07:24:14'),(25,11,1002,'2021-05-15 07:24:19','2021-05-15 07:24:19'),(26,12,1002,'2021-05-15 07:24:23','2021-05-15 07:24:23'),(27,8,1003,'2021-05-15 07:32:56','2021-05-15 07:32:56'),(28,9,1003,'2021-05-15 07:33:01','2021-05-15 07:33:01'),(29,10,1003,'2021-05-15 07:33:05','2021-05-15 07:33:05'),(30,11,1003,'2021-05-15 07:33:09','2021-05-15 07:33:09'),(31,12,1003,'2021-05-15 07:33:22','2021-05-15 07:33:22'),(32,2,1004,'2021-05-15 07:33:38','2021-05-15 07:33:38'),(33,9,1004,'2021-05-15 07:34:27','2021-05-15 07:34:27'),(34,10,1004,'2021-05-15 07:34:31','2021-05-15 07:34:31'),(35,11,1004,'2021-05-15 07:34:42','2021-05-15 07:34:42'),(36,12,1004,'2021-05-15 07:34:47','2021-05-15 07:34:47'),(37,2,1005,'2021-05-15 07:35:11','2021-05-15 07:35:11'),(38,9,1005,'2021-05-15 07:35:46','2021-05-15 07:35:46'),(39,10,1005,'2021-05-15 07:36:01','2021-05-15 07:36:01'),(40,9,1006,'2021-05-15 07:40:09','2021-05-15 07:40:09'),(41,10,1006,'2021-05-15 07:40:16','2021-05-15 07:40:16'),(42,11,1006,'2021-05-15 07:40:30','2021-05-15 07:40:30'),(43,12,1006,'2021-05-15 07:40:37','2021-05-15 07:40:37'),(44,9,1007,'2021-05-15 07:40:54','2021-05-15 07:40:54'),(45,10,1007,'2021-05-15 07:41:04','2021-05-15 07:41:04');