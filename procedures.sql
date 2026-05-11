DELIMITER $$

CREATE PROCEDURE AddAppointment(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_date DATE,
    IN p_time TIME
)
BEGIN
    INSERT INTO APPOINTMENT(patient_id, doctor_id, appointment_date, appointment_time, status)
    VALUES (p_patient_id, p_doctor_id, p_date, p_time, 'Scheduled');
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetPatientAppointments(IN p_id INT)
BEGIN
    SELECT 
        a.appointment_id,
        d.name AS doctor_name,
        a.appointment_date,
        a.appointment_time,
        a.status
    FROM APPOINTMENT a
    JOIN DOCTOR d ON a.doctor_id = d.doctor_id
    WHERE a.patient_id = p_id;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE UpdateAppointmentStatus(
    IN p_app_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE APPOINTMENT
    SET status = p_status
    WHERE appointment_id = p_app_id;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE DeleteAppointment(IN p_app_id INT)
BEGIN
    DELETE FROM APPOINTMENT
    WHERE appointment_id = p_app_id;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetDoctorSchedule(IN d_id INT)
BEGIN
    SELECT 
        p.name AS patient_name,
        a.appointment_date,
        a.appointment_time,
        a.status
    FROM APPOINTMENT a
    JOIN PATIENT p ON a.patient_id = p.patient_id
    WHERE a.doctor_id = d_id
    ORDER BY a.appointment_date;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE CheckDoctorAvailability(
    IN d_id INT,
    IN p_date DATE,
    IN p_time TIME
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM APPOINTMENT
        WHERE doctor_id = d_id
        AND appointment_date = p_date
        AND appointment_time = p_time
    ) THEN
        SELECT 'Doctor is NOT available' AS message;
    ELSE
        SELECT 'Doctor is available' AS message;
    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE CountPatientAppointments(IN p_id INT)
BEGIN
    SELECT COUNT(*) AS total_appointments
    FROM APPOINTMENT
    WHERE patient_id = p_id;
END $$

DELIMITER ;