/*******************************************************************************************/
-- Script: MergeTables.sql
-- Author: Meet Patel
-- Date: October 18, 2019
/*******************************************************************************************/


USE CHDB;

/********************************************/
-- Group 1 - Basic Queries
/********************************************/
PRINT 'GROUP 1 SELECT A'
SELECT COUNT(*)
FROM patients
WHERE FLOOR(DATEDIFF(DAY, birth_date, GETDATE()) / 365.25) < 18;

PRINT 'GROUP 1 SELECT B'
SELECT COUNT(*)
FROM patients
WHERE gender = 'M' AND patient_weight < (SELECT AVG(patient_weight)
					 FROM patients
				         WHERE gender = 'F');

/********************************************/
-- Group 2 - Sub-totals using GROUP BY 
/********************************************/
PRINT 'GROUP 2 SELECT A'
SELECT nursing_unit_id, COUNT(*)
FROM admissions
WHERE discharge_date IS NULL AND SUBSTRING(nursing_unit_id, 1, 1) IN ('1', '2')
GROUP BY nursing_unit_id;

PRINT 'GROUP 2 SELECT B'
SELECT attending_physician_id, COUNT(*)
FROM admissions
WHERE discharge_date IS NULL
GROUP BY attending_physician_id;

/********************************************/
-- Group 3 - Two table JOINS and ORDER BY
/********************************************/
PRINT 'GROUP 3 SELECT A'
SELECT p.patient_id, first_name, last_name, room, bed
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
WHERE discharge_date IS NULL AND nursing_unit_id = '2SOUTH'
ORDER BY last_name;

PRINT 'GROUP 3 SELECT B'
SELECT pharmacist_initials, entered_date, dosage
FROM unit_dose_orders u
JOIN medications m
ON u.medication_id = m.medication_id
WHERE medication_description LIKE '%morphine%'
ORDER BY pharmacist_initials;

/********************************************/
-- Group 4 - Three table JOINS
/********************************************/
PRINT 'GROUP 4 SELECT A'
SELECT p.physician_id, p.first_name, p.last_name, specialty
FROM physicians p
JOIN encounters e
ON p.physician_id = e.physician_id
JOIN patients pa
ON e.patient_id = pa.patient_id
WHERE pa.first_name = 'Harry' AND pa.last_name = 'Sullivan';

PRINT 'GROUP 4 SELECT B'
SELECT p.patient_id, p.first_name, p.last_name, nursing_unit_id, primary_diagnosis
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
JOIN physicians ph
ON attending_physician_id = physician_id
WHERE discharge_date IS NULL AND specialty = 'Internist';

/********************************************/
-- Group 5 - Four table JOINS
/********************************************/
PRINT 'GROUP 5 SELECT A'
SELECT p.first_name + ' ' + p.last_name physician, n.specialty, pa.first_name + ' ' + pa.last_name patient, primary_diagnosis
FROM physicians p
JOIN admissions a
ON physician_id = attending_physician_id
JOIN nursing_units n
ON a.nursing_unit_id = n.nursing_unit_id
JOIN patients pa
ON a.patient_id = pa.patient_id
WHERE discharge_date IS NULL AND secondary_diagnoses IS NULL;

/********************************************/
-- Group 6 - WHERE [NOT] IN
/********************************************/
PRINT 'GROUP 6 SELECT B'
SELECT purchase_order_id, order_date, department_id
FROM purchase_orders po
WHERE purchase_order_id NOT IN (SELECT purchase_order_id
				FROM purchase_order_lines);
