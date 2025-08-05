-- Author: Marco A. Tinoco Sosa

-- 1
SELECT name
FROM patient
WHERE patient_id = 1;

-- 2
SELECT name 
FROM patient
WHERE phone_number = '312-555-1234';

-- 3
SELECT name, diseases, diagnosis_date, description
FROM patient
JOIN HealthRecord ON patient.patient_id = HealthRecord.patient_id
WHERE patient.patient_id = 2;

-- 4
SELECT *
FROM InstructionExecution
WHERE status = 'Completed';

-- 5
SELECT name
FROM patient
JOIN HealthRecord ON patient.patient_id = healthRecord.patient_id
WHERE status = 'Ongoing'
ORDER BY patient.name DESC; 

-- 6 
SELECT Nurse.nurse_id, Nurse.name AS Nurse, Patient.name AS Patient, description
FROM Nurse
JOIN InstructionExecution ON Nurse.nurse_id = InstructionExecution.nurse_id
JOIN Instruction ON InstructionExecution.instruction_id = Instruction.instruction_id
JOIN Patient ON Instruction.patient_id = Patient.patient_id;

-- 7
SELECT SUM(amount) 
FROM payment;

-- 8
SELECT ROUND(AVG(amount), 2)
FROM Medication;

-- 9 
SELECT Patient.name, Physician.name, PatientMonitoring.start_date, PatientMonitoring.end_date
FROM Patient
JOIN PatientMonitoring ON Patient.patient_id = PatientMonitoring.patient_id
JOIN Physician ON PatientMonitoring.physician_id = Physician.physician_id
WHERE field = "Surgery";

-- 10
SELECT DISTINCT Patient.name, room.capacity, room.nightly_fee
FROM Patient
JOIN PatientRoomAssignment ON PatientRoomAssignment.patient_id = patient.patient_id
JOIN Room ON PatientRoomAssignment.room_number = Room.room_number
WHERE check_in = '2025-06-03';

-- 11 
SELECT Patient.name
FROM patient
JOIN Invoice ON patient.patient_id = Invoice.patient_id
JOIN Payable ON Invoice.invoice_id = Payable.invoice_id
WHERE amount >= 350.00 AND amount <= 450.00
ORDER BY Patient.name DESC;

-- 12
SELECT Patient.name, Payable.amount
FROM Patient
JOIN Invoice ON patient.patient_id = Invoice.patient_id
JOIN Payable ON Invoice.invoice_id = Payable.invoice_id
WHERE Payable.amount IN 
(SELECT MAX(Payable.amount) 
FROM Payable
JOIN Invoice ON Payable.invoice_id = Invoice.invoice_id
JOIN Patient ON Invoice.patient_id = Patient.patient_id);

-- 13 
SELECT Patient.name, Medication.type
FROM Medication 
JOIN Patient ON Medication.patient_id = Patient.patient_id
WHERE EXISTS 
(SELECT * 
FROM Medication M2
WHERE M2.patient_id = Medication.patient_id AND amount > 8.00);

-- 14
SELECT Patient.name, Medication.type
FROM Medication 
JOIN Patient ON Medication.patient_id = Patient.patient_id
WHERE NOT EXISTS 
(SELECT * 
FROM Medication M2
WHERE M2.patient_id = Medication.patient_id AND amount > 8.00);

-- 15
SELECT name
FROM Patient
WHERE patient_id IN 
(SELECT Patient_id 
FROM Medication
WHERE amount > 15.00);

-- 16 
SELECT name
FROM Patient
JOIN Medication ON Patient.patient_id = Medication.patient_id
where Medication.amount > 
(SELECT AVG(amount)
FROM Medication);

-- 17 
SELECT COUNT(*) AS Ongoing 
FROM HealthRecord
WHERE status = 'Ongoing';

-- Trigger
DELIMITER //

CREATE TRIGGER default_room_fee
BEFORE INSERT
ON Room
FOR EACH ROW 
BEGIN 
	IF NEW.nightly_fee IS NULL THEN
		SET NEW.nightly_fee = 800.00;
	END IF;
END;
//

DELIMITER ;

INSERT INTO Room (room_number, capacity) VALUES (106, 3);

-- Trigger

DELIMITER // 

CREATE TRIGGER verify_room_availability
BEFORE INSERT
ON PatientRoomAssignment 
FOR EACH ROW
BEGIN
	IF EXISTS (
    SELECT * 
    FROM PatientRoomAssignment
    WHERE  room_number = NEW.room_number AND NEW.check_in <= check_out AND New.check_out >= check_in
    ) Then
		SET NEW.room_number = (SELECT MAX(room_number) + 1 FROM Room);
        
        INSERT INTO Room VALUES (NEW.room_number,2, 500.00);
	END IF;
END;
//

DELIMITER ;

-- room number 102 was checked in 06-02 and checked out 06-03 so it'll pass
INSERT INTO PatientRoomAssignment VALUES (10006, NULL, 102, '2025-06-05', '2025-06-06');

-- Should trigger and reassign room number to MAX(room_number) + 1
INSERT INTO PatientRoomAssignment VALUES (10007, NULL, 101, '2025-06-01', '2025-06-02');


-- Trigger 

DELIMITER //

CREATE TRIGGER update_instructionExecution
BEFORE UPDATE
ON InstructionExecution
FOR EACH ROW
BEGIN
	IF NEW.execution_record = 'Done' THEN
    SET NEW.status = 'Completed';
	END IF;
END;
//

DELIMITER ;

UPDATE InstructionExecution SET execution_record = 'Done'
WHERE execution_id = 12005; 


-- View

CREATE VIEW Patient_Health_summary AS
SELECT Patient.name, diseases, diagnosis_date, status, description
FROM Patient 
JOIN HealthRecord ON Patient.patient_id = HealthRecord.patient_id;

SELECT * FROM Patient_Health_Summary;

-- View

CREATE VIEW Nurse_Instructions AS 
SELECT Nurse.name, Instruction.instruction_id, status, execution_record
FROM Nurse
JOIN InstructionExecution ON Nurse.nurse_id = InstructionExecution.nurse_id
JOIN Instruction ON InstructionExecution.instruction_id = Instruction.instruction_id;

SELECT * FROM Nurse_Instructions;

-- View

CREATE VIEW Medication_Administered AS
SELECT Nurse.name AS Nurse, type AS Medication, Patient.name AS Patient, date
FROM Medication
JOIN Nurse ON Medication.nurse_id = Nurse.nurse_id
JOIN Patient ON Medication.patient_id = Patient.Patient_id;

SELECT * FROM Medication_Administered;

-- Transaction 

START TRANSACTION;

INSERT INTO Patient VALUES (6, 'Gonzalo Smith', '350 E Cermak, Chicago, IL', '773-123-4321');

INSERT INTO PatientRoomAssignment VALUES (10008, 6, 101, '2025-07-31', '2025-08-05');

INSERT INTO Healthrecord VALUES (1006, 6, 'High Cholesterol', '2025-07-31', 'Ongoing', 'Lifestyle changes and medication');

COMMIT;

SELECT * 
FROM Patient 
WHERE patient_id = 6;

-- Transaction 

START TRANSACTION;

INSERT INTO Invoice VALUES (7006, '2025-07-31', '2025-07-27', '2025-07-30', 'CHI7006', 6);
INSERT INTO Payable VALUES (8006, 1050.00, '2025-07-31', 'Room 101 $350x3', 7006);

COMMIT;

SELECT * 
FROM Invoice 
WHERE invoice_id = 7006;


