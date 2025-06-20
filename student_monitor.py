import mysql.connector
import time
import tkinter
from tkinter import messagebox
import winsound
import getpass

# Database connection settings
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': getpass.getpass('Enter your MySQL password: '),
    'database': 'SchoolSystem'
}

# Initialize the tkinter root
root = tkinter.Tk()
root.withdraw()

root.attributes('-topmost', True)

already_alerted = set()

def beep_alert():
    # Windows standard beep
    winsound.MessageBeep(winsound.MB_ICONEXCLAMATION)

def check_student_alerts():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        ## 1. Check for Low Performance (Grade checker)
        cursor.execute('''
            SELECT s.StudentID, s.StudentName, ROUND(AVG(g.Grade), 2) AS AverageGrade
            FROM Students s
            JOIN GradeReports g ON s.StudentID = g.StudentID
            GROUP BY s.StudentID, s.StudentName
            HAVING AVG(g.Grade) < 65;
        ''')
        low_perf_students = cursor.fetchall()

        for student_id, student_name, avg_grade in low_perf_students:
            alert_key = f"grade_{student_id}"
            if alert_key not in already_alerted:
                beep_alert()
                messagebox.showwarning(
                    "Student Falling Behind!",
                    f"⚠️ {student_name} (Student ID: {student_id}) is falling behind.\nAverage Grade: {avg_grade}%",
		    parent=root
                )
                already_alerted.add(alert_key)

        ## 2. Check for Poor Attendance
        cursor.execute('''
            SELECT s.StudentID, s.StudentName, COUNT(*) AS Absences
            FROM Students s
            JOIN AttendanceRecords a ON s.StudentID = a.StudentID
            WHERE a.AttendanceStatus = 'Absent'
            AND a.AttendanceDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            GROUP BY s.StudentID, s.StudentName
            HAVING COUNT(*) > 3;
        ''')
        poor_attendance_students = cursor.fetchall()

        for student_id, student_name, absences in poor_attendance_students:
            alert_key = f"attendance_{student_id}"
            if alert_key not in already_alerted:
                beep_alert()
                messagebox.showwarning(
                    "Student Poor Attendance!",
                    f"⚠️ {student_name} (Student ID: {student_id}) has {absences} absences in the last 30 days.",
		    parent=root
                )
                already_alerted.add(alert_key)

        cursor.close()
        conn.close()

    except mysql.connector.Error as err:
        print(f"❌ Database Error: {err}")
    except Exception as e:
        print(f"❌ General Error: {e}")

def run_monitoring_loop():
    print("🚀 Real-time student alert monitor started...")
    while True:
        check_student_alerts()
        time.sleep(10)  # Sleep 10 seconds between checks

if __name__ == "__main__":
    run_monitoring_loop()
