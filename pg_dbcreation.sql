DROP TABLE IF EXISTS users;

CREATE TABLE users (
  username varchar(255) NOT NULL,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  do_exif_filter smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (username),
  UNIQUE  (username)
) ;

INSERT INTO users VALUES ('alper','Alper','Altinok',1),('yeskendir','Yeskendir','Kassenov',0);


DROP TABLE IF EXISTS trap_counts;

CREATE TABLE trap_counts (
  id  SERIAL,
  trap_uid varchar(255) DEFAULT NULL,
  location_uid varchar(255) DEFAULT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  is_last_use smallint NOT NULL DEFAULT '0',
  code varchar(255) NOT NULL,
  ai_total int DEFAULT NULL,
  ai_incr int DEFAULT NULL,
  hu_total int DEFAULT NULL,
  hu_incr int DEFAULT NULL,
  image_id int DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE (trap_uid,start_date,end_date,code)
) ;



DROP TABLE IF EXISTS companies;

CREATE TABLE companies (
  id SERIAL,
  username varchar(255) NOT NULL,
  title varchar(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT companies_ibfk_1 FOREIGN KEY (username) REFERENCES users (username)
) ;
CREATE INDEX username ON companies (username);

INSERT INTO companies VALUES (1,'alper','Bitki Ltd.'),(2,'yeskendir','Something Inc.');

DROP TABLE IF EXISTS fields;

CREATE TABLE fields (
  uid varchar(255) NOT NULL,
  gdrive_uid varchar(255) DEFAULT NULL,
  gdrive_resync_uuid varchar(255) DEFAULT NULL,
  company_id int NOT NULL,
  title varchar(255) NOT NULL,
  city varchar(255) NOT NULL,
  district varchar(255) DEFAULT NULL,
  province varchar(255) DEFAULT NULL,
  PRIMARY KEY (uid),
  CONSTRAINT fields_ibfk_1 FOREIGN KEY (company_id) REFERENCES companies (id)
) ;

CREATE INDEX company_id ON fields (company_id);

INSERT INTO fields VALUES ('195F20FD','1whC6utxD011_D0Z_hCtVX3iyEczOEdb3','4e9a7186-cb22-473f-9688-2fb15e990867',1,'sera2','Antalya','Aksu2','Kocaayak2'),('2531D8E6','1Ys2Tu24dFfUr1liXCDVJUAXCfaHNFsCH','54c7bd8b-0274-4812-8218-2e9337ea920d',1,'sera3','Antalya','Aksu3','Kocaayak3'),('AB28C41C','1yyvqG8s-DXqz_GvX-LcY0gL9En77n0IW',NULL,1,'sera3','Antalya','Aksu3','Kocaayak3'),('FIELD_01','1ZkQcHksyOme055YxHsKRkEIbhH6MEfrQ','c4a9c487-6677-4671-bead-24ea1a42a198',2,'1 nolu sera','Antalya','Aksu','Gölköy'),('FIELD_02','1a1d0BASR6TMjKgZiU-4V-UuaDSYGF0o7',NULL,2,'sera1','Antalya','Aksu1','Kocaayak1');


DROP TABLE IF EXISTS images;

CREATE TABLE images (
  id SERIAL,
  username varchar(255) NOT NULL,
  gdrive_filename varchar(255) DEFAULT NULL,
  gdrive_uid varchar(255) DEFAULT NULL,
  gdrive_modified_time varchar(255) DEFAULT NULL,
  field_uid varchar(255) DEFAULT NULL,
  trap_uid varchar(255) DEFAULT NULL,
  images_path varchar(255) DEFAULT NULL,
  stage varchar(255) NOT NULL,
  status varchar(255) NOT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  downloaded_at timestamp DEFAULT NULL,
  is_enlarged smallint DEFAULT '0',
  is_enlarged_by_sres smallint DEFAULT NULL,
  set_inf_cmd_id int DEFAULT NULL,
  used_inf_cmd_id int DEFAULT NULL,
  to_delete smallint DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE  (gdrive_uid),
  CONSTRAINT images_ibfk_1 FOREIGN KEY (username) REFERENCES users (username)
) ;

CREATE INDEX ON images (username);

DROP TABLE IF EXISTS app_scanned_lqrs;

CREATE TABLE app_scanned_lqrs (
  id SERIAL,
  image_id int NOT NULL,
  location_no varchar(255) NOT NULL,
  location_uid varchar(255) NOT NULL,
  field_uid varchar(255) NOT NULL,
  latlon_as_text varchar(255) NOT NULL,
  label varchar(255) DEFAULT NULL,
  scanned_at timestamp NOT NULL,
  PRIMARY KEY (id),
  UNIQUE  (image_id),
  CONSTRAINT app_scanned_lqrs_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;

DROP TABLE IF EXISTS app_scanned_mqrs;

CREATE TABLE app_scanned_mqrs (
  id SERIAL,
  image_id int NOT NULL,
  trap_no varchar(255) NOT NULL,
  trap_uid varchar(255) NOT NULL,
  field_no int NOT NULL,
  crop_type varchar(255) NOT NULL,
  trap_face varchar(255) NOT NULL,
  trap_type varchar(255) NOT NULL,
  field_uid varchar(255) NOT NULL,
  label varchar(255) DEFAULT NULL,
  scanned_at timestamp NOT NULL,
  PRIMARY KEY (id),
  UNIQUE  (image_id),
  CONSTRAINT app_scanned_mqrs_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;


DROP TABLE IF EXISTS configs;

CREATE TABLE configs (
  key_ varchar(255) NOT NULL,
  value text NOT NULL,
  category varchar(255) NOT NULL,
  notes text,
  PRIMARY KEY (key_)
) ;

INSERT INTO configs VALUES ('aperture','alper:Aperture=,,,,,|yeskendir:Aperture=,,,,,','EXIF_FILTER',NULL),('bicubic_scale','2','SUPERRES',NULL),('camera_make','alper:Make=OLYMPUS IMAGING CORP.,,,,,|yeskendir:Make=OLYMPUS IMAGING CORP.,,,,,','EXIF_FILTER',NULL),('camera_model','alper:Model=E-M5MarkII,,,,,|yeskendir:Model=E-M5MarkII,,,,,','EXIF_FILTER',NULL),('do_validate_qrs','false','QR_EXTRACTOR',''),('exposure_mode','alper:ExposureMode=Manual,,,,,|yeskendir:ExposureMode=Manual,,,,,','EXIF_FILTER',NULL),('exposure_time','alper:Exposure=,,,,,|yeskendir:Exposure=,,,,,','EXIF_FILTER',NULL),('focal_length','alper:Focal Length=,,,,,|yeskendir:Focal Length=,,,,,','EXIF_FILTER',NULL),('height','alper:ExifImageHeight=5472,2736,2832,,3456,|yeskendir:ExifImageHeight=5472,2736,2832,,3456,5472','EXIF_FILTER',NULL),('iou_threshold','0.2','NMS',NULL),('iso_speed','alper:ISO Speed=,,,,,|yeskendir:ISO Speed=,,,,,','EXIF_FILTER',NULL),('lens','alper:LensModel=,,,,,|yeskendir:LensModel=,,,,,','EXIF_FILTER',NULL),('num_inf_threads','1','MS_07',''),('rotation','alper:Orientation=Landscape,,,,,|yeskendir:Orientation=Landscape,,,,,','EXIF_FILTER',NULL),('sleep_interval_ms_01','70','GENERAL',''),('sleep_interval_ms_02','15','GENERAL',''),('sleep_interval_ms_03','15','GENERAL',''),('sleep_interval_ms_04','15','GENERAL',''),('sleep_interval_ms_05','15','GENERAL',''),('sleep_interval_ms_06','15','GENERAL',''),('sleep_interval_ms_07','15','GENERAL',''),('sleep_interval_ms_08','15','GENERAL',''),('sleep_interval_ms_09','86400','GENERAL',''),('sres','no','SUPERRES',NULL),('sres_command_flags','--model EDSR --data_test Demo --scale 2 --n_resblocks 32 --n_feats 256 --res_scale 0.1 --pre_train ./ag_cv_pytorch_models/EDSR_x2.pt --test_only --save_results --chop','SUPERRES',''),('superres_threshold_height','3457','SUPERRES',NULL),('superres_threshold_width','4609','SUPERRES',NULL),('threshold_has_qrcode','0.5','BASIC_CLASSIFIER',''),('threshold_is_blurry','0.5','BASIC_CLASSIFIER',''),('threshold_is_trap','0.5','BASIC_CLASSIFIER',''),('width','alper:ExifImageWidth=7296,3648,4240,7296,4608,|yeskendir:ExifImageWidth=7296,3648,4240,7296,4608,7296','EXIF_FILTER',NULL);


DROP TABLE IF EXISTS field_classifier_commands;

CREATE TABLE field_classifier_commands (
  id SERIAL,
  field_uid varchar(255) NOT NULL,
  command text NOT NULL,
  PRIMARY KEY (id)
) ;

INSERT INTO field_classifier_commands VALUES (1,'FIELD_01','-u test-triton-predictor-default.default.192.168.1.235.xip.io -m resnet50_netdef_version_02 -s INCEPTION -b 16'),(2,'FIELD_01','-u test-triton-predictor-default.default.192.168.1.235.xip.io -m resnet50_netdef_version_03 -s INCEPTION -b 16'),(3,'FIELD_02','-u test-triton-predictor-default.default.192.168.1.235.xip.io -m resnet50_netdef_version_07 -s INCEPTION -b 16'),(4,'195F20FD','-u test-triton-predictor-default.default.192.168.1.235.xip.io -m resnet50_netdef_version_07 -s INCEPTION -b 16'),(5,'2531D8E6','-u test-triton-predictor-default.default.192.168.1.235.xip.io -m resnet50_netdef_version_07 -s INCEPTION -b 16'),(6,'AB28C41C','-m resnet50_pytorch');


DROP TABLE IF EXISTS field_configs;

CREATE TABLE field_configs (
  field_uid varchar(255) NOT NULL,
  save_tile_inf_files smallint DEFAULT NULL,
  save_pre_nms_image_infs smallint DEFAULT NULL,
  save_post_nms_image_infs smallint DEFAULT NULL,
  trap_face_eol_days int NOT NULL DEFAULT '15',
  start_date timestamp DEFAULT NULL,
  end_date timestamp DEFAULT NULL,
  UNIQUE (field_uid),
  CONSTRAINT field_configs_ibfk_1 FOREIGN KEY (field_uid) REFERENCES fields (uid)
) ;

INSERT INTO field_configs VALUES ('195F20FD',1,1,1,15,'2019-01-01 00:00:00','2021-12-01 00:00:00'),('2531D8E6',1,1,1,15,'2019-01-02 00:00:00','2021-12-02 00:00:00'),('AB28C41C',1,1,1,20,'2019-05-15 00:00:00','2019-05-17 06:00:00'),('FIELD_01',1,1,1,20,'2019-01-01 00:00:00','2021-12-01 00:00:00'),('FIELD_02',1,1,1,20,'2019-01-02 00:00:00','2021-12-02 00:00:00');


DROP TABLE IF EXISTS field_inf_cmds;

CREATE TABLE field_inf_cmds (
  id SERIAL,
  field_uid varchar(255) NOT NULL,
  options text NOT NULL,
  PRIMARY KEY (id)
) ;

INSERT INTO field_inf_cmds VALUES (1,'FIELD_01','-t 4000'),(2,'FIELD_02','-t 5000'),(3,'FIELD_02','-t 12000'),(4,'195F20FD','-t 12000'),(5,'2531D8E6','-t 12000'),(6,'AB28C41C','-t 12000');


DROP TABLE IF EXISTS field_tile_configs;


CREATE TABLE field_tile_configs (
  id SERIAL,
  field_uid varchar(255) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  x_size int NOT NULL,
  y_size int NOT NULL,
  x_overlap int NOT NULL,
  y_overlap int NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT field_tile_configs_ibfk_1 FOREIGN KEY (field_uid) REFERENCES fields (uid)
);

CREATE INDEX ON field_tile_configs (field_uid);

INSERT INTO field_tile_configs VALUES (1,'FIELD_01','2019-05-04','2019-05-10',400,400,50,50),(2,'FIELD_01','2019-06-22','2019-06-29',2000,2000,100,100),(3,'FIELD_02','2019-07-04','2019-07-10',2000,2000,100,100),(5,'195F20FD','2019-07-04','2019-07-10',2000,2000,100,100),(6,'2531D8E6','2019-07-04','2019-07-10',2000,2000,100,100),(23,'AB28C41C','2019-07-04','2019-07-10',2000,2000,100,100);


DROP TABLE IF EXISTS physical_locations;

CREATE TABLE physical_locations (
  id SERIAL,
  location_no varchar(255) NOT NULL,
  field_uid varchar(255) NOT NULL,
  title varchar(255) DEFAULT NULL,
  latlon point NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (field_uid,location_no),
  CONSTRAINT physical_locations_ibfk_1 FOREIGN KEY (field_uid) REFERENCES fields (uid)
) ;

INSERT INTO physical_locations VALUES (7,1,'FIELD_01','bar 1 in field 1',point(36.8971, 30.7131)),(8,2,'FIELD_01','bar 2 in field 1',point(36.8972, 30.7132)),(9,3,'FIELD_01','wall 1 in field 1',point(36.8973 ,30.7133)),(10,1,'FIELD_02','bar 1 in field 2',point(36.5441, 31.9951)),(11,2,'FIELD_02','bar 2 in field 2',point(36.5442 ,31.9952)),(12,3,'FIELD_02','bar 3 in field 2',point(36.5443 ,31.9953)),(13,1,'195F20FD','metal bar @ field 19',point(36.8636 ,31.0607)),(14,1,'2531D8E6','metal bar @ field 25',point(36.6028, 30.5598));


DROP TABLE IF EXISTS generated_lqrs;

CREATE TABLE generated_lqrs (
  id SERIAL,
  physical_location_id int NOT NULL,
  location_no varchar(255) NOT NULL,
  location_uid varchar(255) DEFAULT NULL,
  field_uid varchar(255) NOT NULL,
  latlon_as_text varchar(255) NOT NULL,
  label varchar(255) DEFAULT NULL,
  tmp_uuid varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE  (tmp_uuid),
  CONSTRAINT generated_lqrs_ibfk_1 FOREIGN KEY (physical_location_id) REFERENCES physical_locations (id)
);
CREATE INDEX ON generated_lqrs (physical_location_id);

INSERT INTO generated_lqrs VALUES (8,7,'1','00000008','FIELD_01','36.8971,30.7131','7;1;00000008;FIELD_01;36.8971,30.7131','d355e5ab-44b1-4c76-9119-761dcbd03864'),(9,12,'3','00000009','FIELD_02','36.5443,31.9953','12;3;00000009;FIELD_02;36.5443,31.9953','3eb755a0-2bfe-4bf6-8ab3-b85f66a06aa2'),(10,13,'1','0000000A','195F20FD','36.8636,31.0607','13;1;0000000A;195F20FD;36.8636,31.0607','338656de-d181-4cb3-8297-e46cf21b9ec2'),(11,14,'1','0000000B','2531D8E6','36.6028,30.5598','14;1;0000000B;2531D8E6;36.6028,30.5598','b3aec9c0-52ec-4a23-b3f8-49d53627c071'),(12,7,'1','0000000C','FIELD_01','36.8971,30.7131','7;1;0000000C;FIELD_01;36.8971,30.7131','d910bfc1-44e3-4b0b-a5d1-8137986ed691'),(13,7,'1','0000000D','FIELD_01','36.8971,30.7131','7;1;0000000D;FIELD_01;36.8971,30.7131','d27abef6-9b9f-4aa6-a90d-e7db6769b88e'),(14,7,'1','0000000E','FIELD_01','36.8971,30.7131','7;1;0000000E;FIELD_01;36.8971,30.7131','5bad8ba2-2fd7-4866-bd44-a2f066e48ec5'),(15,7,'1','0000000F','FIELD_01','36.8971,30.7131','7;1;0000000F;FIELD_01;36.8971,30.7131','d2d5190e-a7cd-4345-9bbc-151cff87b395');


DROP TABLE IF EXISTS physical_traps;

CREATE TABLE physical_traps (
  id SERIAL,
  field_uid varchar(255) NOT NULL,
  trap_no varchar(255) NOT NULL,
  field_no varchar(255) NOT NULL,
  crop_type varchar(255) NOT NULL,
  trap_type varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (field_uid,trap_no),
  CONSTRAINT physical_traps_ibfk_1 FOREIGN KEY (field_uid) REFERENCES fields (uid)
) ;

INSERT INTO physical_traps VALUES (13,'195F20FD','17','1','biber','blue'),(14,'195F20FD','21','1','biber','blue'),(15,'195F20FD','1','1','biber','blue'),(16,'195F20FD','19','1','biber','blue'),(17,'2531D8E6','8','3','biber','blue'),(18,'2531D8E6','30','3','biber','blue'),(19,'2531D8E6','11','3','biber','blue'),(20,'2531D8E6','14','3','biber','blue');


DROP TABLE IF EXISTS generated_mqrs;

CREATE TABLE generated_mqrs (
  id  SERIAL,
  physical_trap_id int NOT NULL,
  valid_from date NOT NULL,
  valid_till date NOT NULL,
  trap_no varchar(255) NOT NULL,
  trap_uid varchar(255) DEFAULT NULL,
  field_no int NOT NULL,
  crop_type varchar(255) NOT NULL,
  trap_face varchar(255) NOT NULL,
  trap_type varchar(255) NOT NULL,
  field_uid varchar(255) NOT NULL,
  label varchar(255) DEFAULT NULL,
  tmp_uuid varchar(255)  DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE (tmp_uuid),
  CONSTRAINT generated_mqrs_ibfk_1 FOREIGN KEY (physical_trap_id) REFERENCES physical_traps (id)
) ;

CREATE INDEX ON  generated_mqrs (physical_trap_id);

INSERT INTO generated_mqrs VALUES (587,13,'2010-01-01','2030-01-01','17','3C50112C',1,'biber','A','blue','195F20FD','17;3C50112C;1;biber;A;blue;195F20FD',NULL),(588,14,'2010-01-01','2030-01-01','21','498D43B4',1,'biber','A','blue','195F20FD','21;498D43B4;1;biber;A;blue;195F20FD',NULL),(589,15,'2010-01-01','2030-01-01','1','E58C41E6',1,'biber','A','blue','195F20FD','1;E58C41E6;1;biber;A;blue;195F20FD',NULL),(590,16,'2010-01-01','2030-01-01','19','F00ACE53',1,'biber','A','blue','195F20FD','19;F00ACE53;1;biber;A;blue;195F20FD',NULL),(591,17,'2010-01-01','2030-01-01','8','3BAEE160',3,'biber  ','A','blue','2531D8E6','8;3BAEE160;3;biber;A;blue;2531D8E6',NULL),(592,17,'2010-01-01','2030-01-01','8','3BAEE160',3,'biber  ','A','blue','2531D8E6','8;3BAEE160;3;biber;A;blue;2531D8E6',NULL),(593,18,'2010-01-01','2030-01-01','30','AE72C765',3,'biber  ','B','blue','2531D8E6','30;AE72C765;3;biber;B;blue;2531D8E6',NULL),(594,19,'2010-01-01','2030-01-01','11','27C84200',3,'biber  ','A','blue','2531D8E6','11;27C84200;3;biber;A;blue;2531D8E6',NULL),(595,20,'2010-01-01','2030-01-01','14','C7450107',3,'biber  ','A','blue','2531D8E6','14;C7450107;3;biber;A;blue;2531D8E6',NULL),(596,13,'2021-03-15','2021-06-30','17','00000254',1,'biber','A','blue','195F20FD','17;00000254;1;biber;A;blue;195F20FD','f137b1f5-504a-4a9b-b5a7-0b59825f1a2a'),(597,13,'2021-03-15','2021-06-30','17','00000255',1,'biber','A','blue','195F20FD','17;00000255;1;biber;A;blue;195F20FD','e0498d40-7073-42a9-8059-36fb10712abc'),(598,13,'2021-03-15','2021-06-30','17','00000256',1,'biber','A','blue','195F20FD','17;00000256;1;biber;A;blue;195F20FD','755dd241-b0c6-4954-bfdf-52b55ed49642'),(599,13,'2021-03-15','2021-06-30','17','00000257',1,'biber','A','blue','195F20FD','17;00000257;1;biber;A;blue;195F20FD','e61c1773-a1c7-4182-8de4-8177b5ad79a4'),(600,13,'2021-03-15','2021-06-30','17','00000258',1,'biber','A','blue','195F20FD','17;00000258;1;biber;A;blue;195F20FD','6d174b2f-8178-4fbf-ac14-42cb08f4b208'),(601,13,'2021-03-15','2021-06-30','17','00000259',1,'biber','A','blue','195F20FD','17;00000259;1;biber;A;blue;195F20FD','1305679a-3cb2-4108-8205-fb73643a3c5a'),(602,13,'2021-03-15','2021-06-30','17','0000025A',1,'biber','A','blue','195F20FD','17;0000025A;1;biber;A;blue;195F20FD','522896e3-4a3c-4fb5-93e1-1967026671e0'),(603,13,'2021-03-15','2021-06-30','17','0000025B',1,'biber','A','blue','195F20FD','17;0000025B;1;biber;A;blue;195F20FD','493aaba7-bbfd-4d83-830e-c7832d77870b'),(604,13,'2021-03-15','2021-06-30','17','0000025C',1,'biber','A','blue','195F20FD','17;0000025C;1;biber;A;blue;195F20FD','fa15503a-89e4-4665-b3d6-cfeea410ca19'),(605,13,'2021-03-15','2021-06-30','17','0000025D',1,'biber','A','blue','195F20FD','17;0000025D;1;biber;A;blue;195F20FD','af8f4d44-748e-499a-8d52-368acc08d2d7'),(606,13,'2021-03-15','2021-06-30','17','0000025E',1,'biber','A','blue','195F20FD','17;0000025E;1;biber;A;blue;195F20FD','3b8b81c4-3ddb-454d-960c-822529e6a0a5'),(607,13,'2021-03-15','2021-06-30','17','0000025F',1,'biber','A','blue','195F20FD','17;0000025F;1;biber;A;blue;195F20FD','f1c82db3-6a76-4bca-ab05-4c780ef478d2'),(608,13,'2021-03-15','2021-06-30','17','00000260',1,'biber','A','blue','195F20FD','17;00000260;1;biber;A;blue;195F20FD','eaf1f1d8-331e-49de-8aec-8751b1851baf'),(609,13,'2021-03-15','2021-06-30','17','00000261',1,'biber','A','blue','195F20FD','17;00000261;1;biber;A;blue;195F20FD','a8001a72-2428-474d-bf56-9dae0a142a75'),(610,13,'2021-03-15','2021-06-30','17','00000262',1,'biber','A','blue','195F20FD','17;00000262;1;biber;A;blue;195F20FD','968fa294-64ce-47d6-b3ff-fc712fde4ecb'),(611,13,'2021-03-15','2021-06-30','17','00000263',1,'biber','A','blue','195F20FD','17;00000263;1;biber;A;blue;195F20FD','b8d3c0a2-2d9e-4db9-ac86-d5b722095d7b'),(612,13,'2021-03-15','2021-06-30','17','00000264',1,'biber','A','blue','195F20FD','17;00000264;1;biber;A;blue;195F20FD','84a10a0c-8925-45b4-b4cf-139fc0402884'),(613,13,'2021-03-15','2021-06-30','17','00000265',1,'biber','A','blue','195F20FD','17;00000265;1;biber;A;blue;195F20FD','43e61041-bce2-41d9-9833-d0eba8946360'),(614,13,'2021-03-15','2021-06-30','17','00000266',1,'biber','A','blue','195F20FD','17;00000266;1;biber;A;blue;195F20FD','1582adcd-2827-4e95-b33f-d872889db61f'),(615,13,'2021-03-15','2021-06-30','17','00000267',1,'biber','A','blue','195F20FD','17;00000267;1;biber;A;blue;195F20FD','3adb275c-8e76-42d4-b12e-3564516ef49e'),(616,13,'2021-03-15','2021-06-30','17','00000268',1,'biber','B','blue','195F20FD','17;00000268;1;biber;B;blue;195F20FD','9987c365-f1b2-4fcc-8b1f-820f1295184a'),(617,13,'2021-03-15','2021-06-30','17','00000269',1,'biber','B','blue','195F20FD','17;00000269;1;biber;B;blue;195F20FD','8a6ca585-1fc3-477a-bde8-4c3b1213d0b9'),(618,13,'2021-03-15','2021-06-30','17','0000026A',1,'biber','B','blue','195F20FD','17;0000026A;1;biber;B;blue;195F20FD','65fc6f85-cc74-4d28-b5c0-68e8de044652'),(619,13,'2021-03-15','2021-06-30','17','0000026B',1,'biber','B','blue','195F20FD','17;0000026B;1;biber;B;blue;195F20FD','b608b2c1-0b30-4a96-b555-785366e35835'),(620,13,'2021-03-15','2021-06-30','17','0000026C',1,'biber','B','blue','195F20FD','17;0000026C;1;biber;B;blue;195F20FD','26fabcfb-b462-4178-8da4-3be00b123230'),(621,13,'2021-03-15','2021-06-30','17','0000026D',1,'biber','B','blue','195F20FD','17;0000026D;1;biber;B;blue;195F20FD','0b02f91f-4c6d-4593-b8f0-2213081869a9'),(622,13,'2021-03-15','2021-06-30','17','0000026E',1,'biber','B','blue','195F20FD','17;0000026E;1;biber;B;blue;195F20FD','238ff735-33ef-40c7-a122-d13e3b8cc049'),(623,13,'2021-03-15','2021-06-30','17','0000026F',1,'biber','B','blue','195F20FD','17;0000026F;1;biber;B;blue;195F20FD','f645f70f-3455-4279-8347-94783a55b91c'),(624,13,'2021-03-15','2021-06-30','17','00000270',1,'biber','B','blue','195F20FD','17;00000270;1;biber;B;blue;195F20FD','4472cb38-9792-41b8-9f87-f797c55ece3e'),(625,13,'2021-03-15','2021-06-30','17','00000271',1,'biber','B','blue','195F20FD','17;00000271;1;biber;B;blue;195F20FD','1893116d-841a-4940-81e9-5495d1dd4220'),(626,13,'2021-03-15','2021-06-30','17','00000272',1,'biber','B','blue','195F20FD','17;00000272;1;biber;B;blue;195F20FD','b0264a0e-b5ba-443e-96ae-3a71b45362dd'),(627,13,'2021-03-15','2021-06-30','17','00000273',1,'biber','B','blue','195F20FD','17;00000273;1;biber;B;blue;195F20FD','7132daf8-528f-4881-b800-1d4755b33774'),(628,13,'2021-03-15','2021-06-30','17','00000274',1,'biber','B','blue','195F20FD','17;00000274;1;biber;B;blue;195F20FD','a7eb1df9-854d-4a31-a3ae-e52ccd67d9ce'),(629,13,'2021-03-15','2021-06-30','17','00000275',1,'biber','B','blue','195F20FD','17;00000275;1;biber;B;blue;195F20FD','63696723-1c68-4268-8975-b212dcc36f1b'),(630,13,'2021-03-15','2021-06-30','17','00000276',1,'biber','B','blue','195F20FD','17;00000276;1;biber;B;blue;195F20FD','34accbee-7af2-4535-befa-4e45df4488a2'),(631,13,'2021-03-15','2021-06-30','17','00000277',1,'biber','B','blue','195F20FD','17;00000277;1;biber;B;blue;195F20FD','43d58f5c-dcef-4882-8fad-6797c14c8f94'),(632,13,'2021-03-15','2021-06-30','17','00000278',1,'biber','B','blue','195F20FD','17;00000278;1;biber;B;blue;195F20FD','0d0de905-52b1-4c5c-b2d5-4ee658ed8f5a'),(633,13,'2021-03-15','2021-06-30','17','00000279',1,'biber','B','blue','195F20FD','17;00000279;1;biber;B;blue;195F20FD','21faf457-a2bc-4e72-bea3-52929d92c505'),(634,13,'2021-03-15','2021-06-30','17','0000027A',1,'biber','B','blue','195F20FD','17;0000027A;1;biber;B;blue;195F20FD','a4d394bb-b298-4768-9276-a1e9d2914661'),(635,13,'2021-03-15','2021-06-30','17','0000027B',1,'biber','B','blue','195F20FD','17;0000027B;1;biber;B;blue;195F20FD','7a0e6417-7034-4a56-95dc-e29598a8352a');


DROP TABLE IF EXISTS image_classifications;

CREATE TABLE image_classifications (
  id  SERIAL,
  image_id int NOT NULL,
  classifier_command_id int NOT NULL,
  is_trap Boolean DEFAULT NULL,
  trap_color varchar(255) DEFAULT NULL,
  has_qrcode Boolean DEFAULT NULL,
  is_blurry Boolean DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE (image_id),
  CONSTRAINT image_classifications_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;

DROP TABLE IF EXISTS image_counts;

CREATE TABLE image_counts (
  id  SERIAL,
  image_id int NOT NULL,
  code varchar(255) NOT NULL,
  ai_total int DEFAULT NULL,
  hu_total int DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE  (image_id,code),
  CONSTRAINT image_counts_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;

DROP TABLE IF EXISTS image_exifs;

CREATE TABLE image_exifs (
  image_id int NOT NULL,
  aperture float DEFAULT NULL,
  cameraMake varchar(255) DEFAULT NULL,
  cameraModel varchar(255) DEFAULT NULL,
  datetime_taken timestamp DEFAULT NULL,
  exposureMode varchar(255) DEFAULT NULL,
  exposureTime float DEFAULT NULL,
  focalLength float DEFAULT NULL,
  height int DEFAULT NULL,
  isoSpeed int DEFAULT NULL,
  lens varchar(255) DEFAULT NULL,
  rotation varchar(255) DEFAULT NULL,
  width int DEFAULT NULL,
  UNIQUE (image_id),
  CONSTRAINT image_exifs_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;

DROP TABLE IF EXISTS image_infs;

CREATE TABLE image_infs (
  id  SERIAL,
  image_id int NOT NULL,
  code varchar(255) NOT NULL,
  x_min int NOT NULL,
  y_min int NOT NULL,
  x_max int NOT NULL,
  y_max int NOT NULL,
  confidence float NOT NULL,
  yolo_bbox text NOT NULL,
  PRIMARY KEY (id)
) ;

DROP TABLE IF EXISTS image_lowres_versions;

CREATE TABLE image_lowres_versions (
  id  SERIAL,
  image_id int NOT NULL,
  images_path varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE  (image_id),
  CONSTRAINT image_lowres_versions_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;


DROP TABLE IF EXISTS image_scanned_mqrs;

CREATE TABLE image_scanned_mqrs (
  id  SERIAL,
  image_id int NOT NULL,
  trap_no varchar(255) NOT NULL,
  trap_uid varchar(255) NOT NULL,
  field_no int NOT NULL,
  crop_type varchar(255) NOT NULL,
  trap_face varchar(255) NOT NULL,
  trap_type varchar(255) NOT NULL,
  field_uid varchar(255) NOT NULL,
  label varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE  (image_id),
  CONSTRAINT image_scanned_mqrs_ibfk_1 FOREIGN KEY (image_id) REFERENCES images (id)
) ;

DROP TABLE IF EXISTS image_tile_infs;

CREATE TABLE image_tile_infs (
  id  SERIAL,
  image_tile_id int NOT NULL,
  code varchar(255) NOT NULL,
  x_min int NOT NULL,
  y_min int NOT NULL,
  x_max int NOT NULL,
  y_max int NOT NULL,
  confidence float NOT NULL,
  PRIMARY KEY (id)
) ;

DROP TABLE IF EXISTS image_tiles;

CREATE TABLE image_tiles (
  id  SERIAL,
  image_id int NOT NULL,
  pseudo_x int NOT NULL,
  pseudo_y int NOT NULL,
  x_start int NOT NULL,
  x_size int NOT NULL,
  y_start int NOT NULL,
  y_size int NOT NULL,
  tiles_path varchar(255) NOT NULL,
  inf_status varchar(255) DEFAULT NULL,
  to_delete smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;






















