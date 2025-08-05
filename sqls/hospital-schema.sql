-- Author: Marco A. Tinoco Sosa
DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE Patient (
  patient_id INT PRIMARY KEY,
  name VARCHAR(100),
  address VARCHAR(200),
  phone_number VARCHAR(20)
);

CREATE TABLE Physician (
  physician_id INT PRIMARY KEY,
  name VARCHAR(100),
  certification_number VARCHAR(50),
  field VARCHAR(100),
  address VARCHAR(200),
  phone_number VARCHAR(20)
);

CREATE TABLE Nurse (
  nurse_id INT PRIMARY KEY,
  name VARCHAR(100),
  certification_number VARCHAR(50),
  address VARCHAR(200),
  phone_number VARCHAR(20)
);

CREATE TABLE Room (
  room_number INT PRIMARY KEY,
  capacity INT,
  nightly_fee DECIMAL(10,2)
);

CREATE TABLE HealthRecord (
  record_id INT PRIMARY KEY,
  patient_id INT,
  diseases VARCHAR(200),
  diagnosis_date DATE,
  status VARCHAR(50),
  description TEXT,
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Invoice (
  invoice_id INT PRIMARY KEY,
  issue_date DATE,
  start_date DATE,
  end_date DATE,
  account_number VARCHAR(50),
  patient_id INT,
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Payable (
  payable_id INT PRIMARY KEY,
  amount DECIMAL(10,2),
  date DATE,
  description TEXT,
  invoice_id INT,
  FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

CREATE TABLE Payment (
  payment_id INT PRIMARY KEY,
  patient_id INT,
  amount DECIMAL(10,2),
  date DATE,
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Instruction (
  instruction_id INT PRIMARY KEY,
  physician_id INT,
  patient_id INT,
  description TEXT,
  fee DECIMAL(10,2),
  payable_id INT,
  FOREIGN KEY (physician_id) REFERENCES Physician(physician_id),
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
  FOREIGN KEY (payable_id) REFERENCES Payable(payable_id)
);

CREATE TABLE Medication (
  medication_id INT PRIMARY KEY,
  nurse_id INT,
  patient_id INT,
  type VARCHAR(100),
  amount DECIMAL(10,2),
  date DATE,
  payable_id INT,
  FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id),
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
  FOREIGN KEY (payable_id) REFERENCES Payable(payable_id)
);

CREATE TABLE PatientRoomAssignment (
  assignment_id INT PRIMARY KEY,
  patient_id INT,
  room_number INT,
  check_in DATE,
  check_out DATE,
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
  FOREIGN KEY (room_number) REFERENCES Room(room_number)
);

CREATE TABLE PatientMonitoring (  
  monitoring_id INT PRIMARY KEY,  
  physician_id INT,  
  patient_id INT,  
  start_date DATE,  
  end_date DATE,  
  FOREIGN KEY (physician_id) REFERENCES Physician(physician_id),  
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)  
);  

CREATE TABLE InstructionExecution (  
  execution_id INT PRIMARY KEY,  
  nurse_id INT,  
  instruction_id INT,  
  status VARCHAR(50),  
  execution_record TEXT,  
  FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id),  
  FOREIGN KEY (instruction_id) REFERENCES Instruction(instruction_id)  
);