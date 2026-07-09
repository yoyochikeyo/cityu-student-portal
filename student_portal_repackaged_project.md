# Student Portal Mobile App - Repackaged Project Proposal

## 1. App Idea

**App Name:** Student Portal Mobile App

**Problem Solved:**  
Students often need to check class schedules, attendance, fees, exam information, learning materials, and campus services from different places. This app combines the most important student services into one mobile application so students can manage their academic life more easily.

**Target Users:**  
University or college students.

**Main Goal:**  
To provide a clean mobile student portal where students can log in, view academic information, manage finance records, submit applications, and access campus support features.

## 2. Development Tools

- **Frontend / Mobile Framework:** Flutter
- **Programming Language:** Dart
- **IDE:** Android Studio or VS Code
- **Database:** SQLite using `sqflite`
- **Local Storage:** `shared_preferences` for current login session
- **Other Tools:** GitHub, Android Emulator, physical Android phone for testing

## 3. Repackaging From Existing HTML Code

The original HTML project already contains a strong student portal concept with login, dashboard, navigation, finance, academic, exam, club, handbook, and AI assistant features.

For the mobile app version, the web features will be repackaged into Flutter screens:

| Existing HTML Feature | Flutter Mobile App Version |
|---|---|
| Login / Sign Up / Forgot Password | Authentication screens |
| Dashboard cards | Home dashboard screen |
| Academic menu | Academic module screen |
| Class schedule / attendance / notes | Academic detail screens |
| Finance payment and transaction ledger | Finance CRUD screen |
| Zakat application modal | Application form screen |
| Student clubs | Clubs list and detail screen |
| Student handbook | Handbook screen |
| localStorage database | SQLite database |

## 4. Minimum Functional Screens

The app will include more than 5 screens:

1. **Login Screen**
   - Student enters ID and password.
   - Validation for empty fields and incorrect password.
   - Navigates to dashboard after successful login.

2. **Register Screen**
   - Student creates a new account.
   - Input fields: student ID, name, password.
   - Validation for duplicate ID and empty fields.
   - Saves new user into SQLite database.

3. **Dashboard Screen**
   - Shows student name, outstanding balance, next class, attendance summary, and quick actions.
   - Buttons navigate to academic, finance, exam, and profile pages.

4. **Academic Screen**
   - Shows subject structure, class schedule, attendance, and learning materials.
   - Students can view registered subjects and class information.

5. **Finance Screen**
   - Shows outstanding balance and transaction records.
   - Student can add a payment record.
   - Student can view transaction history.
   - Student can update or delete a transaction if needed.

6. **Application Screen**
   - Allows students to submit support applications such as Zakat or financial assistance.
   - Saves applications into the database.
   - Includes validation and submission status.

7. **Profile Screen**
   - Shows student ID, name, program, and digital student card information.
   - Student can update profile information.

8. **Club Screen**
   - Lists student clubs.
   - Students can view club details and register interest.

## 5. User Input Features

The app includes user input in:

- Login form
- Register form
- Finance payment form
- Profile update form
- Zakat / assistance application form
- Club registration form
- Student testimonial / feedback form

## 6. Database Integration

The app will use SQLite as the working database.

### Proposed Database Tables

#### users

| Field | Type | Description |
|---|---|---|
| id | TEXT PRIMARY KEY | Student ID |
| name | TEXT | Student name |
| password | TEXT | Login password |
| program | TEXT | Student program |
| balance | REAL | Outstanding finance balance |

#### subjects

| Field | Type | Description |
|---|---|---|
| subject_id | INTEGER PRIMARY KEY AUTOINCREMENT | Subject record ID |
| code | TEXT | Subject code |
| name | TEXT | Subject name |
| semester | INTEGER | Semester number |
| credit | INTEGER | Credit hour |

#### transactions

| Field | Type | Description |
|---|---|---|
| transaction_id | INTEGER PRIMARY KEY AUTOINCREMENT | Transaction ID |
| user_id | TEXT | Student ID |
| date | TEXT | Transaction date |
| description | TEXT | Transaction description |
| amount | REAL | Transaction amount |
| type | TEXT | Debit or Credit |

#### applications

| Field | Type | Description |
|---|---|---|
| application_id | INTEGER PRIMARY KEY AUTOINCREMENT | Application ID |
| user_id | TEXT | Student ID |
| type | TEXT | Zakat / support type |
| reason | TEXT | Application reason |
| status | TEXT | Pending / Approved / Rejected |
| created_at | TEXT | Submission date |

#### clubs

| Field | Type | Description |
|---|---|---|
| club_id | INTEGER PRIMARY KEY AUTOINCREMENT | Club ID |
| name | TEXT | Club name |
| description | TEXT | Club description |
| phone | TEXT | Contact number |
| person_in_charge | TEXT | PIC name |

## 7. CRUD Functions

The app meets the Add, View, Update, Delete requirement:

| CRUD Action | App Feature |
|---|---|
| Add | Register user, add payment, submit application, submit testimonial |
| View | View dashboard, subjects, finance records, exam schedule, clubs |
| Update | Update profile, update transaction or application details |
| Delete | Delete transaction record or cancel submitted application |

## 8. Validation and Error Handling

Examples of validation:

- Login cannot be empty.
- Password must be at least 6 characters.
- Student ID cannot be duplicated.
- Payment amount must be greater than 0.
- Application reason cannot be empty.
- Database errors show a friendly message such as: "Unable to save data. Please try again."

## 9. Clean User Interface

The mobile UI will use:

- Bottom navigation or drawer menu
- Clear page titles
- Red primary theme inspired by the original portal
- Cards for dashboard summaries
- Tables or lists for academic and finance records
- Form fields with labels and error messages
- Consistent buttons and spacing

## 10. Testing Evidence

Testing evidence can be shown with screenshots and a simple test table.

| Test Case | Steps | Expected Result | Status |
|---|---|---|---|
| Login with valid account | Enter valid ID and password, tap Login | User enters dashboard | Pass |
| Login with wrong password | Enter wrong password, tap Login | Error message appears | Pass |
| Register new student | Fill ID, name, password, tap Register | New user saved to database | Pass |
| Add payment | Enter payment amount, tap Pay | Balance updates and transaction is added | Pass |
| Invalid payment | Enter 0 or negative amount | Validation error appears | Pass |
| Submit application | Fill reason and submit | Application saved as Pending | Pass |
| Update profile | Change name/program and save | Profile information updates | Pass |
| Delete transaction | Tap delete on transaction record | Record removed from database | Pass |
| Navigation test | Tap bottom nav / drawer menu | Correct screen opens | Pass |

## 11. Final Demonstration Flow

Suggested presentation demo:

1. Open the Student Portal Mobile App.
2. Show the Login Screen.
3. Register a new student account.
4. Log in using the new student account.
5. Show the Dashboard Screen.
6. Navigate to Academic Screen and view subjects / schedule.
7. Navigate to Finance Screen and add a payment.
8. Show that the balance and transaction list update.
9. Navigate to Application Screen and submit a Zakat / support application.
10. Show Profile Screen and update student information.
11. Explain that all important records are stored in SQLite.

## 12. Short Presentation Script

Good morning/afternoon. My project is a Student Portal Mobile App developed using Flutter and SQLite. The app solves the problem of students needing to access many university services from different platforms. With this app, students can log in, check their dashboard, view academic information, manage finance records, submit applications, and update their profile in one place.

The app includes more than five functional screens: Login, Register, Dashboard, Academic, Finance, Application, Profile, and Clubs. It also includes user input features such as registration, payment, profile update, and application submission.

For database integration, I use SQLite. The database stores users, subjects, transactions, applications, and club information. The app supports CRUD functions. Users can add new data, view records, update profile or transaction information, and delete records such as transactions or cancelled applications.

Validation and error handling are included. For example, empty login fields, duplicate student IDs, and invalid payment amounts will show error messages. Finally, I tested the main functions such as login, register, add payment, update profile, delete record, and navigation to make sure the app works correctly.

## 13. Recommended Flutter Package List

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.9.0
  shared_preferences: ^2.2.2
  intl: ^0.19.0
```

## 14. Suggested Flutter Folder Structure

```text
lib/
  main.dart
  database/
    database_helper.dart
  models/
    user.dart
    subject.dart
    transaction.dart
    application.dart
    club.dart
  screens/
    login_screen.dart
    register_screen.dart
    dashboard_screen.dart
    academic_screen.dart
    finance_screen.dart
    application_screen.dart
    profile_screen.dart
    club_screen.dart
  widgets/
    app_button.dart
    app_text_field.dart
    dashboard_card.dart
```
