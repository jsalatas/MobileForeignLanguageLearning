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
		INSERT IGNORE INTO `role` (`role`) VALUES ('Admin');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Teacher');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Student');
		INSERT IGNORE INTO `role` (`role`) VALUES ('Parent');
		INSERT IGNORE INTO `user` (`username`, `email`, `password`, `enabled`) VALUES ('admin', 'admin@example.com', '$2a$10$AtT/8iMJDG/M3Tsakn38tuKRO4AxzEFi/22qDOUO9Ay3W6RhI1702', 1);
		INSERT IGNORE INTO `user_role` (`user_id`, `role_id`) SELECT `user`.`id` as `user_id`, `role`.`id` as `role_id` FROM `user`, `role` WHERE `user`.`username` = 'admin'  AND `role`.`role` = 'Admin';
		INSERT IGNORE INTO `language` (`code`, `english_name`, `local_name`) VALUES ('en', 'English', 'English');
		INSERT IGNORE INTO `english_email` (`email_type`, `subject`, `body`) VALUES (0, 'New Teacher Registration', '%fullname% was registered as teacher.\n\nPlease review and enable access after logging into the application');
		INSERT IGNORE INTO `english_email` (`email_type`, `subject`, `body`) VALUES (1, 'Welcome', 'Dear %fullname%,\n\nyour account is created, but you will not be able to use it until it is enabled by an administrator or teacher.\n\nYou will be notified when it is done.');
		INSERT IGNORE INTO `english_email` (`email_type`, `subject`, `body`) VALUES (2, 'Account Enabled', 'Dear %fullname%,\n\nyour account is enabled.\n\nYou can now login to the system.');
		INSERT IGNORE INTO `notification` (`id`, `message`, `module`, `subject`, `internalModule`) VALUES (1, 'Please configure the server settings.', 'gr.ictpro.mall.client.view.SettingsView', 'Server Settings', 1);
		INSERT IGNORE INTO `notification` (`id`, `message`, `module`, `subject`, `internalModule`) VALUES (2, 'Please change default admin''s password.', 'gr.ictpro.mall.client.view.ProfileView', 'Change Password', 1);
		INSERT IGNORE INTO `role_notification` (`notification_id`, `role_id`) SELECT 1, `id` from `role` WHERE `role` = 'Admin' LIMIT 1;
		INSERT IGNORE INTO `role_notification` (`notification_id`, `role_id`) SELECT 2, `id` from `role` WHERE `role` = 'Admin' LIMIT 1;
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Add');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Application Path');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Connect to Server.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get Languages.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Get User.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Register.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Profile.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Cannot Save Server Configuration.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Choose Photo');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Choose Photo');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Code');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Color');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Confirm Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Delete');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Email');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Enabled');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('English Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Exit');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('I am');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Local Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Manage');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Modules Path');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('My Profile');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('New Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('OK');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Passwords do not Match.');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Profile');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Reenter New Password');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Register');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Select Item');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Server Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Server Settings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Settings');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Take New Photo');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('User Name');
		INSERT IGNORE INTO `english_text` (`english_text`) VALUES('Wrong User Name or Password.');
		
		INSERT INTO `status` (`name`, `value`) VALUES('initialized', '1');
	END IF;
END$$

delimiter ;

call initialize();

