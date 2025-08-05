-- Author: Marco A. Tinoco Sosa

INSERT INTO Patient VALUES
  (1, 'Aashika Lilaramani',      '123 W Adams St, Chicago, IL',    '312-555-1231'),
  (2, 'Alexis Pelaez Alvarez',      '456 N Michigan Ave, Chicago, IL', '312-555-1232'),
  (3, 'Marco Tinoco Sosa',         '789 S Wabash Ave, Chicago, IL',   '312-555-1233'),
  (4, 'Sarah Diaz',            '321 E Randolph St, Chicago, IL',  '312-555-1234'),
  (5, 'David de la O',       '654 N Clark St, Chicago, IL',     '312-555-1235');


INSERT INTO Physician VALUES
  (101, 'Dr. Robert Lopez',   'ILMD12345', 'Cardiology', '100 S Columbus Dr, Chicago, IL',    '312-555-1111'),
  (102, 'Dr. Jennifer Barajas',   'ILMD67890', 'Neurology',  '200 E Erie St, Chicago, IL',        '312-555-2222'),
  (103, 'Dr. William Torres',  'ILMD54321', 'Pediatrics', '300 W Madison St, Chicago, IL',     '312-555-3333'),
  (104, 'Dr. Lisa Garcia',    'ILMD98765', 'Oncology',   '400 N State St, Chicago, IL',       '312-555-4444'),
  (105, 'Dr. Thomas Guzman',  'ILMD13579', 'Surgery',    '500 S Franklin St, Chicago, IL',    '312-555-5555');


INSERT INTO Nurse VALUES
  (201, 'Nurse Emily Davis',  'ILRN1001', '101 N Wacker Dr, Chicago, IL',    '312-555-6666'),
  (202, 'Nurse Carlos Lopez', 'ILRN1002', '202 S Canal St, Chicago, IL',     '312-555-7777'),
  (203, 'Nurse Amy Lee',     'ILRN1003', '303 E Ohio St, Chicago, IL',      '312-555-8888'),
  (204, 'Nurse Daniel Pink', 'ILRN1004', '404 W Washington St, Chicago, IL','312-555-9999'),
  (205, 'Nurse Jessica White', 'ILRN1005', '505 N LaSalle St, Chicago, IL',   '312-555-0000');


INSERT INTO Room VALUES
  (101, 2, 350.00),  
  (102, 1, 450.00),
  (103, 3, 300.00),
  (104, 2, 400.00),
  (105, 1, 500.00);


INSERT INTO HealthRecord VALUES
  (1001, 1, 'Hypertension',  '2025-01-15', 'Ongoing',  'Prescribed beta-blockers, follow-up in 3 months'),
  (1002, 2, 'Diabetes Type 2', '2025-02-20', 'Resolved', 'Completed insulin therapy, maintaining with diet'),
  (1003, 3, 'Asthma',        '2025-03-10', 'Ongoing',  'Seasonal allergies exacerbating condition'),
  (1004, 4, 'Migraine',      '2025-04-05', 'Ongoing',  'Stress-related, referred to neurology'),
  (1005, 5, 'Fractured Arm', '2025-05-12', 'Resolved', 'Cast removed, physical therapy recommended');


INSERT INTO Instruction VALUES
  (5001, 101, 1, 'Monitor blood pressure twice daily', 75.00, NULL),
  (5002, 102, 2, 'Administer insulin shots before meals', 100.00, NULL),
  (5003, 103, 3, 'Check oxygen levels during asthma attacks', 85.00, NULL),
  (5004, 104, 4, 'Perform MRI scan at Rush University', 350.00, NULL),
  (5005, 105, 5, 'Physical therapy sessions at Northwestern', 120.00, NULL);


INSERT INTO Medication VALUES
  (6001, 201, 1, 'Lisinopril',   15.00, '2025-06-01', NULL),
  (6002, 202, 2, 'Insulin',      10.00, '2025-06-02', NULL),
  (6003, 203, 3, 'Albuterol',    12.00, '2025-06-03', NULL),
  (6004, 204, 4, 'Sumatriptan',  18.00, '2025-06-04', NULL),
  (6005, 205, 5, 'Ibuprofen',     8.00, '2025-06-05', NULL);


INSERT INTO Invoice VALUES
  (7001, '2025-06-10', '2025-06-01', '2025-06-10', 'CHI7001', 1),
  (7002, '2025-06-11', '2025-06-02', '2025-06-11', 'CHI7002', 2),
  (7003, '2025-06-12', '2025-06-03', '2025-06-12', 'CHI7003', 3),
  (7004, '2025-06-13', '2025-06-04', '2025-06-13', 'CHI7004', 4),
  (7005, '2025-06-14', '2025-06-05', '2025-06-14', 'CHI7005', 5);


INSERT INTO Payable VALUES
  (8001, 350.00, '2025-06-01', 'Private room at Chicago Medical Center (1 night)', 7001),
  (8002, 450.00, '2025-06-02', 'VIP suite at Chicago Medical Center (1 night)', 7002),
  (8003, 300.00, '2025-06-03', 'Semi-private room at Chicago Medical Center (1 night)', 7003),
  (8004, 400.00, '2025-06-04', 'Private room at Chicago Medical Center (1 night)', 7004),
  (8005, 500.00, '2025-06-05', 'VIP suite at Chicago Medical Center (1 night)', 7005);


INSERT INTO Payment VALUES
  (9001, 1, 350.00, '2025-06-11'),
  (9002, 2, 450.00, '2025-06-12'),
  (9003, 3, 300.00, '2025-06-13'),
  (9004, 4, 400.00, '2025-06-14'),
  (9005, 5, 500.00, '2025-06-15');


INSERT INTO PatientRoomAssignment VALUES
  (10001, 1, 101, '2025-06-01', '2025-06-02'),
  (10002, 2, 102, '2025-06-02', '2025-06-03'),
  (10003, 3, 103, '2025-06-03', '2025-06-04'),
  (10004, 4, 104, '2025-06-04', '2025-06-05'),
  (10005, 5, 105, '2025-06-05', '2025-06-06');


INSERT INTO PatientMonitoring VALUES
  (11001, 101, 1, '2025-06-01', '2025-06-10'),
  (11002, 102, 2, '2025-06-02', '2025-06-11'),
  (11003, 103, 3, '2025-06-03', '2025-06-12'),
  (11004, 104, 4, '2025-06-04', '2025-06-13'),
  (11005, 105, 5, '2025-06-05', '2025-06-14');


INSERT INTO InstructionExecution VALUES
  (12001, 201, 5001, 'Completed',   'BP recorded twice daily as ordered'),
  (12002, 202, 5002, 'Completed',   'Insulin administered before each meal'),
  (12003, 203, 5003, 'Pending',     'Patient experiencing unstable oxygen levels'),
  (12004, 204, 5004, 'Completed',   'MRI completed at Rush, results normal'),
  (12005, 205, 5005, 'In Progress','Therapy ongoing at Northwestern facility');


UPDATE Medication SET payable_id = 8001 WHERE medication_id = 6001;
UPDATE Medication SET payable_id = 8002 WHERE medication_id = 6002;
UPDATE Medication SET payable_id = 8003 WHERE medication_id = 6003;
UPDATE Medication SET payable_id = 8004 WHERE medication_id = 6004;
UPDATE Medication SET payable_id = 8005 WHERE medication_id = 6005;


UPDATE Instruction SET payable_id = 8001 WHERE instruction_id = 5001;
UPDATE Instruction SET payable_id = 8002 WHERE instruction_id = 5002;
UPDATE Instruction SET payable_id = 8003 WHERE instruction_id = 5003;
UPDATE Instruction SET payable_id = 8004 WHERE instruction_id = 5004;
UPDATE Instruction SET payable_id = 8005 WHERE instruction_id = 5005;