CREATE TABLE IF NOT EXISTS `status` (
  `name` varchar(20) NOT NULL,
  `value` varchar(45) NOT NULL,
  PRIMARY KEY (`name`)
);

DROP PROCEDURE IF EXISTS initialize; 
DROP TRIGGER IF EXISTS insertEnglishText; 
DROP TRIGGER IF EXISTS updateEnglishText; 

delimiter $$

CREATE TRIGGER insertEnglishText BEFORE INSERT ON english_text
  FOR EACH ROW BEGIN
	SET NEW.md5 = MD5(NEW.english_text);
END$$

CREATE TRIGGER updateEnglishText BEFORE UPDATE ON english_text
  FOR EACH ROW BEGIN
    SET NEW.md5 = MD5(NEW.english_text);
END$$


CREATE PROCEDURE initialize()
BEGIN
	IF NOT EXISTS (SELECT `value` FROM `status` WHERE `name`='initialized') 
	THEN
		INSERT IGNORE INTO `config` VALUES (1,'server.url','https://server_url:8443');
		INSERT IGNORE INTO `config` VALUES (2,'mail.smtp_hostname','smtp.example.com');
		INSERT IGNORE INTO `config` VALUES (3,'mail.smtp_port','000');
		INSERT IGNORE INTO `config` VALUES (4,'mail.smtp_username','user@example.com');
		INSERT IGNORE INTO `config` VALUES (5,'mail.smtp_password','password');
		INSERT IGNORE INTO `config` VALUES (6,'mail.smtp_auth','true');
		INSERT IGNORE INTO `config` VALUES (7,'mail.smtp_starttls_enable','true');
		INSERT IGNORE INTO `config` VALUES (8,'mail.debug','false');
		INSERT IGNORE INTO `config` VALUES (9,'allow_unattended_meetings','true');
		INSERT IGNORE INTO `config` VALUES (10,'bigbluebutton.secret','secret');
		INSERT IGNORE INTO `config` VALUES (11,'bigbluebutton.servername','servername');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Admin');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Teacher');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Student');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Parent');
		INSERT IGNORE INTO `language` (`code`, `english_name`, `local_name`) VALUES ('en', 'English', 'English');
		INSERT IGNORE INTO `user` (`username`, `email`, `password`, `enabled`) VALUES ('admin', 'admin@example.com', '$2a$10$AtT/8iMJDG/M3Tsakn38tuKRO4AxzEFi/22qDOUO9Ay3W6RhI1702', 1);
		INSERT IGNORE INTO `profile` (`user_id`, `color`, `name`, `language_code`) SELECT `user`.`id` as `user_id`, 102 as `color`, 'admin' as `name`, 'en' as `language_code`  FROM `user` WHERE `username` = 'admin';
		INSERT IGNORE INTO `user_role` (`user_id`, `role_id`) SELECT `user`.`id` as `user_id`, `role`.`id` as `role_id` FROM `user`, `role` WHERE `user`.`username` = 'admin'  AND `role`.`role` = 'Admin';
		SET SESSION SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
		INSERT IGNORE INTO `classroom` (`id`, `name`, `notes`, `language_code`, `force_ui_language`) VALUES (0, 'Global', 'Global/Master Classroom', 'en', 0);
		INSERT IGNORE INTO `english_email` (`email_type`, `subject`, `body`) VALUES (0, 'New %role% Registration', '%fullname% was registered as %role%.\n\nPlease review and enable access after logging into the application');
		INSERT IGNORE INTO `english_email` (`email_type`, `subject`, `body`) VALUES (1, 'Welcome', 'Dear %fullname%,\n\nyour account is created, but you will not be able to use it until it is enabled by an administrator or teacher.\n\nYou will be notified when it is done.');
		INSERT IGNORE INTO `english_email` (`email_type`, `subject`, `body`) VALUES (2, 'Account Enabled', 'Dear %fullname%,\n\nyour account is enabled.\n\nYou can now login to the system.');
		INSERT IGNORE INTO `email_translation` (`body`, `email_type`, `subject`, `classroom_id`, `language_code`) SELECT `body`, `email_type`, `subject`, 0 AS `classroom_id`, 'en' AS `language_code` FROM `english_email`;
		INSERT IGNORE INTO `notification` (`id`, `message`, `module`, `subject`, `internalModule`, `action_needed`) VALUES (1, 'Please configure the server settings.', 'gr.ictpro.mall.client.view.SettingsView', 'Server Settings', 1, 1);
		INSERT IGNORE INTO `notification` (`id`, `message`, `module`, `subject`, `internalModule`, `action_needed`) VALUES (2, 'Please change default admin''s password.', 'gr.ictpro.mall.client.view.UserView', 'Change Password', 1, 1);
		INSERT IGNORE INTO `role_notification` (`notification_id`, `role_id`) SELECT 1, `id` from `role` WHERE `role` = 'Admin' LIMIT 1;
		INSERT IGNORE INTO `role_notification` (`notification_id`, `role_id`) SELECT 2, `id` from `role` WHERE `role` = 'Admin' LIMIT 1;
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Add');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Allow Unattended Meetings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Application Path');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('April');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('August');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Calendar');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cancel');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Connect to Server.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Connect to Server.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Delete Calendar.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Delete Classroom Group.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Delete Classroom.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Delete Language.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Delete Schedule.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Calendar.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Classroom Groups.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Classrooms.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Client Settings.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Languages.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Notifications.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Online Users.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Roles.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Server Configuration.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get User.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Register.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Calendar.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Classroom Group.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Classroom.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Client Settings.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Language.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Notification.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Profile.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Schedule.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Server Configuration.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot get User.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Choose Photo');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Classroom Groups');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Classroom');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Classrooms');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Code');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Color');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Communications');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Confirm Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('December');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Delete');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Description');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Disallow Unattended Meetings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Edit Classroom');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Edit Classrooms Group');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Edit Language');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Edit User');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Email');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Enabled');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('End at');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('English Name Cannot be Empty.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('English Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Enter your Email.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Enter your Name.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Enter your Teacher''s Username. If you don''t know it please ask your teacher.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Enter your Username.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Exit');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('February');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Force Interface Language');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Fri');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Friday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Get All Messages');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Get Untranslated Messages');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('I am');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('January');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('July');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('June');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Language Code Cannot be Empty.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Language Code');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Language');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Languages');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Local Name Cannot be Empty.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Local Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Manage');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('March');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('May');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Modules Path');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Mon');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Monday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('My Profile');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('New Classroom');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('New Classrooms Group');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('New Language');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('New Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('New Recurring Event');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Notes');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('November');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('OK');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('October');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('One time');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Parent');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Passwords do not Match.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Please Assign a Language to the Classroom.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Please Assign a Teacher to the Classroom.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Please Enter Classroom Group''s Name.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Please Enter Classroom''s Name.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Please Enter a Description.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Profile');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Reenter New Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Register');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Repeat Every');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Repeat Until');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Repeating');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Sat');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Saturday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Scheduled Meetings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Select Item');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Select Transalations');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('September');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Server Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Server Settings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Settings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Start at');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Student');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Sun');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Sunday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Take New Photo');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Teacher''s Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Teacher');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Text Chat');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Thu');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Thusrday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Translation XML Files');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Translations Successfully Uploaded');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Tue');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Tuesday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Type');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Upload Translations');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('User Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Users');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Video Chat');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('View User');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Wed');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Wednesday');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Whiteboard');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Wrong User Name or Password.');
		INSERT IGNORE INTO `translation` (`english_text_id`, `language_code`, `translated_text`, `classroom_id`) SELECT `id` AS `english_text_id`, 'en' AS `language_code`, `english_text` AS `translated_text`, 0 AS `classroom_id` FROM english_text;
		INSERT INTO `status` (`name`, `value`) VALUES('initialized', '1');
	END IF;
END$$

delimiter ;

call initialize();

