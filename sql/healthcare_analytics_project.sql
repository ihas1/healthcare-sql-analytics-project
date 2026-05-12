-- =====================================================
-- HEALTHCARE REVENUE CYCLE & PATIENT ANALYTICS PROJECT
-- PostgreSQL Portfolio Project
-- =====================================================

-- =====================================================
-- DROP TABLES (FOR RE-RUNNING SCRIPT)
-- =====================================================

DROP TABLE IF EXISTS claim_denials;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS patients;

-- =====================================================
-- CREATE TABLE: patients
-- =====================================================

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    city VARCHAR(50),
    state VARCHAR(50),
    chronic_condition BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- CREATE TABLE: providers
-- =====================================================

CREATE TABLE providers (
    provider_id SERIAL PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(100),
    department VARCHAR(100),
    hire_date DATE
);

-- =====================================================
-- CREATE TABLE: diagnoses
-- =====================================================

CREATE TABLE diagnoses (
    diagnosis_code VARCHAR(20) PRIMARY KEY,
    diagnosis_description VARCHAR(255),
    diagnosis_category VARCHAR(100)
);

-- =====================================================
-- CREATE TABLE: admissions
-- =====================================================

CREATE TABLE admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    provider_id INT REFERENCES providers(provider_id),
    admission_date DATE,
    discharge_date DATE,
    admission_type VARCHAR(50),
    diagnosis_code VARCHAR(20)
  REFERENCES diagnoses(diagnosis_code),
    total_charges NUMERIC(12,2),
    room_number VARCHAR(20)
);

-- =====================================================
-- CREATE TABLE: claims
-- =====================================================

CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    admission_id INT REFERENCES admissions(admission_id),
    insurance_provider VARCHAR(100),
    claim_amount NUMERIC(12,2),
    approved_amount NUMERIC(12,2),
    claim_status VARCHAR(50),
    submission_date DATE,
    payment_date DATE
);

-- =====================================================
-- CREATE TABLE: claim_denials
-- =====================================================

CREATE TABLE claim_denials (
    denial_id SERIAL PRIMARY KEY,
    claim_id INT REFERENCES claims(claim_id),
    denial_reason VARCHAR(255),
    denial_date DATE,
    appeal_status VARCHAR(50)
);

-- =====================================================
-- INSERT SAMPLE DATA: patients
-- =====================================================

INSERT INTO patients (
    first_name,
    last_name,
    gender,
    date_of_birth,
    city,
    state,
    chronic_condition
)
VALUES
('John', 'Smith', 'Male', '1972-04-15', 'Chicago', 'Illinois', TRUE),
('Maria', 'Lopez', 'Female', '1985-08-22', 'Houston', 'Texas', FALSE),
('David', 'Johnson', 'Male', '1958-12-10', 'Phoenix', 'Arizona', TRUE),
('Emily', 'Clark', 'Female', '1992-03-05', 'Dallas', 'Texas', FALSE),
('Robert', 'Miller', 'Male', '1965-09-30', 'Atlanta', 'Georgia', TRUE);

-- =====================================================
-- INSERT SAMPLE DATA: providers
-- =====================================================

INSERT INTO providers (
    provider_name,
    specialty,
    department,
    hire_date
)
VALUES
('Dr. Sarah Wilson', 'Cardiology', 'Heart Institute', '2018-05-01'),
('Dr. Michael Lee', 'Internal Medicine', 'General Medicine', '2020-07-15'),
('Dr. Amanda Green', 'Pulmonology', 'Respiratory Care', '2019-09-10');

-- =====================================================
-- INSERT SAMPLE DATA: diagnoses
-- =====================================================

INSERT INTO diagnoses (
    diagnosis_code,
    diagnosis_description,
    diagnosis_category
)
VALUES
('I10', 'Essential Hypertension', 'Cardiovascular'),
('E11', 'Type 2 Diabetes Mellitus', 'Endocrine'),
('J44', 'Chronic Obstructive Pulmonary Disease', 'Respiratory'),
('I50', 'Congestive Heart Failure', 'Cardiovascular');

-- =====================================================
-- INSERT SAMPLE DATA: admissions
-- =====================================================

INSERT INTO admissions (
    patient_id,
    provider_id,
    admission_date,
    discharge_date,
    admission_type,
    diagnosis_code,
    total_charges,
    room_number
)
VALUES
(1, 1, '2025-01-10', '2025-01-15', 'Emergency', 'I50', 18500.00, '201A'),
(2, 2, '2025-01-11', '2025-01-13', 'Elective', 'E11', 7200.00, '115B'),
(3, 3, '2025-01-15', '2025-01-20', 'Emergency', 'J44', 14200.00, '310C'),
(1, 1, '2025-02-01', '2025-02-05', 'Readmission', 'I50', 12600.00, '205A');

-- =====================================================
-- INSERT SAMPLE DATA: claims
-- =====================================================

INSERT INTO claims (
    admission_id,
    insurance_provider,
    claim_amount,
    approved_amount,
    claim_status,
    submission_date,
    payment_date
)
VALUES
(1, 'BlueCross', 18500.00, 17200.00, 'Approved', '2025-01-16', '2025-01-30'),
(2, 'Aetna', 7200.00, 6800.00, 'Approved', '2025-01-14', '2025-01-25'),
(3, 'UnitedHealth', 14200.00, 0.00, 'Denied', '2025-01-21', NULL),
(4, 'BlueCross', 12600.00, 11800.00, 'Approved', '2025-02-06', '2025-02-20');

-- =====================================================
-- INSERT SAMPLE DATA: claim_denials
-- =====================================================

INSERT INTO claim_denials (
    claim_id,
    denial_reason,
    denial_date,
    appeal_status
)
VALUES
(3, 'Missing documentation', '2025-01-28', 'Pending');

-- =====================================================
-- CREATE INDEXES
-- =====================================================

CREATE INDEX idx_admissions_patient_id
ON admissions(patient_id);

CREATE INDEX idx_admissions_provider_id
ON admissions(provider_id);

CREATE INDEX idx_claims_status
ON claims(claim_status);

CREATE INDEX idx_claims_admission_id
ON claims(admission_id);

-- =====================================================
-- CREATE VIEW
-- =====================================================

CREATE VIEW vw_patient_admissions AS
SELECT
    a.admission_id,
    p.patient_id,
    p.first_name,
    p.last_name,
    pr.provider_name,
    a.admission_date,
    a.discharge_date,
    a.total_charges,
    a.diagnosis_code
FROM admissions a
JOIN patients p
    ON a.patient_id = p.patient_id
JOIN providers pr
    ON a.provider_id = pr.provider_id;

-- =====================================================
-- KPI QUERY 1: AVERAGE LENGTH OF STAY
-- =====================================================

SELECT
    pr.provider_name,
    ROUND(
        AVG(a.discharge_date - a.admission_date),
        2
    ) AS average_length_of_stay
FROM admissions a
JOIN providers pr
    ON a.provider_id = pr.provider_id
GROUP BY pr.provider_name
ORDER BY average_length_of_stay DESC;

-- =====================================================
-- KPI QUERY 2: 30-DAY READMISSION ANALYSIS
-- =====================================================

WITH patient_admissions AS (
    SELECT
        patient_id,
        admission_id,
        admission_date,
        LAG(discharge_date) OVER (
            PARTITION BY patient_id
            ORDER BY admission_date
        ) AS previous_discharge_date
    FROM admissions
)

SELECT
    patient_id,
    admission_id,
    admission_date,
    previous_discharge_date,
    admission_date - previous_discharge_date AS days_between_visits
FROM patient_admissions
WHERE admission_date - previous_discharge_date <= 30;

-- =====================================================
-- KPI QUERY 3: CLAIM DENIAL RATE
-- =====================================================

SELECT
    COUNT(*) AS total_claims,
    SUM(
        CASE
            WHEN claim_status = 'Denied' THEN 1
            ELSE 0
        END
    ) AS denied_claims,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN claim_status = 'Denied' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS denial_rate_percentage
FROM claims;

-- =====================================================
-- KPI QUERY 4: PROVIDER REVENUE PERFORMANCE
-- =====================================================

SELECT
    pr.provider_name,
    pr.specialty,
    COUNT(a.admission_id) AS total_admissions,
    SUM(c.claim_amount) AS total_billed_amount,
    SUM(c.approved_amount) AS total_reimbursed_amount,
    ROUND(
        100.0 * SUM(c.approved_amount)
        / NULLIF(SUM(c.claim_amount), 0),
        2
    ) AS reimbursement_rate
FROM providers pr
JOIN admissions a
    ON pr.provider_id = a.provider_id
JOIN claims c
    ON a.admission_id = c.admission_id
GROUP BY
    pr.provider_name,
    pr.specialty
ORDER BY total_reimbursed_amount DESC;

-- =====================================================
-- KPI QUERY 5: CHRONIC CONDITION ANALYSIS
-- =====================================================

SELECT
    p.chronic_condition,
    COUNT(DISTINCT p.patient_id) AS patient_count,
    ROUND(AVG(a.total_charges), 2) AS average_hospital_charges,
    SUM(a.total_charges) AS total_hospital_revenue
FROM patients p
JOIN admissions a
    ON p.patient_id = a.patient_id
GROUP BY p.chronic_condition;

-- =====================================================
-- KPI QUERY 6: MONTHLY REVENUE TREND ANALYSIS
-- =====================================================

SELECT
    DATE_TRUNC('month', payment_date) AS payment_month,
    SUM(approved_amount) AS monthly_revenue,
    COUNT(claim_id) AS paid_claims,
    ROUND(
        AVG(approved_amount),
        2
    ) AS average_payment
FROM claims
WHERE payment_date IS NOT NULL
GROUP BY DATE_TRUNC('month', payment_date)
ORDER BY payment_month;

-- =====================================================
-- KPI QUERY 7: REVENUE BY DIAGNOSIS CATEGORY
-- =====================================================

SELECT
    d.diagnosis_category,
    COUNT(a.admission_id) AS admissions_count,
    SUM(a.total_charges) AS total_revenue,
    ROUND(AVG(a.total_charges), 2) AS average_charge
FROM admissions a
JOIN diagnoses d
    ON a.diagnosis_code = d.diagnosis_code
GROUP BY d.diagnosis_category
ORDER BY total_revenue DESC;
