CREATE database healthcare;
use healthcare;
--------------------
CREATE TABLE Patients (
patient_id INT PRIMARY KEY,
patient_name VARCHAR(50),
age INT,
gender VARCHAR(10),
city VARCHAR(50)
);
CREATE TABLE Symptoms (
symptom_id INT PRIMARY KEY,
symptom_name VARCHAR(50)
);
CREATE TABLE Diagnoses (
diagnosis_id INT PRIMARY KEY,
diagnosis_name VARCHAR(50)
);
CREATE TABLE Visits (
visit_id INT PRIMARY KEY,
patient_id INT,
symptom_id INT,
diagnosis_id INT,
visit_date DATE,
FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
FOREIGN KEY (symptom_id) REFERENCES Symptoms(symptom_id),
FOREIGN KEY (diagnosis_id) REFERENCES Diagnoses(diagnosis_id)
);
-- Insert data into Patients table
INSERT INTO Patients (patient_id, patient_name, age, gender, city)
VALUES
(1, 'John Smith', 45, 'Male', 'Seattle'),
(2, 'Jane Doe', 32, 'Female', 'Miami'),
(3, 'Mike Johnson', 50, 'Male', 'Seattle'),
(4, 'Lisa Jones', 28, 'Female', 'Miami'),
(5, 'David Kim', 60, 'Male', 'Chicago');
-- Insert data into Symptoms table
INSERT INTO Symptoms (symptom_id, symptom_name)
VALUES
(1, 'Fever'),
(2, 'Cough'),
(3, 'Difficulty Breathing'),
(4, 'Fatigue'),
(5, 'Headache');
-- Insert data into Diagnoses table
INSERT INTO Diagnoses (diagnosis_id, diagnosis_name)
VALUES
(1, 'Common Cold'),
(2, 'Influenza'),
(3, 'Pneumonia'),
(4, 'Bronchitis'),
(5, 'COVID-19');
-- Insert data into Visits table
INSERT INTO Visits (visit_id, patient_id, symptom_id, diagnosis_id, visit_date)
VALUES
(1, 1, 1, 2, '2022-01-01'),
(2, 2, 2, 1, '2022-01-02'),
(3, 3, 3, 3, '2022-01-02'),
(4, 4, 1, 4, '2022-01-03'),
(5, 5, 2, 5, '2022-01-03'),
(6, 1, 4, 1, '2022-05-13'),
(7, 3, 4, 1, '2022-05-20'),
(8, 3, 2, 1, '2022-05-20'),
(9, 2, 1, 4, '2022-08-19'),
(10, 1, 2, 5, '2022-12-01');
--------------------

-- Questions

-- 1. Write a SQL query to retrieve all patients who have been diagnosed with COVID-19
SELECT
	patient_name
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
WHERE diagnosis_id = (SELECT diagnosis_id FROM diagnoses WHERE diagnosis_name = "COVID-19");


-- 2. Write a SQL query to retrieve the number of visits made by each patient, ordered by the number of visits in descending order.
SELECT
	patient_name,
    COUNT(visit_id) AS no_of_visits
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
GROUP BY patient_name
ORDER BY COUNT(visit_id) DESC;


-- 3. Write a SQL query to calculate the average age of patients who have been diagnosed with Pneumonia.
SELECT
	AVG(age)
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
WHERE diagnosis_id = (SELECT diagnosis_id FROM diagnoses WHERE diagnosis_name = "Pneumonia");


-- 4. Write a SQL query to retrieve the top 3 most common symptoms among all visits.
SELECT
	symptom_name
FROM visits v
JOIN symptoms s
	ON v.symptom_id = s.symptom_id
GROUP BY symptom_name
ORDER BY COUNT(v.symptom_id) DESC
LIMIT 3;


-- 5. Write a SQL query to retrieve the patient who has the highest number of different symptoms reported.
WITH cte AS(
SELECT
    patient_name,
    COUNT(DISTINCT symptom_id),
    RANK() OVER(ORDER BY COUNT(DISTINCT symptom_id) DESC) AS rankk
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
GROUP BY patient_name)
SELECT patient_name
FROM cte
WHERE rankk = 1;


-- 6. Write a SQL query to calculate the percentage of patients who have been diagnosed with COVID-19 out of the total number of patients.
SELECT
	COUNT( DISTINCT CASE WHEN diagnosis_id = (SELECT diagnosis_id FROM diagnoses WHERE diagnosis_name = "COVID-19") THEN patient_id END ) AS covid_patients,
    COUNT( DISTINCT patient_id ) AS total_patients,
    ROUND((COUNT( DISTINCT CASE WHEN diagnosis_id = (SELECT diagnosis_id FROM diagnoses WHERE diagnosis_name = "COVID-19") THEN patient_id END )/COUNT( DISTINCT patient_id ))*100,2) AS pct_covid_patients
FROM visits;


-- 7. Write a SQL query to retrieve the count of visits in each city.
SELECT
	city,
    COUNT(visit_id)
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
GROUP BY city
ORDER BY COUNT(visit_id) DESC;


-- 8. Write a SQL query to find the patient who has the highest number of visits in a single day, along with the corresponding visit date.
WITH cte AS (
SELECT
    patient_name,
    visit_date,
    COUNT(visit_id),
    RANK() OVER(ORDER BY COUNT(visit_id) DESC) AS rankk
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
GROUP BY v.patient_id, visit_date)
SELECT 
	patient_name,
    visit_date
FROM cte
WHERE rankk = 1;


-- 9. Write a SQL query to retrieve the average age of patients for each diagnosis, ordered by the average age in descending order.
SELECT
	diagnosis_name,
    AVG(age)
FROM visits v
JOIN patients p
	ON v.patient_id = p.patient_id
JOIN diagnoses d
	ON v.diagnosis_id = d.diagnosis_id
GROUP BY diagnosis_name
ORDER BY AVG(age) DESC;


-- 10. Write a SQL query to calculate the cumulative count of visits over time, ordered by the visit date.
WITH cte AS(
SELECT
	visit_date,
    COUNT(visit_id) AS total_visits
FROM visits
GROUP BY visit_date
ORDER BY visit_date)
SELECT 
	*,
    SUM(total_visits) OVER (ORDER BY visit_date) AS cumulative_sum
FROM cte;










