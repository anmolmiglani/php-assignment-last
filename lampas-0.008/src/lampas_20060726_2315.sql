-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	4.1.11-Debian_4sarge2-log


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema lampas
--

DROP DATABASE lampas;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ lampas;
USE lampas;

--
-- Table structure for table `lampas`.`deployment_definitions`
--

DROP TABLE IF EXISTS `deployment_definitions`;
CREATE TABLE `deployment_definitions` (
  `did` int(10) unsigned NOT NULL auto_increment,
  `pid` int(10) unsigned NOT NULL default '1',
  `branch` int(10) unsigned NOT NULL default '1',
  `version` int(10) unsigned NOT NULL default '1',
  `live_date` datetime NOT NULL default '0000-00-00 00:00:00',
  `auth_status` tinyint(3) unsigned NOT NULL default '0',
  `notes` text,
  `log` text,
  `uri` varchar(255) default NULL,
  PRIMARY KEY  (`did`,`pid`,`branch`,`version`,`live_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`deployment_definitions`
--

/*!40000 ALTER TABLE `deployment_definitions` DISABLE KEYS */;
INSERT INTO `deployment_definitions` (`did`,`pid`,`branch`,`version`,`live_date`,`auth_status`,`notes`,`log`,`uri`) VALUES 
 (1,1,1,1,'2006-07-23 20:22:35',1,NULL,NULL,'/'),
 (1,1,1,1,'2006-07-23 20:36:56',1,NULL,NULL,'/app'),
 (3,3,1,1,'2006-07-26 17:52:00',1,NULL,NULL,'/logon'),
 (2,4,1,1,'2006-07-26 17:52:28',1,NULL,NULL,'/logout');
/*!40000 ALTER TABLE `deployment_definitions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`deployment_systems`
--

DROP TABLE IF EXISTS `deployment_systems`;
CREATE TABLE `deployment_systems` (
  `did` int(10) unsigned NOT NULL default '1',
  `sid` int(10) unsigned NOT NULL default '1',
  `status` tinyint(3) unsigned NOT NULL default '0',
  `notes` text,
  `domid` int(10) unsigned default NULL,
  PRIMARY KEY  (`did`,`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`deployment_systems`
--

/*!40000 ALTER TABLE `deployment_systems` DISABLE KEYS */;
INSERT INTO `deployment_systems` (`did`,`sid`,`status`,`notes`,`domid`) VALUES 
 (1,1,1,NULL,1),
 (2,1,1,NULL,1),
 (3,1,1,NULL,1);
/*!40000 ALTER TABLE `deployment_systems` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`domain_definitions`
--

DROP TABLE IF EXISTS `domain_definitions`;
CREATE TABLE `domain_definitions` (
  `domid` int(10) unsigned NOT NULL auto_increment,
  `domain_name` varchar(64) NOT NULL default '',
  `admin_gid` int(10) unsigned NOT NULL default '1',
  `created_on` datetime NOT NULL default '0000-00-00 00:00:00',
  `status` tinyint(3) unsigned NOT NULL default '0',
  `notes` text,
  `key` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`domid`),
  UNIQUE KEY `idx_domain_names` (`domain_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`domain_definitions`
--

/*!40000 ALTER TABLE `domain_definitions` DISABLE KEYS */;
INSERT INTO `domain_definitions` (`domid`,`domain_name`,`admin_gid`,`created_on`,`status`,`notes`,`key`) VALUES 
 (1,'lampas.tld',1,'2006-07-21 14:53:06',1,NULL,'df5ea29924d39c3be8785734f13169c6');
/*!40000 ALTER TABLE `domain_definitions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`domain_deployments`
--

DROP TABLE IF EXISTS `domain_deployments`;
CREATE TABLE `domain_deployments` (
  `sid` int(10) unsigned NOT NULL default '1',
  `domid` int(10) unsigned NOT NULL default '1',
  `deploy_bind_config` tinyint(3) unsigned NOT NULL default '0',
  `notes` text,
  UNIQUE KEY `idx_domain_deployments` (`sid`,`domid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`domain_deployments`
--

/*!40000 ALTER TABLE `domain_deployments` DISABLE KEYS */;
INSERT INTO `domain_deployments` (`sid`,`domid`,`deploy_bind_config`,`notes`) VALUES 
 (1,1,1,NULL);
/*!40000 ALTER TABLE `domain_deployments` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`domain_dns_config`
--

DROP TABLE IF EXISTS `domain_dns_config`;
CREATE TABLE `domain_dns_config` (
  `domid` int(10) unsigned NOT NULL default '0',
  `entry_type` set('A','MX','CNAME','NS','EXPIRE','SERIAL') NOT NULL default 'A',
  `entry_key` varchar(64) NOT NULL default '',
  `notes` text,
  `entry_value` varchar(64) NOT NULL default '',
  UNIQUE KEY `idx_domain_dns_config` TYPE BTREE (`domid`,`entry_type`,`entry_key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`domain_dns_config`
--

/*!40000 ALTER TABLE `domain_dns_config` DISABLE KEYS */;
INSERT INTO `domain_dns_config` (`domid`,`entry_type`,`entry_key`,`notes`,`entry_value`) VALUES 
 (1,'A','mail',NULL,'127.0.0.1'),
 (1,'A','www',NULL,'127.0.0.1'),
 (1,'MX','10',NULL,'mail.lampas.tld'),
 (1,'NS','-',NULL,'127.0.0.1');
/*!40000 ALTER TABLE `domain_dns_config` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`domain_properties`
--

DROP TABLE IF EXISTS `domain_properties`;
CREATE TABLE `domain_properties` (
  `domid` int(10) unsigned NOT NULL default '0',
  `key` varchar(32) NOT NULL default '',
  `value` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`domid`,`key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`domain_properties`
--

/*!40000 ALTER TABLE `domain_properties` DISABLE KEYS */;
INSERT INTO `domain_properties` (`domid`,`key`,`value`,`description`) VALUES 
 (1,'logon_uri','/logon','This is our logon HTML page'),
 (1,'logout_uri','/logout','This is our logout HTML page');
/*!40000 ALTER TABLE `domain_properties` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`lookup_global_config`
--

DROP TABLE IF EXISTS `lookup_global_config`;
CREATE TABLE `lookup_global_config` (
  `key` varchar(32) NOT NULL default '',
  `value` varchar(255) default NULL,
  `value_type` set('integer','string','csv','ip-int','other') NOT NULL default 'other',
  `comment` varchar(255) default NULL,
  PRIMARY KEY  (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`lookup_global_config`
--

/*!40000 ALTER TABLE `lookup_global_config` DISABLE KEYS */;
INSERT INTO `lookup_global_config` (`key`,`value`,`value_type`,`comment`) VALUES 
 ('lampas-client-dbhost','127.0.0.1','string','The LAMPAS Client DB Host'),
 ('lampas-client-dbport','3306','integer','The LAMPAS Client DB Port'),
 ('lampas-client-dbuser','lampas-client-user','string','The LAMPAS Client DB Username'),
 ('lampas-client-dbpass','abc123xyz','string','The LAMPAS Client DB Password'),
 ('lampas-client-db_dbi-driver','mysql','string','The LAMPAS Client DB Driver for the Perl DBI Module');
/*!40000 ALTER TABLE `lookup_global_config` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`lookup_os_names`
--

DROP TABLE IF EXISTS `lookup_os_names`;
CREATE TABLE `lookup_os_names` (
  `osname` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL default 'Not defined',
  `logo` blob,
  `notes` text,
  PRIMARY KEY  (`osname`),
  UNIQUE KEY `idx_osname` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`lookup_os_names`
--

/*!40000 ALTER TABLE `lookup_os_names` DISABLE KEYS */;
INSERT INTO `lookup_os_names` (`osname`,`name`,`logo`,`notes`) VALUES 
 (1,'Linux',NULL,NULL),
 (2,'OpenBSD',NULL,NULL),
 (3,'FreeBSD',NULL,NULL),
 (4,'Solaris',NULL,NULL),
 (5,'MS Windows',NULL,NULL);
/*!40000 ALTER TABLE `lookup_os_names` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_bundles`
--

DROP TABLE IF EXISTS `package_bundles`;
CREATE TABLE `package_bundles` (
  `pbid` int(10) unsigned NOT NULL default '0',
  `pid` int(10) unsigned NOT NULL default '1',
  `branch` int(10) unsigned NOT NULL default '1',
  `version` int(10) unsigned NOT NULL default '1',
  UNIQUE KEY `idx_package_bundles` (`pbid`,`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_bundles`
--

/*!40000 ALTER TABLE `package_bundles` DISABLE KEYS */;
/*!40000 ALTER TABLE `package_bundles` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_bundles_definitions`
--

DROP TABLE IF EXISTS `package_bundles_definitions`;
CREATE TABLE `package_bundles_definitions` (
  `pbid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(16) NOT NULL default '',
  `description` varchar(255) default NULL,
  `notes` text,
  PRIMARY KEY  (`pbid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_bundles_definitions`
--

/*!40000 ALTER TABLE `package_bundles_definitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `package_bundles_definitions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_checkout`
--

DROP TABLE IF EXISTS `package_checkout`;
CREATE TABLE `package_checkout` (
  `pid` int(11) unsigned NOT NULL default '1',
  `version` int(11) unsigned NOT NULL default '1',
  `branch` int(11) unsigned NOT NULL default '1',
  `co_timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `uid` int(11) unsigned NOT NULL default '1',
  `eta` datetime default NULL,
  KEY `idx_co_id` (`pid`,`version`,`branch`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_checkout`
--

/*!40000 ALTER TABLE `package_checkout` DISABLE KEYS */;
/*!40000 ALTER TABLE `package_checkout` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_definition`
--

DROP TABLE IF EXISTS `package_definition`;
CREATE TABLE `package_definition` (
  `pid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(32) NOT NULL default '',
  `description` varchar(255) default NULL,
  `createdate` datetime NOT NULL default '0000-00-00 00:00:00',
  `status` tinyint(4) unsigned default '0',
  KEY `PK` (`pid`),
  KEY `idx_byname` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_definition`
--

/*!40000 ALTER TABLE `package_definition` DISABLE KEYS */;
INSERT INTO `package_definition` (`pid`,`name`,`description`,`createdate`,`status`) VALUES 
 (1,'LAMPAS Index','The LAMPAS Index Page','2006-07-19 22:16:37',1),
 (2,'package_commit.pl','Upload package source code from disk to the DB.','2006-07-26 15:54:38',1),
 (3,'LAMPAS User Login','This is where LAMPAS users will logon','2006-07-26 17:47:05',1),
 (4,'LAMPAS User Logout','This is where LAMPAS users will logout','2006-07-26 17:47:22',1);
/*!40000 ALTER TABLE `package_definition` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_log`
--

DROP TABLE IF EXISTS `package_log`;
CREATE TABLE `package_log` (
  `pid` int(11) unsigned NOT NULL default '0',
  `entry_timestamp` datetime default NULL,
  `event_type` set('Package Create','Commit','Check Out','View','Properties Modify','Status Change','Delete','Src Downloaded','User Entry','Version Control','Permissions Update','Definition Update','Other') NOT NULL default 'Other',
  `message` varchar(255) default NULL,
  `notes` text,
  KEY `idx_package_log_pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_log`
--

/*!40000 ALTER TABLE `package_log` DISABLE KEYS */;
INSERT INTO `package_log` (`pid`,`entry_timestamp`,`event_type`,`message`,`notes`) VALUES 
 (1,'2006-07-19 22:20:00','Package Create','Package ID 1 Created Succesfully',NULL),
 (1,'2006-07-19 22:24:50','Properties Modify','Added initial properties for package',NULL);
/*!40000 ALTER TABLE `package_log` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_permisssions`
--

DROP TABLE IF EXISTS `package_permisssions`;
CREATE TABLE `package_permisssions` (
  `pid` int(11) unsigned NOT NULL default '0',
  `idtype` set('User','Group','All') NOT NULL default '',
  `id` int(11) unsigned NOT NULL default '1',
  `flags` varchar(32) NOT NULL default '',
  `log_entry` varchar(255) NOT NULL default 'Permissions Updated',
  `notes` text,
  KEY `idx_package_perms_id` (`pid`,`idtype`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_permisssions`
--

/*!40000 ALTER TABLE `package_permisssions` DISABLE KEYS */;
INSERT INTO `package_permisssions` (`pid`,`idtype`,`id`,`flags`,`log_entry`,`notes`) VALUES 
 (1,'User',1,'11111100000000000000000000000000','Super User Access for UID 1 on this resource',NULL),
 (3,'All',0,'00000100000000000000000000000000','Public execute permissions for this page',NULL),
 (4,'All',0,'00000100000000000000000000000000','Public execute permissions for this page',NULL),
 (1,'Group',2,'00000100000000000000000000000000','General User Access for GID 1 on this resource',NULL);
/*!40000 ALTER TABLE `package_permisssions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_properties`
--

DROP TABLE IF EXISTS `package_properties`;
CREATE TABLE `package_properties` (
  `pid` int(11) unsigned NOT NULL default '0',
  `tos` set('xinetd','LAMP','Stand-alone') NOT NULL default 'LAMP',
  `src_type` set('Script','Binary') NOT NULL default 'Script',
  `MIME_type` varchar(32) NOT NULL default 'text/html',
  `max_memory` int(11) unsigned NOT NULL default '8192',
  `max_input_buffer` int(11) unsigned NOT NULL default '1024',
  `run_time_out` int(11) unsigned NOT NULL default '60',
  `schedule` varchar(255) default NULL,
  `env` varchar(255) default NULL,
  `deploydir` varchar(255) default NULL,
  `log_type` set('syslog','file','none') NOT NULL default 'syslog',
  `log_dest` varchar(255) default NULL,
  `schedule_dependency` int(11) unsigned NOT NULL default '0',
  `run_as_user` varchar(32) default NULL,
  `apache_handler` set('Default','ChildInit','PostReadRequest','Init','Trans','HeaderParser','Access','Authen','Authz','Type','Fixup','Log','Cleanup','ChildExit') default NULL,
  `dependencies` text,
  `tos_template` int(10) unsigned default NULL,
  PRIMARY KEY  (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_properties`
--

/*!40000 ALTER TABLE `package_properties` DISABLE KEYS */;
INSERT INTO `package_properties` (`pid`,`tos`,`src_type`,`MIME_type`,`max_memory`,`max_input_buffer`,`run_time_out`,`schedule`,`env`,`deploydir`,`log_type`,`log_dest`,`schedule_dependency`,`run_as_user`,`apache_handler`,`dependencies`,`tos_template`) VALUES 
 (1,'LAMP','Script','text/html',8192,1024,60,NULL,NULL,NULL,'syslog',NULL,0,NULL,'Default',NULL,NULL),
 (2,'Stand-alone','Script','text/html',8192,1024,60,NULL,NULL,'/opt/lampas/bin/','none',NULL,0,NULL,NULL,NULL,NULL),
 (3,'LAMP','Script','text/html',8192,1024,60,NULL,NULL,NULL,'syslog',NULL,0,NULL,'Default',NULL,NULL),
 (4,'LAMP','Script','text/html',8192,1024,60,NULL,NULL,NULL,'syslog',NULL,0,NULL,'Default',NULL,NULL);
/*!40000 ALTER TABLE `package_properties` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_src`
--

DROP TABLE IF EXISTS `package_src`;
CREATE TABLE `package_src` (
  `pid` int(11) unsigned NOT NULL default '0',
  `version` int(11) unsigned NOT NULL default '0',
  `branch` int(11) unsigned NOT NULL default '1',
  `entrytimestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `uploadedby` int(11) unsigned NOT NULL default '0',
  `releasenotes` text,
  `documentation` text,
  `src` blob NOT NULL,
  `changelog` text,
  PRIMARY KEY  (`pid`,`version`,`branch`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_src`
--

/*!40000 ALTER TABLE `package_src` DISABLE KEYS */;
INSERT INTO `package_src` (`pid`,`version`,`branch`,`entrytimestamp`,`uploadedby`,`releasenotes`,`documentation`,`src`,`changelog`) VALUES 
 (1,1,1,'2006-07-23 20:16:31',1,NULL,NULL,0x72657475726E20223C68746D6C3E3C686561643E3C7469746C653E4C414D50415320496E64657820506167653C2F7469746C653E3C2F686561643E3C626F64793E3C68333E4C414D50415320496E64657820506167653C2F68333E3C68723E3C2F626F64793E3C2F68746D6C3E223B,NULL),
 (1,2,1,'2006-07-26 15:03:28',1,NULL,NULL,0x72657475726E20223C68746D6C3E3C686561643E3C7469746C653E4C414D50415320496E64657820506167653C2F7469746C653E3C2F686561643E3C626F64793E3C68333E4C414D50415320496E64657820506167653C2F68333E3C68723E3C703E52656C6561736520302E303037206973206E6F7720696E20746865206D616B696E672E2E2E3C2F703E3C2F626F64793E3C2F68746D6C3E22,NULL),
 (2,1,1,'2006-07-26 15:52:11',1,NULL,NULL,0x23212F7573722F62696E2F7065726C0A0A757365207374726963743B0A0A232046756E6374696F6E3A2055706C6F616420736F7572636520636F646520696E746F207468652044422C207769746820706172616D65746572732E20546869732070726F6772616D20666F6C6C6F77732051264120617070726F6163680A0A757365204442493B0A6D79202464626831093D204442492D3E636F6E6E6563742820226462693A6D7973716C3A64617461626173653D6C616D7061733B686F73743D3132372E302E302E313B706F72743D33333036222C202275736572222C20222220293B0A0A6D79202470696409093D2024415247565B305D3B09232047657420746865205049442066726F6D2074686520636F6D6D616E646C696E6520617267730A6D7920246272616E6368093D20313B09092320536574207468652064656661756C74206272616E63680A6D79202476657273696F6E093D20313B09092320536574207468652064656661756C742076657273696F6E0A0A69662820247069642029207B0A0A09232047657420746865206272616E636865730A096D7920256272616E63687365656E093D2028293B0A096D79202473716C31093D202253454C4543542044495354494E435420606272616E6368602046524F4D20607061636B6167655F73726360205748455245206070696460203D2031223B0A096D79202473746831093D2024646268312D3E7072657061726528202473716C3120293B0A0924737468312D3E6578656375746528293B0A097072696E74202253656C656374206F6E65206F662074686520666F6C6C6F77696E67206272616E636865733A5C6E5C6E223B0A097768696C6528206D79202464626272616E6368203D2024737468312D3E6665746368726F775F617272617928292029207B0A090A09097072696E7420225C742464626272616E63685C6E223B0A0909246272616E63687365656E7B202464626272616E6368207D2B2B3B0A09090A090A097D0A090A097072696E7420225C6E53656C656374696F6E3A20223B0A096D792024696E707574093D203C535444494E3E3B0A0963686F6D70282024696E70757420293B0A0924696E70757409093D7E202F285C642B292F3B0A09246272616E636809093D2024313B0A0969662820246272616E63687365656E7B20246272616E6368207D2029207B0A090A0909232067657420746865206C6173742076657273696F6E206E756D62657220666F722074686973206272616E63680A09097072696E7420225C6E52657472696576696E6720746865206C6173742076657273696F6E206E756D62657220666F72206272616E63682024696E707574203A5C6E5C6E223B0A09096D79202473716C32093D202253454C454354206076657273696F6E602046524F4D20607061636B6167655F73726360205748455245206070696460203D202470696420414E4420606272616E636860203D20246272616E6368204F52444552204259206076657273696F6E602044455343204C494D495420302C31223B0A09096D79202473746832093D2024646268312D3E7072657061726528202473716C3220293B0A09096966282024737468322D3E6578656375746528292029207B0A09090A0909097768696C6528206D792024646276657273696F6E203D2024737468322D3E6665746368726F775F617272617928292029207B0A09090A090909097072696E7420225C744C6173742076657273696F6E206E756D62657220202020202020203A2024646276657273696F6E5C6E223B0A090909092476657273696F6E093D2024646276657273696F6E202B20313B0A090909097072696E7420225C744E6578742076657273696F6E206E756D6265722073657420746F203A202476657273696F6E5C6E5C6E223B0A09090A0909097D0A09090A09097D20656C7365207B0A09090A0909097072696E742053544445525220224442204572726F72205B3030315D2E2051756974696E672E5C6E5C6E223B0A090909657869743B0A09090A09097D0A090A097D20656C7365207B0A090A09097072696E742053544445525220224974207365656D7320746865726520697320616E206572726F72207769746820796F75722073656C656374696F6E2E20506C656173652072652D72756E20746869732073637269707420616E642074727920616761696E2E5C6E5C6E223B0A0909657869743B0A090A097D0A0A0A7D20656C7365207B0A0A097072696E74205354444552522022596F75206D75737420737570706C7920612050494420617320746865206F6E6C7920706172616D657465722E5C6E5C6E223B0A09657869743B0A0A7D0A0A7072696E742022506C6561736520737570706C792074686520636F6D706C657465207061746820616E642066696C656E616D65206F66207468652066696C6520746F20636F6D6D69743A5C6E5C743E20223B0A6D792024696E707574093D203C535444494E3E3B0A63686F6D70282024696E70757420293B0A696628202D652024696E7075742029207B0A0A096D7920247372633B0A096F70656E2820494E462C20223C2024696E7075742220293B0A097768696C6528203C494E463E2029207B0A090A090924737263092E3D20245F3B0A090A097D0A09636C6F73652820494E4620293B0A090A0924737263093D2024646268312D3E71756F746528202473726320293B092320457363617065206F757220736F7572636520636F6465202D20746869732077696C6C206573636170652063686172616374657273206C696B65202720616E64202220616E642026202849207468696E6B290A090A0924646268312D3E646F282022696E7365727420696E746F207061636B6167655F73726320282060706964602C206076657273696F6E602C20606272616E6368602C2060656E74727974696D657374616D70602C206075706C6F616465646279602C20607372636020292076616C756573202820247069642C202476657273696F6E2C20246272616E63682C204E4F5728292C20312C202473726320292220293B0A0A7D20656C7365207B0A0A097072696E74205354444552522022536F727279202D206974207365656D73207468652066696C6520646F6573206E6F742065786973747320796574202866696C653A2024696E707574295C6E5C6E223B0A09657869743B0A0A7D0A,NULL),
 (3,1,1,'2006-07-26 21:15:25',1,NULL,NULL,0x72657475726E20223C68746D6C3E3C686561643E3C7469746C653E4C414D504153204C4F474F4E3C2F7469746C653E3C2F686561643E3C626F64793E3C68333E4C414D504153204C4F474F4E3C2F68333E3C68723E3C703E5468697320697320776F726B20696E2070726F67726573733C2F703E3C2F626F64793E3C2F68746D6C3E223B,NULL);
INSERT INTO `package_src` (`pid`,`version`,`branch`,`entrytimestamp`,`uploadedby`,`releasenotes`,`documentation`,`src`,`changelog`) VALUES 
 (4,1,1,'2006-07-26 21:15:49',1,NULL,NULL,0x72657475726E20223C68746D6C3E3C686561643E3C7469746C653E4C414D504153204C4F474F55543C2F7469746C653E3C2F686561643E3C626F64793E3C68333E4C414D504153204C4F474F55543C2F68333E3C68723E3C703E5468697320697320776F726B20696E2070726F67726573733C2F703E3C2F626F64793E3C2F68746D6C3E223B,NULL);
/*!40000 ALTER TABLE `package_src` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`package_tos_templates`
--

DROP TABLE IF EXISTS `package_tos_templates`;
CREATE TABLE `package_tos_templates` (
  `tid` int(10) unsigned NOT NULL auto_increment,
  `tos` set('xinetd','LAMP','Stand-alone') NOT NULL default 'LAMP',
  `default_apache_handler` set('Default','ChildInit','PostReadRequest','Init','Trans','HeaderParser','Access','Authen','Authz','Type','Fixup','Log','Cleanup','ChildExit') NOT NULL default 'Default',
  `name` varchar(32) NOT NULL default '',
  `description` varchar(255) default NULL,
  `notes` text,
  `src` text,
  PRIMARY KEY  (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`package_tos_templates`
--

/*!40000 ALTER TABLE `package_tos_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `package_tos_templates` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`session_log`
--

DROP TABLE IF EXISTS `session_log`;
CREATE TABLE `session_log` (
  `session_id` int(10) unsigned NOT NULL default '0',
  `uid` int(10) unsigned NOT NULL default '0',
  `domid` int(10) unsigned NOT NULL default '1',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `referer` varchar(255) default NULL,
  `target` varchar(255) NOT NULL default '',
  `cookies` text,
  `authstatus` tinyint(3) unsigned NOT NULL default '0',
  `log_msg` varchar(255) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`session_log`
--

/*!40000 ALTER TABLE `session_log` DISABLE KEYS */;
INSERT INTO `session_log` (`session_id`,`uid`,`domid`,`timestamp`,`referer`,`target`,`cookies`,`authstatus`,`log_msg`) VALUES 
 (0,0,1,'2006-07-25 23:05:07','','/app/','',1,'This resource has PUBLIC execute rights.'),
 (0,0,1,'2006-07-25 23:06:31','http://www.lampas.tld/index.html','/app','',1,'This resource has PUBLIC execute rights.'),
 (0,0,1,'2006-07-26 22:02:00','','/app','',0,'Redirect did=1 to target=/logon'),
 (0,0,1,'2006-07-26 22:08:31','http://www.lampas.tld/index.html','/app','',0,'Redirect did=1 to target=/logon'),
 (0,0,1,'2006-07-26 22:51:48','','/app','',0,'Redirect did=1 to target=/logon'),
 (0,0,1,'2006-07-26 22:53:35','http://www.lampas.tld/index.html','/app','',0,'Redirect did=1 to target=/logon'),
 (0,0,1,'2006-07-26 22:53:35','http://www.lampas.tld/index.html','/logon','',1,'This resource has PUBLIC execute rights.'),
 (0,0,1,'2006-07-26 22:57:29','http://www.lampas.tld/index.html','/logon','',1,'This resource has PUBLIC execute rights.'),
 (0,0,1,'2006-07-26 22:58:05','http://www.lampas.tld/index.html','/app','',0,'Redirect did=1 to target=/logon'),
 (0,0,1,'2006-07-26 22:58:05','http://www.lampas.tld/index.html','/logon','',1,'This resource has PUBLIC execute rights.');
INSERT INTO `session_log` (`session_id`,`uid`,`domid`,`timestamp`,`referer`,`target`,`cookies`,`authstatus`,`log_msg`) VALUES 
 (0,0,1,'2006-07-26 23:14:58','http://www.lampas.tld/index.html','/app','',0,'Redirect did=1 to target=/logon'),
 (0,0,1,'2006-07-26 23:14:58','http://www.lampas.tld/index.html','/logon','',1,'This resource has PUBLIC execute rights.');
/*!40000 ALTER TABLE `session_log` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`session_tracker`
--

DROP TABLE IF EXISTS `session_tracker`;
CREATE TABLE `session_tracker` (
  `session_id` int(10) unsigned NOT NULL auto_increment,
  `uid` int(10) unsigned NOT NULL default '0',
  `domid` int(10) unsigned NOT NULL default '1',
  `referer` varchar(255) default NULL,
  `target` varchar(255) NOT NULL default '',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `tags` text,
  PRIMARY KEY  (`session_id`),
  UNIQUE KEY `idx_session_tracker` (`uid`,`domid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`session_tracker`
--

/*!40000 ALTER TABLE `session_tracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_tracker` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`system_definitions`
--

DROP TABLE IF EXISTS `system_definitions`;
CREATE TABLE `system_definitions` (
  `sid` int(10) unsigned NOT NULL auto_increment,
  `osname` int(10) unsigned NOT NULL default '1',
  `version` varchar(16) NOT NULL default 'Unknown',
  `end_of_life_date` date NOT NULL default '2020-01-01',
  `os_package_script` int(10) unsigned default NULL,
  `os_package_branch` int(10) unsigned default NULL,
  `os_package_version` int(10) unsigned default NULL,
  `host_file_location` varchar(255) NOT NULL default '/etc/hosts',
  `authkey` varchar(32) default NULL,
  `admin_group` int(10) unsigned NOT NULL default '1',
  `host_name` varchar(32) NOT NULL default 'lampas',
  `host_ip_addr` int(10) unsigned default NULL,
  `host_ip_netmask` int(10) unsigned default NULL,
  `host_ip_default_gateway` int(10) unsigned default NULL,
  `system_notes` text,
  PRIMARY KEY  (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`system_definitions`
--

/*!40000 ALTER TABLE `system_definitions` DISABLE KEYS */;
INSERT INTO `system_definitions` (`sid`,`osname`,`version`,`end_of_life_date`,`os_package_script`,`os_package_branch`,`os_package_version`,`host_file_location`,`authkey`,`admin_group`,`host_name`,`host_ip_addr`,`host_ip_netmask`,`host_ip_default_gateway`,`system_notes`) VALUES 
 (1,1,'Debian Sarge','2006-12-31',NULL,NULL,NULL,'/etc/hosts','d9b9bec3f4cc5482e7c5ef43143e563a',1,'lampas',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `system_definitions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`system_log`
--

DROP TABLE IF EXISTS `system_log`;
CREATE TABLE `system_log` (
  `sid` int(10) unsigned NOT NULL default '0',
  `entry_timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `event_type` set('profile','deployment','monitoring','warnings','errors','other') NOT NULL default 'other',
  `entry` varchar(255) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`system_log`
--

/*!40000 ALTER TABLE `system_log` DISABLE KEYS */;
INSERT INTO `system_log` (`sid`,`entry_timestamp`,`event_type`,`entry`) VALUES 
 (1,'2006-07-21 13:18:13','profile','System added');
/*!40000 ALTER TABLE `system_log` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`user_definitions`
--

DROP TABLE IF EXISTS `user_definitions`;
CREATE TABLE `user_definitions` (
  `uid` int(10) unsigned NOT NULL auto_increment,
  `logon_name` varchar(16) NOT NULL default '',
  `password` varchar(32) default NULL,
  `status` tinyint(3) unsigned NOT NULL default '0',
  `status_date` datetime default NULL,
  `last_logon_date` date default NULL,
  `last_activity_timestamp` datetime default NULL,
  `flags` varchar(32) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `idx_logonname` (`logon_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`user_definitions`
--

/*!40000 ALTER TABLE `user_definitions` DISABLE KEYS */;
INSERT INTO `user_definitions` (`uid`,`logon_name`,`password`,`status`,`status_date`,`last_logon_date`,`last_activity_timestamp`,`flags`) VALUES 
 (1,'admin','5f4dcc3b5aa765d61d8327deb882cf99',1,'2006-07-21 12:40:14',NULL,NULL,NULL);
/*!40000 ALTER TABLE `user_definitions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`user_group_definitions`
--

DROP TABLE IF EXISTS `user_group_definitions`;
CREATE TABLE `user_group_definitions` (
  `gid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(32) NOT NULL default '',
  `description` varchar(255) default NULL,
  `status` tinyint(3) unsigned NOT NULL default '0',
  `status_timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `log` text,
  `flags` varchar(32) default NULL,
  PRIMARY KEY  (`gid`),
  UNIQUE KEY `idx_gid_names` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`user_group_definitions`
--

/*!40000 ALTER TABLE `user_group_definitions` DISABLE KEYS */;
INSERT INTO `user_group_definitions` (`gid`,`name`,`description`,`status`,`status_timestamp`,`log`,`flags`) VALUES 
 (1,'Admin','LAMPAS Admin Group',1,'2006-07-21 12:52:26',NULL,NULL),
 (2,'LAMPAS Users','General User Group - minimal permissions for LAMPAS users',1,'2006-07-26 18:01:00',NULL,NULL);
/*!40000 ALTER TABLE `user_group_definitions` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
CREATE TABLE `user_groups` (
  `uid` int(10) unsigned NOT NULL default '0',
  `gid` int(10) unsigned NOT NULL default '0',
  `status` tinyint(3) unsigned NOT NULL default '0',
  `log` text,
  UNIQUE KEY `idx_user_groupings` (`uid`,`gid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`user_groups`
--

/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
INSERT INTO `user_groups` (`uid`,`gid`,`status`,`log`) VALUES 
 (1,1,1,NULL);
/*!40000 ALTER TABLE `user_groups` ENABLE KEYS */;


--
-- Table structure for table `lampas`.`user_log`
--

DROP TABLE IF EXISTS `user_log`;
CREATE TABLE `user_log` (
  `uid` int(10) unsigned NOT NULL default '0',
  `log_timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `event_type` set('logon','logout','action','profile','system','warnings','errors') NOT NULL default '',
  `entry` varchar(255) default NULL,
  `notes` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lampas`.`user_log`
--

/*!40000 ALTER TABLE `user_log` DISABLE KEYS */;
INSERT INTO `user_log` (`uid`,`log_timestamp`,`event_type`,`entry`,`notes`) VALUES 
 (1,'2006-07-21 12:40:14','profile','Created user admin',NULL),
 (1,'2006-07-21 12:57:14','profile','User added to group with GID = 1',NULL);
/*!40000 ALTER TABLE `user_log` ENABLE KEYS */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
