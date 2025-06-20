import mysql.connector
import bcrypt
import time
import getpass

# Make sure that bcrypt is installed. Use this to install it: pip install bcrypt mysql-connector-python

# Database connection settings
db_config = {
    'host': 'localhost',
    'user': 'root',              
    'password': getpass.getpass('Enter your MySQL password: '),
    'database': 'SchoolSystem'    
}

# Connect to the database
def connect_db():
    try:
        connection = mysql.connector.connect(**db_config)
        print("✅ Connected to MySQL database successfully.")
        return connection
    except mysql.connector.Error as err:
        print(f"❌ Database connection error: {err}")
        exit(1)

# Find users with unhashed (likely plain text) passwords
def find_unhashed_users(cursor):
    query = "select UserID, Username, UserPassword from Users where length(UserPassword) < 60;"
    cursor.execute(query)
    return cursor.fetchall()

# Hash a plain text password using bcrypt
def hash_password(plain_password):
    password_bytes = plain_password.encode('utf-8')
    hashed_password = bcrypt.hashpw(password_bytes, bcrypt.gensalt())
    return hashed_password.decode('utf-8')

# Update the UserPassword field with the bcrypt hash
def update_password(cursor, user_id, new_hashed_password):
    query = "update Users set UserPassword = %s where UserID = %s;"
    cursor.execute(query, (new_hashed_password, user_id))

# Main loop to keep checking for new users
def main():
    print("🚀 Starting automated bcrypt hasher... Press Ctrl+C to stop.")
    while True:
        conn = connect_db()
        cursor = conn.cursor(dictionary=True)

        users = find_unhashed_users(cursor)
        
        if users:
            for user in users:
                print(f"🔵 Hashing password for User: {user['Username']} (ID: {user['UserID']})")
                new_hash = hash_password(user['UserPassword'])
                update_password(cursor, user['UserID'], new_hash)

            conn.commit()
            print(f"✅ Successfully hashed and updated {len(users)} user(s).")
        else:
            print("✅ No new users found. All passwords are already secure.")

        cursor.close()
        conn.close()

        # Wait a bit before checking again
        time.sleep(10)  # check every 10 seconds
    
if __name__ == "__main__":
    main()
