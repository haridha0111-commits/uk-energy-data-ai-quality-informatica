/* Transparent SQL Server reference checks for the synthetic demo only. */

-- Rule-level row checks: keep PASS / FAIL / UNKNOWN distinct.
WITH checks AS (
  SELECT 'CST-001' AS rule_id, customer_id AS record_key,
         CASE WHEN NULLIF(LTRIM(RTRIM(customer_id)), '') IS NULL THEN 'FAIL' ELSE 'PASS' END AS outcome
  FROM energy_dq_demo.customer
  UNION ALL
  SELECT 'CST-002', customer_id,
         CASE WHEN email IS NULL OR LTRIM(RTRIM(email)) = '' THEN 'UNKNOWN'
              WHEN email LIKE '%_@_%._%' AND email NOT LIKE '% %' THEN 'PASS' ELSE 'FAIL' END
  FROM energy_dq_demo.customer
  UNION ALL
  SELECT 'ACC-003', a.account_id,
         CASE WHEN a.customer_id IS NULL THEN 'UNKNOWN'
              WHEN c.customer_id IS NULL THEN 'FAIL' ELSE 'PASS' END
  FROM energy_dq_demo.account a LEFT JOIN energy_dq_demo.customer c ON c.customer_id=a.customer_id
  UNION ALL
  SELECT 'RED-001', r.read_id,
         CASE WHEN r.read_at IS NULL OR r.read_value IS NULL OR r.unit_code IS NULL OR r.read_type IS NULL THEN 'FAIL' ELSE 'PASS' END
  FROM energy_dq_demo.meter_read r
  UNION ALL
  SELECT 'RED-002', r.read_id,
         CASE WHEN r.read_value IS NULL THEN 'UNKNOWN' WHEN r.read_value < 0 THEN 'FAIL' ELSE 'PASS' END
  FROM energy_dq_demo.meter_read r
  UNION ALL
  SELECT 'RED-003', r.read_id,
         CASE WHEN r.unit_code IS NULL THEN 'UNKNOWN'
              WHEN (m.fuel_type='ELECTRICITY' AND r.unit_code IN ('kWh','MWh'))
                OR (m.fuel_type='GAS' AND r.unit_code IN ('m3','kWh')) THEN 'PASS'
              ELSE 'FAIL' END
  FROM energy_dq_demo.meter_read r LEFT JOIN energy_dq_demo.meter m ON m.meter_id=r.meter_id
  UNION ALL
  SELECT 'BIL-002', b.bill_id,
         CASE WHEN b.read_id IS NULL THEN 'UNKNOWN'
              WHEN r.read_id IS NULL OR r.meter_id <> b.meter_id THEN 'FAIL' ELSE 'PASS' END
  FROM energy_dq_demo.bill b LEFT JOIN energy_dq_demo.meter_read r ON r.read_id=b.read_id
  UNION ALL
  SELECT 'BIL-003', b.bill_id,
         CASE WHEN b.read_provenance IS NULL OR r.read_type IS NULL THEN 'UNKNOWN'
              WHEN b.read_provenance = r.read_type THEN 'PASS'
              WHEN b.read_provenance='ESTIMATED' AND r.read_type='ESTIMATED' THEN 'PASS'
              ELSE 'FAIL' END
  FROM energy_dq_demo.bill b LEFT JOIN energy_dq_demo.meter_read r ON r.read_id=b.read_id
  UNION ALL
  SELECT 'BIL-004', bill_id,
         CASE WHEN period_start IS NULL OR period_end IS NULL THEN 'UNKNOWN'
              WHEN period_end <= period_start THEN 'FAIL' ELSE 'PASS' END
  FROM energy_dq_demo.bill
), counts AS (
  SELECT rule_id,
         COUNT_BIG(*) AS evaluated_or_unknown_count,
         SUM(CASE WHEN outcome='PASS' THEN 1 ELSE 0 END) AS pass_count,
         SUM(CASE WHEN outcome='FAIL' THEN 1 ELSE 0 END) AS fail_count,
         SUM(CASE WHEN outcome='UNKNOWN' THEN 1 ELSE 0 END) AS unknown_count
  FROM checks GROUP BY rule_id
)
SELECT rule_id, evaluated_or_unknown_count, pass_count, fail_count, unknown_count,
       CAST(100.0 * pass_count / NULLIF(pass_count + fail_count, 0) AS decimal(6,2)) AS pass_pct_of_evaluable
FROM counts ORDER BY rule_id;

-- Critical billing-chain review queue. This identifies demo exceptions; it is not a billing decision.
SELECT b.bill_id, b.account_id, b.meter_id AS billed_meter_id, b.read_id,
       CASE
         WHEN a.account_id IS NULL THEN 'BILL_ACCOUNT_MISSING'
         WHEN c.customer_id IS NULL THEN 'ACCOUNT_CUSTOMER_MISSING'
         WHEN r.read_id IS NULL THEN 'BILL_READ_MISSING'
         WHEN r.meter_id <> b.meter_id THEN 'BILL_READ_METER_MISMATCH'
         WHEN b.period_start IS NULL OR b.period_end IS NULL OR b.period_end <= b.period_start THEN 'BILL_PERIOD_INVALID'
         WHEN b.read_provenance IS NULL OR r.read_type IS NULL THEN 'READ_PROVENANCE_UNKNOWN'
         WHEN b.read_provenance <> r.read_type THEN 'READ_PROVENANCE_MISMATCH'
         ELSE 'REVIEWED_BY_RULES_ONLY'
       END AS exception_reason
FROM energy_dq_demo.bill b
LEFT JOIN energy_dq_demo.account a ON a.account_id=b.account_id
LEFT JOIN energy_dq_demo.customer c ON c.customer_id=a.customer_id
LEFT JOIN energy_dq_demo.meter_read r ON r.read_id=b.read_id
WHERE a.account_id IS NULL OR c.customer_id IS NULL OR r.read_id IS NULL
   OR r.meter_id <> b.meter_id
   OR b.period_start IS NULL OR b.period_end IS NULL OR b.period_end <= b.period_start
   OR b.read_provenance IS NULL OR r.read_type IS NULL OR b.read_provenance <> r.read_type
ORDER BY b.bill_id;

-- Freshness check example. Production service objective/time zone is agreed with source owner.
SELECT source_system, MAX(ingested_at) AS latest_ingested_at,
       DATEDIFF(minute, MAX(ingested_at), SYSUTCDATETIME()) AS minutes_since_ingest
FROM energy_dq_demo.meter_read
GROUP BY source_system;
