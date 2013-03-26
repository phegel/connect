CREATE TABLE SCHEMA_INFO
	(VERSION NVARCHAR(40));

CREATE TABLE EVENT
	(ID INTEGER IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	DATE_CREATED DATETIME DEFAULT GETDATE(),
	NAME NVARCHAR(MAX) NOT NULL,
	EVENT_LEVEL NVARCHAR(40) NOT NULL,
	OUTCOME NVARCHAR(40) NOT NULL,
	ATTRIBUTES NVARCHAR(MAX),
	USER_ID INTEGER NOT NULL,
	IP_ADDRESS NVARCHAR(40));

CREATE TABLE CHANNEL
	(ID NVARCHAR(36) NOT NULL PRIMARY KEY,
	NAME NVARCHAR(40) NOT NULL,
	DESCRIPTION NVARCHAR(MAX),
	IS_ENABLED SMALLINT,
	VERSION NVARCHAR(40),
	REVISION INTEGER,
	LAST_MODIFIED DATETIME DEFAULT GETDATE(),
	SOURCE_CONNECTOR NVARCHAR(MAX),
	DESTINATION_CONNECTORS NVARCHAR(MAX),
	PROPERTIES NVARCHAR(MAX),
	PREPROCESSING_SCRIPT NVARCHAR(MAX),
	POSTPROCESSING_SCRIPT NVARCHAR(MAX),
	DEPLOY_SCRIPT NVARCHAR(MAX),
	SHUTDOWN_SCRIPT NVARCHAR(MAX));
	
CREATE TABLE CHANNEL_STATISTICS
	(SERVER_ID NVARCHAR(36) NOT NULL,
	CHANNEL_ID NVARCHAR(36) NOT NULL,
	RECEIVED INTEGER,
	FILTERED INTEGER,
	SENT INTEGER,
	ERROR INTEGER,
	QUEUED INTEGER,
	ALERTED INTEGER,
	PRIMARY KEY(SERVER_ID, CHANNEL_ID));
	
ALTER TABLE CHANNEL_STATISTICS
ADD CONSTRAINT CHANNEL_STATS_ID_FK
FOREIGN KEY (CHANNEL_ID)
REFERENCES CHANNEL (ID) ON DELETE CASCADE;

CREATE TABLE ATTACHMENT
    (ID NVARCHAR(255) NOT NULL PRIMARY KEY,
     MESSAGE_ID NVARCHAR(255) NOT NULL,
     ATTACHMENT_DATA IMAGE,
     ATTACHMENT_SIZE INTEGER,
     ATTACHMENT_TYPE NVARCHAR(40));

CREATE INDEX ATTACHMENT_INDEX1 ON ATTACHMENT(MESSAGE_ID);

CREATE TABLE MESSAGE
	(SEQUENCE_ID INTEGER IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	ID NVARCHAR(36) NOT NULL,
	SERVER_ID NVARCHAR(36) NOT NULL,
	CHANNEL_ID NVARCHAR(36) NOT NULL,
	SOURCE NVARCHAR(255),
	TYPE NVARCHAR(255),
	DATE_CREATED DATETIME NOT NULL,
	VERSION NVARCHAR(40),
	IS_ENCRYPTED SMALLINT NOT NULL,
	STATUS NVARCHAR(40),
	RAW_DATA NVARCHAR(MAX),
	RAW_DATA_PROTOCOL NVARCHAR(40),
	TRANSFORMED_DATA NVARCHAR(MAX),
	TRANSFORMED_DATA_PROTOCOL NVARCHAR(40),
	ENCODED_DATA NVARCHAR(MAX),
	ENCODED_DATA_PROTOCOL NVARCHAR(40),
	CONNECTOR_MAP NVARCHAR(MAX),
	CHANNEL_MAP NVARCHAR(MAX),
	RESPONSE_MAP NVARCHAR(MAX),
	CONNECTOR_NAME NVARCHAR(255),
	ERRORS NVARCHAR(MAX),
	CORRELATION_ID NVARCHAR(40),
	ATTACHMENT SMALLINT,		
	UNIQUE (ID));
	
ALTER TABLE MESSAGE
ADD CONSTRAINT CHANNEL_ID_FK
FOREIGN KEY (CHANNEL_ID)
REFERENCES CHANNEL (ID) ON DELETE CASCADE;

CREATE INDEX MESSAGE_INDEX1 ON MESSAGE(CHANNEL_ID, DATE_CREATED);

CREATE INDEX MESSAGE_INDEX2 ON MESSAGE(CHANNEL_ID, DATE_CREATED, CONNECTOR_NAME);

CREATE INDEX MESSAGE_INDEX3 ON MESSAGE(CHANNEL_ID, DATE_CREATED, RAW_DATA_PROTOCOL);

CREATE INDEX MESSAGE_INDEX4 ON MESSAGE(CHANNEL_ID, DATE_CREATED, SOURCE);

CREATE INDEX MESSAGE_INDEX5 ON MESSAGE(CHANNEL_ID, DATE_CREATED, STATUS);

CREATE INDEX MESSAGE_INDEX6 ON MESSAGE(CHANNEL_ID, DATE_CREATED, TYPE);

CREATE INDEX MESSAGE_INDEX7 ON MESSAGE(CORRELATION_ID, CONNECTOR_NAME);

CREATE INDEX MESSAGE_INDEX8 ON MESSAGE(ATTACHMENT);

CREATE TABLE SCRIPT
	(GROUP_ID NVARCHAR(40) NOT NULL,
	ID NVARCHAR(40) NOT NULL,
	SCRIPT NVARCHAR(MAX),
	PRIMARY KEY(GROUP_ID, ID));
	
CREATE TABLE PERSON
	(ID INTEGER IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	USERNAME NVARCHAR(40) NOT NULL,
	FIRSTNAME NVARCHAR(40),
	LASTNAME NVARCHAR(40),
	ORGANIZATION NVARCHAR(255),
	EMAIL NVARCHAR(255),
	PHONENUMBER NVARCHAR(40),
	DESCRIPTION NVARCHAR(255),
	LAST_LOGIN DATETIME DEFAULT GETDATE(),
	GRACE_PERIOD_START DATETIME DEFAULT NULL,
	LOGGED_IN SMALLINT NOT NULL);

CREATE TABLE PERSON_PASSWORD
	(PERSON_ID INTEGER NOT NULL,
	PASSWORD NVARCHAR(256) NOT NULL,
	PASSWORD_DATE DATETIME DEFAULT GETDATE());

ALTER TABLE PERSON_PASSWORD
ADD CONSTRAINT PERSON_ID_PP_FK
FOREIGN KEY (PERSON_ID)
REFERENCES PERSON (ID) ON DELETE CASCADE;

CREATE TABLE ALERT
	(ID NVARCHAR(36) NOT NULL PRIMARY KEY,
	NAME NVARCHAR(40) NOT NULL,
	IS_ENABLED SMALLINT NOT NULL,
	EXPRESSION NVARCHAR(MAX),
	TEMPLATE NVARCHAR(MAX),
	SUBJECT NVARCHAR(998));

CREATE TABLE CODE_TEMPLATE
	(ID NVARCHAR(255) NOT NULL PRIMARY KEY,
	NAME NVARCHAR(40) NOT NULL,
	CODE_SCOPE NVARCHAR(40) NOT NULL,
	CODE_TYPE NVARCHAR(40) NOT NULL,
	TOOLTIP NVARCHAR(255),
	CODE NVARCHAR(MAX));	
	
CREATE TABLE CHANNEL_ALERT
	(CHANNEL_ID NVARCHAR(36) NOT NULL,
	ALERT_ID NVARCHAR(36) NOT NULL);
	
ALTER TABLE CHANNEL_ALERT
ADD CONSTRAINT ALERT_ID_CA_FK
FOREIGN KEY (ALERT_ID)
REFERENCES ALERT (ID) ON DELETE CASCADE;

CREATE TABLE ALERT_EMAIL
	(ALERT_ID NVARCHAR(36) NOT NULL,
	EMAIL NVARCHAR(255) NOT NULL);
	
ALTER TABLE ALERT_EMAIL
ADD CONSTRAINT ALERT_ID_AE_FK
FOREIGN KEY (ALERT_ID)
REFERENCES ALERT(ID) ON DELETE CASCADE;

CREATE TABLE CONFIGURATION
	(CATEGORY NVARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	VALUE NVARCHAR(MAX));

INSERT INTO PERSON (USERNAME, LOGGED_IN) VALUES('admin', 0);

INSERT INTO PERSON_PASSWORD (PERSON_ID, PASSWORD) VALUES(1, 'YzKZIAnbQ5m+3llggrZvNtf5fg69yX7pAplfYg0Dngn/fESH93OktQ==');

INSERT INTO SCHEMA_INFO (VERSION) VALUES ('10');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'update.url', 'http://updates.mirthcorp.com');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'update.enabled', '1');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'stats.enabled', '1');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'firstlogin', '1');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'server.resetglobalvariables', '1');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'smtp.timeout', '5000');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'smtp.auth', '0');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'smtp.secure', '0');

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'server.maxqueuesize', '0');