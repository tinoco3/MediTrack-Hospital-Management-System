# Hospital Management Tracking System
- Author: Marco A. Tinoco Sosa
## Database Assumptions

### Room Allocation
- Each room can accommodate multiple patients  
- A patient can only be assigned to **one room per hospital stay**

### Staff Responsibilities
- Each medical instruction must be executed by **exactly one nurse**  
- Every physician must have **at least one assigned patient** at all times

### Billing Structure
- All financial records are consolidated under Payables, including:  
  - Room assignments  
  - Medication administrations  
  - Physician instructions  

### Patient Records
- **Health records are mandatory** for all patients  
- Complete medical history tracking including:  
  - Diagnoses  
  - Treatment status  
  - Ongoing conditions
 
### E(ERD)

<img width="938" height="865" alt="Screenshot 2025-08-05 at 4 30 09 PM" src="https://github.com/user-attachments/assets/90f24357-b099-48d2-95e2-48b55fd8ac74" />


- A comprehensive SQL database solution for hospital operations management, handling patient care, billing, room allocation, and staff workflows.

## Database Schema: Relations and Keys

### Table Structure
| Table | Primary Key | Foreign Keys | Description |
|-------|------------|-------------|-------------|
| **Patient** | `patient_id` | - | Stores patient personal information |
| **Physician** | `physician_id` | - | Contains doctor credentials and specialties |
| **Nurse** | `nurse_id` | - | Maintains nurse certification details |
| **Room** | `room_number` | - | Tracks room capacity and pricing |

### Relationship Tables
| Table | Primary Key | Foreign Keys | Relationships |
|-------|------------|-------------|--------------|
| **HealthRecord** | `record_id` | `patient_id` → Patient | Medical history linked to patients |
| **Invoice** | `invoice_id` | `patient_id` → Patient | Billing documents per patient |
| **Payable** | `payable_id` | `invoice_id` → Invoice | Consolidated financial items |
| **Instruction** | `instruction_id` | `physician_id` → Physician<br>`patient_id` → Patient<br>`payable_id` → Payable | Doctor orders with financial tracking |

### Junction Tables
| Table | Primary Key | Foreign Keys | Purpose |
|-------|------------|-------------|---------|
| **PatientRoomAssignment** | `assignment_id` | `patient_id` → Patient<br>`room_number` → Room | Room occupancy scheduling |
| **PatientMonitoring** | `monitoring_id` | `physician_id` → Physician<br>`patient_id` → Patient | Doctor-patient assignment tracking |
| **InstructionExecution** | `execution_id` | `nurse_id` → Nurse<br>`instruction_id` → Instruction | Nurse task completion records |

### Key Legend:
- 🔴 **Red**: Primary Key
- 🔵 **Blue**: Foreign Key
- → Indicates relationship direction

<img width="752" height="353" alt="Screenshot 2025-08-05 at 4 34 33 PM" src="https://github.com/user-attachments/assets/58449f3b-26ae-4295-84f4-3bbe55af0223" />


# Database Views Documentation


  ## 1. Patient Health Summary View

```sql
CREATE VIEW Patient_Health_summary AS
SELECT 
    Patient.name, 
    diseases, 
    diagnosis_date, 
    status, 
    description
FROM Patient 
JOIN HealthRecord 
    ON Patient.patient_id = HealthRecord.patient_id;
```
Description: Combines patient name with their health conditions, status, and diagnosis details.
Discussion: Summarizes health conditions in a readable format for dashboards or reports. It enables quick access to health trends and ongoing cases. 

  ## 2. Nurse Instruction Tracking View

```sql
CREATE VIEW Nurse_Instructions AS 
SELECT 
    Nurse.name AS nurse_name,
    Instruction.instruction_id,
    InstructionExecution.status,
    InstructionExecution.execution_record,
    Instruction.description AS instruction_details
FROM Nurse
JOIN InstructionExecution 
    ON Nurse.nurse_id = InstructionExecution.nurse_id
JOIN Instruction 
    ON InstructionExecution.instruction_id = Instruction.instruction_id;
```
Description: Display each nurse’s involvement in executing physician instructions, including status and execution records. 
Discussion: The reason why this is useful is that it can help evaluate the nursing staff and ensure compliance with physician orders. Also useful for audits or follow-ups.


  ## 3. Medication Administration Log

```sql
CREATE VIEW Medication_Administered AS
SELECT 
    Nurse.name AS administering_nurse,
    Medication.type AS medication_name,
    Medication.amount AS dosage,
    Patient.name AS patient_name,
    Patient.patient_id,
    Medication.date AS administration_time,
    Medication.medication_id AS record_id
FROM Medication
JOIN Nurse 
    ON Medication.nurse_id = Nurse.nurse_id
JOIN Patient 
    ON Medication.patient_id = Patient.patient_id;
```
Description: Lists which nurse administered what medication to which patient, including dates.
Discussion: The reason why this is useful is that it facilitates medication tracking, improving patient safety and ensuring proper billing and inventory control.


  ## Database Triggers

### 1. Default Room Fee Trigger

```sql
DELIMITER //
CREATE TRIGGER default_room_fee
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    IF NEW.nightly_fee IS NULL THEN
        SET NEW.nightly_fee = 800.00;
    END IF;
END;
//
DELIMITER ;
```
Description: Sets a default nightly fee of $800 if none is provided when inserting a new room.
Discussion: The reason why this trigger is useful is because it prevents incomplete data entry and enforces business rules by assigning a value for pricing. 

## 2. Room Availability Verification Trigger

```sql
DELIMITER //
CREATE TRIGGER verify_room_availability
BEFORE INSERT ON PatientRoomAssignment
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * 
        FROM PatientRoomAssignment
        WHERE room_number = NEW.room_number 
          AND NEW.check_in <= check_out 
          AND NEW.check_out >= check_in
    ) THEN
        -- Auto-assign next available room
        SET NEW.room_number = (SELECT MAX(room_number) + 1 FROM Room);
        
        -- Create new room with default capacity and rate
        INSERT INTO Room VALUES (NEW.room_number, 2, 500.00);
    END IF;
END;
//
DELIMITER ;
```
Description: Automatically assigns a new room if the specified room is unavailable for the requested dates, and adds it to the room table. 
Discussion: The reason why this trigger is useful is that it ensures no room is double-booked and expands room inventory when needed, which enhances data integrity and availability. 

## 3. Instruction Execution Status Trigger

```sql
DELIMITER //
CREATE TRIGGER update_instructionExecution
BEFORE UPDATE ON InstructionExecution
FOR EACH ROW
BEGIN
    IF NEW.execution_record = 'Done' THEN
        SET NEW.status = 'Completed';
        SET NEW.completion_time = NOW();  -- Added timestamp tracking
    END IF;
END;
//
DELIMITER ;
```
Description: If the execution_record is set to ‘Done’, the status is automatically marked as ‘Completed’.
Discussion: The reason why this trigger is useful is that it automates status tracking and reduces human error by syncing execution records and statuses.


## Database Queries Documentation

### Query 1: Patient Lookup by ID

**Description**:  
Retrieves the full name of a patient using their unique patient identifier.

**SQL Query**:
```sql
SELECT 
    name AS patient_name
FROM 
    patient 
WHERE 
    patient_id = 1;
```
<img width="196" height="85" alt="Screenshot 2025-08-05 at 3 48 29 PM" src="https://github.com/user-attachments/assets/27397457-46ff-4e30-b665-19b92a24062f" />

## Query 2: Patient Lookup by Phone Number

**Description**:  
Locates a patient record using their registered phone number for appointment management and communication purposes.

**SQL Query**:
```sql
SELECT 
    name AS patient_name,
    patient_id,
    address
FROM 
    patient
WHERE 
    phone_number = '312-555-1234';
```

<img width="151" height="97" alt="Screenshot 2025-08-05 at 3 50 09 PM" src="https://github.com/user-attachments/assets/afb7de3e-60d7-452f-bf27-9fac9f7e6bf6" />


## Query 3: Comprehensive Patient Health Record Retrieval

**Description**:  
Retrieves complete medical history, including diagnoses and treatment details, for a specified patient.

**SQL Query**:
```sql
SELECT 
    p.name AS patient_name,
    hr.diseases,
    hr.diagnosis_date,
    hr.status,
    hr.description AS treatment_notes,
    DATEDIFF(CURRENT_DATE, hr.diagnosis_date) AS days_since_diagnosis
FROM 
    patient p
JOIN 
    HealthRecord hr ON p.patient_id = hr.patient_id
WHERE 
    p.patient_id = 2
ORDER BY 
    hr.diagnosis_date DESC;
```
<img width="625" height="66" alt="Screenshot 2025-08-05 at 3 54 49 PM" src="https://github.com/user-attachments/assets/9f8dcec3-0010-42d6-9b67-d9633d0e72cc" />

## Query 4: Completed Instruction Execution Report

**Description**:  
Retrieves all successfully completed medical instructions with execution details.

**SQL Query**:
```sql
SELECT * FROM InstructionExecution WHERE status = 'Completed';
```
<img width="629" height="157" alt="Screenshot 2025-08-05 at 4 00 05 PM" src="https://github.com/user-attachments/assets/702e5dff-43d5-4315-a6c0-794f6ba6f25d" />

## Query 5: Patients with Ongoing Health Conditions

**Description**:  
Lists all patients currently being treated for ongoing medical conditions, sorted in reverse alphabetical order for priority review.

**SQL Query**:
```sql
SELECT name 
FROM patient 
JOIN HealthRecord ON patient.patient_id = healthRecord.patient_id 
WHERE status = 'Ongoing' 
ORDER BY patient.name DESC;
```
<img width="204" height="149" alt="Screenshot 2025-08-05 at 4 02 44 PM" src="https://github.com/user-attachments/assets/3831d1f4-2054-46d3-858b-d197953c9ec3" />

## Query 6: Nurse-Patient Instruction Execution Audit

**Description**:  
Tracks the complete chain of medical instruction execution, linking nurses to specific patients and their physician orders.

**SQL Query**:
```sql
SELECT 
    Nurse.nurse_id, 
    Nurse.name AS Nurse, 
    Patient.name AS Patient, 
    description
FROM Nurse 
JOIN InstructionExecution ON Nurse.nurse_id = InstructionExecution.nurse_id 
JOIN Instruction ON InstructionExecution.instruction_id = Instruction.instruction_id 
JOIN Patient ON Instruction.patient_id = Patient.patient_id;
```
<img width="625" height="152" alt="Screenshot 2025-08-05 at 4 07 13 PM" src="https://github.com/user-attachments/assets/5d980b12-a76f-48a6-b851-0b548c8c3118" />

## Query 7: Total Payments Summary

**Description**:  
Calculates the aggregate sum of all patient payments received by the healthcare facility.

**SQL Query**:
```sql
SELECT SUM(amount) FROM payment;
```
<img width="168" height="72" alt="Screenshot 2025-08-05 at 4 08 23 PM" src="https://github.com/user-attachments/assets/4dc23713-0481-4854-b29f-a337549625f5" />

## Query 8: Medication Dosage Analysis

**Description**:  
Calculates the average dosage amount across all administered medications, rounded to two decimal places for precise clinical reporting.

**SQL Query**:
```sql
SELECT ROUND(AVG(amount), 2) FROM Medication;
```
<img width="233" height="88" alt="Screenshot 2025-08-05 at 4 10 32 PM" src="https://github.com/user-attachments/assets/0009e6d0-9a4c-4d28-ace1-a77bd8b6a4c8" />

## Query 9: Surgical Patient-Physician Assignment Report

**Description**:  
Retrieves a comprehensive list of surgical patients with their assigned physicians and corresponding monitoring periods for surgical care coordination.

**SQL Query**:
```sql
SELECT 
    Patient.name AS patient_name,
    Physician.name AS surgeon,
    PatientMonitoring.start_date,
    PatientMonitoring.end_date
FROM Patient 
JOIN PatientMonitoring ON Patient.patient_id = PatientMonitoring.patient_id
JOIN Physician ON PatientMonitoring.physician_id = Physician.physician_id
WHERE field = "Surgery";
```
<img width="479" height="85" alt="Screenshot 2025-08-05 at 4 12 11 PM" src="https://github.com/user-attachments/assets/393e2361-3268-4b9d-adac-d893af1c60f0" />

## Query 10: Daily Room Occupancy Report

**Description**:  
Displays all patients occupying rooms on a specified date with detailed room information for capacity management and billing purposes.

**SQL Query**:
```sql
SELECT DISTINCT 
    Patient.name AS patient_name,
    room.capacity,
    room.nightly_fee
FROM Patient 
JOIN PatientRoomAssignment ON PatientRoomAssignment.patient_id = patient.patient_id 
JOIN Room ON PatientRoomAssignment.room_number = Room.room_number 
WHERE check_in = '2025-06-03';
```
<img width="392" height="88" alt="Screenshot 2025-08-05 at 4 14 41 PM" src="https://github.com/user-attachments/assets/d389cfbe-b30d-4255-acfc-73fc89677fb7" />

## Query 11: Mid-Range Billing Analysis

**Description**:  
Identifies patients with outstanding balances between $350 and $450, sorted in reverse alphabetical order for accounts receivable prioritization.

**SQL Query**:
```sql
SELECT 
    Patient.name AS patient_name
FROM patient 
JOIN Invoice ON patient.patient_id = Invoice.patient_id 
JOIN Payable ON Invoice.invoice_id = Payable.invoice_id 
WHERE amount >= 350.00 AND amount <= 450.00 
ORDER BY Patient.name DESC;
```
<img width="214" height="128" alt="Screenshot 2025-08-05 at 4 17 01 PM" src="https://github.com/user-attachments/assets/61b19392-42d0-4630-bcd1-32dc915b264b" />

## Query 12: High-Balance Patient Identification

**Description**:  
Identifies patients with the highest outstanding balances in the system for prioritized financial follow-up and exceptional case management.

**SQL Query**:
```sql
SELECT 
    Patient.name AS patient_name,
    Payable.amount AS outstanding_balance
FROM Patient 
JOIN Invoice ON patient.patient_id = Invoice.patient_id 
JOIN Payable ON Invoice.invoice_id = Payable.invoice_id 
WHERE Payable.amount IN (
    SELECT MAX(Payable.amount) 
    FROM Payable 
    JOIN Invoice ON Payable.invoice_id = Invoice.invoice_id 
    JOIN Patient ON Invoice.patient_id = Patient.patient_id
);
```
<img width="259" height="98" alt="Screenshot 2025-08-05 at 4 18 00 PM" src="https://github.com/user-attachments/assets/6952392c-dc5f-4697-8016-c03b59639f24" />

## Query 13: High-Dosage Medication Patients

**Description**:  
Identifies patients who have received at least one medication dosage exceeding 8.00 units, flagging potential high-risk medication cases for clinical review.

**SQL Query**:
```sql
SELECT 
    Patient.name AS patient_name,
    Medication.type AS medication_type
FROM Medication
JOIN Patient ON Medication.patient_id = Patient.patient_id
WHERE EXISTS (
    SELECT * 
    FROM Medication M2 
    WHERE M2.patient_id = Medication.patient_id 
    AND amount > 8.00
);
```
<img width="278" height="145" alt="Screenshot 2025-08-05 at 4 19 10 PM" src="https://github.com/user-attachments/assets/8affb6a5-85f3-44d6-b3e9-da1bba1c6d7b" />

## Query 14: Standard-Dosage Patient Report

**Description**:  
Identifies patients whose medication regimen contains only dosages at or below 8.00 units, indicating standard therapeutic ranges.

**SQL Query**:
```sql
SELECT 
    Patient.name AS patient_name,
    Medication.type AS medication_type
FROM Medication
JOIN Patient ON Medication.patient_id = Patient.patient_id
WHERE NOT EXISTS (
    SELECT * 
    FROM Medication M2 
    WHERE M2.patient_id = Medication.patient_id 
    AND amount > 8.00
);
```
<img width="236" height="95" alt="Screenshot 2025-08-05 at 4 20 16 PM" src="https://github.com/user-attachments/assets/e862ddc6-800e-489c-ac03-b2aec53acac2" />

## Query 15: Critical High-Dosage Patient Identification

**Description**:  
Flags patients who have received any medication dosages exceeding 15.00 units, triggering immediate clinical review for potential safety interventions.

**SQL Query**:
```sql
SELECT name 
FROM Patient 
WHERE patient_id IN (
    SELECT Patient_id  
    FROM Medication 
    WHERE amount > 15.00
);
```
<img width="169" height="84" alt="Screenshot 2025-08-05 at 4 21 49 PM" src="https://github.com/user-attachments/assets/31480ab9-1487-475d-86ff-0c58a96f422c" />

## Query 16: Above-Average Medication Dosage Report

**Description**:  
Identifies patients who received medication dosages exceeding the system-wide average, highlighting potential outliers for clinical review.

**SQL Query**:
```sql
SELECT name 
FROM Patient 
JOIN Medication ON Patient.patient_id = Medication.patient_id 
WHERE Medication.amount > (
    SELECT AVG(amount) 
    FROM Medication
);
```
<img width="175" height="89" alt="Screenshot 2025-08-05 at 4 22 55 PM" src="https://github.com/user-attachments/assets/bcb059c6-932e-4858-8e1c-455f3b7b2f95" />

## Query 17: Active Treatment Case Census

**Description**:  
Calculates the total number of active patient cases currently marked with 'Ongoing' status in the health record system for clinical workload management.

**SQL Query**:
```sql
SELECT COUNT(*) AS Ongoing 
FROM HealthRecord 
WHERE status = 'Ongoing';
```
<img width="131" height="75" alt="Screenshot 2025-08-05 at 4 23 58 PM" src="https://github.com/user-attachments/assets/27363b61-7ab0-4b61-ac4f-2fe8bcd95086" />

## Database Transactions

### Transaction 1: Complete Patient Admission

**Description**:  
Atomic operation for admitting a new patient with room assignment and initial health record creation.

**Transaction Body**:
```sql
START TRANSACTION;
-- Patient registration
INSERT INTO Patient VALUES (6, 'Gonzalo Smith', '350 E Cermak, Chicago, IL', '773-123-4321');

-- Room assignment
INSERT INTO PatientRoomAssignment VALUES (10008, 6, 101, '2025-07-31', '2025-08-05');

-- Initial health assessment
INSERT INTO HealthRecord VALUES (1006, 6, 'High Cholesterol', '2025-07-31', 'Ongoing', 'Lifestyle changes and medication');
COMMIT;
```
Description: Insert a new patient, their room assignment, and health record, all in one operation.
Discussion: The reason why this transaction is useful is that it ensures consistency, either all patient admission data is added, or none is, preventing partial/incomplete entries. 

### Transaction 2: Patient Billing Package Creation

**Description**:  
An atomic financial operation creates an invoice with associated payable items for patient services.

**Transaction Body**:
```sql
START TRANSACTION;
-- Invoice generation
INSERT INTO Invoice VALUES (
    7006,               -- invoice_id
    '2025-07-31',       -- issue_date
    '2025-07-27',       -- start_date
    '2025-07-30',       -- end_date
    'CHI7006',          -- account_number
    6                   -- patient_id
);

-- Line item creation
INSERT INTO Payable VALUES (
    8006,               -- payable_id
    1050.00,            -- amount
    '2025-07-31',       -- date
    'Room 101 $350x3',  -- description
    7006                -- invoice_id
);
COMMIT;
```
Description: Insert a new invoice and its corresponding payable item together.
Discussion: The reason why this transaction is useful is that it keeps financial records consistent and avoids mismatches between invoice entries and their associated charges.

