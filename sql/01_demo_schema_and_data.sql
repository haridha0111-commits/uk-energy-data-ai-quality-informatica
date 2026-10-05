/*
  SQL Server-compatible synthetic demo. Run once in a disposable learning database.
  All identities, addresses, identifiers and amounts are fictional. Deliberate defects
  are documented in README/docs; do not connect this script to production.
  Schema creation is guarded; tables are never dropped or truncated.
*/
IF SCHEMA_ID(N'energy_dq_demo') IS NULL EXEC(N'CREATE SCHEMA energy_dq_demo');
GO

IF OBJECT_ID(N'energy_dq_demo.customer', N'U') IS NULL
CREATE TABLE energy_dq_demo.customer (
  customer_id varchar(20) NOT NULL PRIMARY KEY,
  email varchar(200) NULL,
  postcode varchar(12) NULL,
  source_system varchar(30) NOT NULL,
  ingested_at datetime2 NOT NULL
);
IF OBJECT_ID(N'energy_dq_demo.account', N'U') IS NULL
CREATE TABLE energy_dq_demo.account (
  account_id varchar(20) NOT NULL PRIMARY KEY,
  customer_id varchar(20) NULL,
  account_status varchar(30) NULL,
  premise_id varchar(20) NULL,
  source_system varchar(30) NOT NULL,
  ingested_at datetime2 NOT NULL
);
IF OBJECT_ID(N'energy_dq_demo.meter', N'U') IS NULL
CREATE TABLE energy_dq_demo.meter (
  meter_id varchar(20) NOT NULL PRIMARY KEY,
  premise_id varchar(20) NULL,
  fuel_type varchar(15) NULL,
  meter_status varchar(20) NULL,
  unit_code varchar(15) NULL,
  source_system varchar(30) NOT NULL,
  ingested_at datetime2 NOT NULL
);
IF OBJECT_ID(N'energy_dq_demo.meter_read', N'U') IS NULL
CREATE TABLE energy_dq_demo.meter_read (
  read_id varchar(20) NOT NULL PRIMARY KEY,
  meter_id varchar(20) NULL,
  read_at datetime2 NULL,
  read_value decimal(18,3) NULL,
  read_type varchar(20) NULL,
  unit_code varchar(15) NULL,
  source_system varchar(30) NOT NULL,
  ingested_at datetime2 NOT NULL
);
IF OBJECT_ID(N'energy_dq_demo.bill', N'U') IS NULL
CREATE TABLE energy_dq_demo.bill (
  bill_id varchar(20) NOT NULL PRIMARY KEY,
  account_id varchar(20) NULL,
  meter_id varchar(20) NULL,
  read_id varchar(20) NULL,
  period_start date NULL,
  period_end date NULL,
  read_provenance varchar(20) NULL,
  billed_amount decimal(12,2) NULL,
  source_system varchar(30) NOT NULL,
  ingested_at datetime2 NOT NULL
);
GO

DECLARE @batch_time datetime2 = '2026-08-31T08:00:00';
INSERT INTO energy_dq_demo.customer (customer_id,email,postcode,source_system,ingested_at)
SELECT v.customer_id,v.email,v.postcode,v.source_system,@batch_time
FROM (VALUES
 ('C001','ada@example.test','SW1A 1AA','CRM'),
 ('C002','ben@example.test','EH1 1AA','CRM'),
 ('C003','cara@example.test','M1 1AE','LEGACY_CRM'),
 ('C004','dan@example.test','BS1 4ST','CRM'),
 ('C005','eva@example.test','CF10 1EP','CRM'),
 ('C006','fin@example.test','G1 2FF','LEGACY_CRM'),
 ('C007','gwen@example.test','LS1 2AB','CRM'),
 ('C008','hal@example.test','L1 8JQ','CRM'),
 ('C009','ivy@example.test','NE1 4LP','CRM'),
 ('C010','jo@example.test','BT1 5GS','LEGACY_CRM'),
 ('C011','kim@example.test','OX1 1AA','CRM'),
 ('C012','lee@example.test','SE1 2AA','CRM'),
 ('C013','max@example.test','ZZ99 9ZZ','LEGACY_CRM'), -- intentionally invalid postcode candidate
 ('C014','no-at-symbol','N1 9GU','CRM'), -- intentionally malformed email
 ('C015',NULL,'B1 1AA','CRM'), -- optional email: unknown for this rule, not auto-fail
 ('C016','pat@example.test','E1 6AN','CRM'),
 ('C017','ria@example.test','SW1A 1AA','LEGACY_CRM'), -- possible duplicate signal only
 ('C018','sam@example.test','EH1 1AA','CRM')
) v(customer_id,email,postcode,source_system)
WHERE NOT EXISTS (SELECT 1 FROM energy_dq_demo.customer t WHERE t.customer_id=v.customer_id);

INSERT INTO energy_dq_demo.account (account_id,customer_id,account_status,premise_id,source_system,ingested_at)
SELECT v.account_id,v.customer_id,v.account_status,v.premise_id,v.source_system,@batch_time
FROM (VALUES
 ('A001','C001','ACTIVE','P001','BILLING'),('A002','C002','ACTIVE','P002','BILLING'),
 ('A003','C003','ACTIVE','P003','BILLING'),('A004','C004','ACTIVE','P004','BILLING'),
 ('A005','C005','ACTIVE','P005','BILLING'),('A006','C006','ACTIVE','P006','BILLING'),
 ('A007','C007','ACTIVE','P007','BILLING'),('A008','C008','ACTIVE','P008','BILLING'),
 ('A009','C009','ACTIVE','P009','BILLING'),('A010','C010','ACTIVE','P010','BILLING'),
 ('A011','C011','ACTIVE','P011','BILLING'),('A012','C012','ACTIVE','P012','BILLING'),
 ('A013','C013','ACTIVE','P013','BILLING'),('A014','C014','ACTIVE','P014','BILLING'),
 ('A015','C015','ACTIVE','P015','BILLING'),('A016','C016','ACTIVE','P016','BILLING'),
 ('A017','C017','ACTIVE','P017','BILLING'),('A018','C999','ACTIVE','P018','LEGACY_BILLING'), -- orphan customer
 ('A019','C018','ACTV','P019','LEGACY_BILLING') -- unmapped status code
) v(account_id,customer_id,account_status,premise_id,source_system)
WHERE NOT EXISTS (SELECT 1 FROM energy_dq_demo.account t WHERE t.account_id=v.account_id);

INSERT INTO energy_dq_demo.meter (meter_id,premise_id,fuel_type,meter_status,unit_code,source_system,ingested_at)
SELECT v.meter_id,v.premise_id,v.fuel_type,v.meter_status,v.unit_code,v.source_system,@batch_time
FROM (VALUES
 ('M001','P001','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M002','P002','GAS','ACTIVE','m3','METER_OPS'),
 ('M003','P003','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M004','P004','ELECTRICITY','ACTIVE','kWh','METER_OPS'),
 ('M005','P005','GAS','ACTIVE','m3','METER_OPS'),('M006','P006','ELECTRICITY','ACTIVE','kWh','METER_OPS'),
 ('M007','P007','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M008','P008','GAS','ACTIVE','m3','METER_OPS'),
 ('M009','P009','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M010','P010','GAS','ACTIVE','m3','METER_OPS'),
 ('M011','P011','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M012','P012','ELECTRICITY','ACTIVE','kWh','METER_OPS'),
 ('M013','P013','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M014','P014','GAS','ACTIVE','m3','METER_OPS'),
 ('M015','P015','GAS','ACTIVE','m3','METER_OPS'),('M016','P016','ELECTRICITY','ACTIVE','kWh','METER_OPS'),
 ('M017','P017','GAS','ACTIVE','kWh','METER_OPS'), -- deliberately suspect unit/fuel pair
 ('M018','P018','ELECTRICITY','ACTIVE','kWh','METER_OPS'),('M019','P019','GAS','ACTIVE','m3','METER_OPS')
) v(meter_id,premise_id,fuel_type,meter_status,unit_code,source_system)
WHERE NOT EXISTS (SELECT 1 FROM energy_dq_demo.meter t WHERE t.meter_id=v.meter_id);

INSERT INTO energy_dq_demo.meter_read (read_id,meter_id,read_at,read_value,read_type,unit_code,source_system,ingested_at)
SELECT v.read_id,v.meter_id,v.read_at,v.read_value,v.read_type,v.unit_code,v.source_system,@batch_time
FROM (VALUES
 ('R001','M001',CONVERT(datetime2,'2026-08-01'),100.000,'ACTUAL','kWh','READ_API'),
 ('R002','M002',CONVERT(datetime2,'2026-08-02'),20.000,'ESTIMATED','m3','READ_API'),
 ('R003','M003',CONVERT(datetime2,'2026-08-03'),50.000,'ACTUAL','kWh','READ_API'),
 ('R004','M004',CONVERT(datetime2,'2026-08-04'),44.000,'ACTUAL','kWh','READ_API'),
 ('R005','M005',CONVERT(datetime2,'2026-08-05'),11.000,'ESTIMATED','m3','READ_API'),
 ('R006','M006',CONVERT(datetime2,'2026-08-06'),60.000,'ACTUAL','kWh','READ_API'),
 ('R007','M007',CONVERT(datetime2,'2026-08-07'),NULL,'ACTUAL','kWh','LEGACY_READ'), -- missing value
 ('R008','M008',CONVERT(datetime2,'2026-08-08'),18.000,'ACTUAL','m3','READ_API'),
 ('R009','M009',CONVERT(datetime2,'2026-08-09'),-1.000,'ACTUAL','kWh','LEGACY_READ'), -- negative
 ('R010','M010',CONVERT(datetime2,'2026-08-10'),15.000,'EST','m3','LEGACY_READ'), -- unmapped read type
 ('R011','M011',CONVERT(datetime2,'2026-08-11'),25.000,'ACTUAL','kWh','READ_API'),
 ('R012','M012',CONVERT(datetime2,'2026-08-12'),12.000,'ACTUAL','MWH','LEGACY_READ'), -- unexpected unit
 ('R013','M013',CONVERT(datetime2,'2026-08-13'),10.000,'ACTUAL','kWh','READ_API'),
 ('R014','M014',CONVERT(datetime2,'2026-08-14'),31.000,'ESTIMATED','m3','READ_API'),
 ('R015','M015',CONVERT(datetime2,'2026-08-15'),8.000,'ACTUAL','m3','READ_API'),
 ('R016','M016',CONVERT(datetime2,'2026-08-16'),73.000,'ACTUAL','kWh','READ_API'),
 ('R017','M017',CONVERT(datetime2,'2026-08-17'),22.000,'ACTUAL','kWh','READ_API'),
 ('R018','M018',CONVERT(datetime2,'2026-08-18'),10.000,'ACTUAL','kWh','READ_API'),
 ('R019','M019',CONVERT(datetime2,'2026-09-15'),12.000,'ACTUAL','m3','READ_API') -- future-dated vs demo run date
) v(read_id,meter_id,read_at,read_value,read_type,unit_code,source_system)
WHERE NOT EXISTS (SELECT 1 FROM energy_dq_demo.meter_read t WHERE t.read_id=v.read_id);

INSERT INTO energy_dq_demo.bill (bill_id,account_id,meter_id,read_id,period_start,period_end,read_provenance,billed_amount,source_system,ingested_at)
SELECT v.bill_id,v.account_id,v.meter_id,v.read_id,v.period_start,v.period_end,v.read_provenance,v.billed_amount,v.source_system,@batch_time
FROM (VALUES
 ('B001','A001','M001','R001',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',50.00,'BILLING'),
 ('B002','A002','M002','R002',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ESTIMATED',30.00,'BILLING'),
 ('B003','A003','M003','R999',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',45.00,'LEGACY_BILLING'), -- orphan read
 ('B004','A004','M005','R004',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',21.00,'LEGACY_BILLING'), -- meter mismatch
 ('B005','A005','M005','R005',CONVERT(date,'2026-08-10'),CONVERT(date,'2026-08-01'),'ACTUAL',19.00,'BILLING'), -- invalid period, provenance mismatch
 ('B006','A006','M006','R006',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',40.00,'BILLING'),
 ('B007','A007','M007','R007',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',12.00,'BILLING'),
 ('B008','A008','M008','R008',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',29.00,'BILLING'),
 ('B009','A009','M009','R009',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',14.00,'BILLING'),
 ('B010','A010','M010','R010',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',22.00,'BILLING'),
 ('B011','A011','M011','R011',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',20.00,'BILLING'),
 ('B012','A012','M012','R012',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',25.00,'BILLING'),
 ('B013','A013','M013','R013',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',16.00,'BILLING'),
 ('B014','A014','M014','R014',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ESTIMATED',18.00,'BILLING'),
 ('B015','A015','M015','R015',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',11.00,'BILLING'),
 ('B016','A016','M016','R016',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',32.00,'BILLING'),
 ('B017','A017','M017','R017',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',25.00,'BILLING'),
 ('B018','A018','M018','R018',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',15.00,'LEGACY_BILLING'), -- orphan customer via account
 ('B019','A999','M019','R019',CONVERT(date,'2026-07-01'),CONVERT(date,'2026-08-01'),'ACTUAL',17.00,'LEGACY_BILLING') -- orphan account
) v(bill_id,account_id,meter_id,read_id,period_start,period_end,read_provenance,billed_amount,source_system)
WHERE NOT EXISTS (SELECT 1 FROM energy_dq_demo.bill t WHERE t.bill_id=v.bill_id);
GO

-- Quick inventory: inspect row counts before running the metrics reference script.
SELECT 'customer' AS entity, COUNT_BIG(*) AS row_count FROM energy_dq_demo.customer
UNION ALL SELECT 'account', COUNT_BIG(*) FROM energy_dq_demo.account
UNION ALL SELECT 'meter', COUNT_BIG(*) FROM energy_dq_demo.meter
UNION ALL SELECT 'meter_read', COUNT_BIG(*) FROM energy_dq_demo.meter_read
UNION ALL SELECT 'bill', COUNT_BIG(*) FROM energy_dq_demo.bill;
