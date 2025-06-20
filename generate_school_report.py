import mysql.connector
from fpdf import FPDF
import os
from datetime import datetime
import getpass

# Database connection settings
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': getpass.getpass('Enter your MySQL password: '),
    'database': 'SchoolSystem'
}

# Find user's Downloads folder
downloads_folder = os.path.join(os.path.expanduser("~"), "Downloads")

# Setup PDF class with table formatting
class PDF(FPDF):
    def header(self):
        self.set_font('Arial', 'B', 16)
        self.cell(0, 10, 'School System Automated Report', ln=True, align='C')
        self.ln(5)

    def footer(self):
        self.set_y(-15)
        self.set_font('Arial', 'I', 8)
        self.cell(0, 10, f'Page {self.page_no()}', align='C')

    def chapter_title(self, title):
        self.set_font('Arial', 'B', 14)
        self.cell(0, 10, title, ln=True)
        self.ln(2)

    def table_header(self, headers, col_widths):
        self.set_font('Arial', 'B', 12)
        for i in range(len(headers)):
            self.cell(col_widths[i], 10, headers[i], 1, 0, 'C')
        self.ln()

    def table_row(self, row, col_widths):
        self.set_font('Arial', '', 12)
        for i in range(len(row)):
            self.cell(col_widths[i], 10, str(row[i]), 1, 0, 'C')
        self.ln()

# Main report generation function
def generate_report():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        pdf = PDF()
        pdf.add_page()

        ## Section 1: Fee Collection by Campus
        pdf.chapter_title('Fee Collection by Campus')

        cursor.execute('''
            SELECT c.CampusName, SUM(sp.Amount) AS TotalFeesCollected
            FROM Students s
            JOIN SchoolRecords sr ON s.StudentID = sr.StudentID
            JOIN Campuses c ON sr.CampusID = c.CampusID
            JOIN StudentPayments sp ON s.StudentID = sp.StudentID
            GROUP BY c.CampusName;
        ''')
        results = cursor.fetchall()

        if results:
            headers = ['Campus Name', 'Total Fees Collected']
            col_widths = [90, 90]
            pdf.table_header(headers, col_widths)
            for row in results:
                campus, total = row
                pdf.table_row([campus, f"${total:.2f}"], col_widths)
        else:
            pdf.cell(0, 10, "No fee collection data available.", ln=True)

        pdf.ln(10)

        ## Section 2: Student Performance (Low Grades)
        pdf.chapter_title('Students with Low Average Grades')

        cursor.execute('''
            SELECT s.StudentName, ROUND(AVG(g.Grade), 2) AS AverageGrade
            FROM Students s
            JOIN GradeReports g ON s.StudentID = g.StudentID
            GROUP BY s.StudentID, s.StudentName
            HAVING AVG(g.Grade) < 65;
        ''')
        results = cursor.fetchall()

        if results:
            headers = ['Student Name', 'Average Grade']
            col_widths = [100, 80]
            pdf.table_header(headers, col_widths)
            for row in results:
                student, avg_grade = row
                pdf.table_row([student, f"{avg_grade}%",], col_widths)
        else:
            pdf.cell(0, 10, "No students below grade threshold.", ln=True)

        pdf.ln(10)

        ## Section 3: Poor Attendance (Absences)
        pdf.chapter_title('Staff with Poor Attendance')

        cursor.execute('''
            SELECT s.StaffName, COUNT(*) AS Absences
            FROM Staff s
            JOIN AttendanceRecords a ON s.StaffID = a.StaffID
            WHERE a.AttendanceStatus = 'Absent'
            AND a.AttendanceDate >= DATE_SUB('2025-01-31', INTERVAL 30 DAY)
            GROUP BY s.StaffID, s.StaffName
            HAVING COUNT(*) > 2;
        ''')
        results = cursor.fetchall()

        if results:
            headers = ['Student Name', 'Absences (30 Days)']
            col_widths = [100, 80]
            pdf.table_header(headers, col_widths)
            for row in results:
                student, absences = row
                pdf.table_row([student, absences], col_widths)
        else:
            pdf.cell(0, 10, "No poor attendance detected.", ln=True)

        pdf.ln(10)

        ## Section 4: Budget vs Expenses Report
        pdf.chapter_title('Campus Budget vs Expenses Report')

        cursor.execute('''
            SELECT
                c.CampusName,
                c.MonthlyBudget,
                IFNULL(SUM(e.Amount), 0) AS TotalExpenses,
                (c.MonthlyBudget - IFNULL(SUM(e.Amount), 0)) AS RemainingBudget
            FROM
                Campuses c
            LEFT JOIN
                CampusExpenses e ON c.CampusID = e.CampusID
            AND MONTH(e.ExpenseDate) = MONTH(CURRENT_DATE())
            GROUP BY
                c.CampusID;
        ''')
        results = cursor.fetchall()

        if results:
            headers = ['Campus Name', 'Monthly Budget', 'Total Expenses', 'Remaining Budget']
            col_widths = [60, 45, 45, 45]
            pdf.table_header(headers, col_widths)
            for row in results:
                campus, monthly, expenses, remaining = row
                pdf.table_row([campus, f"${monthly:.2f}", f"${expenses:.2f}", f"${remaining:.2f}"], col_widths)
        else:
            pdf.cell(0, 10, "No budget/expense data available.", ln=True)

        pdf.ln(10)

        ## Section 5: Recent School Events
        pdf.chapter_title('Recent or Upcoming School Events')

        cursor.execute('''
            SELECT e.EventName, e.EventDate, e.EventTime, et.EventTypeName
            FROM SchoolEvents e
            JOIN EventTypes et ON e.EventTypeID = et.EventTypeID
            WHERE e.EventDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            ORDER BY e.EventDate;
        ''')
        results = cursor.fetchall()

        if results:
            headers = ['Event Name', 'Date', 'Time', 'Type']
            col_widths = [60, 40, 30, 60]
            pdf.table_header(headers, col_widths)
            for row in results:
                event_name, event_date, event_time, event_type = row
                pdf.table_row([event_name, event_date, event_time, event_type], col_widths)
        else:
            pdf.cell(0, 10, "No recent/upcoming events found.", ln=True)

        pdf.ln(10)

        ## Section 6: Facility Maintenance Summary
        pdf.chapter_title('Facility Maintenance Activities')

        cursor.execute('''
            SELECT f.FacilityName, m.MaintenanceDate, m.MaintenanceCost
            FROM FacilityMaintenance m
            JOIN Facilities f ON m.FacilityID = f.FacilityID
            WHERE m.MaintenanceDate >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
            ORDER BY m.MaintenanceDate DESC;
        ''')
        results = cursor.fetchall()

        if results:
            headers = ['Facility Name', 'Maintenance Date', 'Cost']
            col_widths = [80, 60, 50]
            pdf.table_header(headers, col_widths)
            for row in results:
                facility, date, cost = row
                pdf.table_row([facility, date, f"${cost:.2f}"], col_widths)
        else:
            pdf.cell(0, 10, "No maintenance records in last 90 days.", ln=True)

        ## Save PDF to Downloads
        now = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"School_Report_{now}.pdf"
        filepath = os.path.join(downloads_folder, filename)

        pdf.output(filepath)

        print(f"✅ Report generated successfully: {filepath}")

        cursor.close()
        conn.close()

    except mysql.connector.Error as err:
        print(f"❌ Database Error: {err}")
    except Exception as e:
        print(f"❌ General Error: {e}")

# Run the report generation
if __name__ == "__main__":
    generate_report()
