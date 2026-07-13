# CityU Student Portal Mobile App Checklist

## App Idea

CityU Student Portal is a mobile student self-service app. It helps students manage academic registration, schedule, attendance, notes, exam results, financial payments, Zakat assistance, club applications, and profile details in one place.

## Development Tools

- Mobile app package: PWA mobile app shell
- Main implementation: HTML, CSS, JavaScript
- Database used: Browser localStorage database
- Other tools: Web App Manifest, Service Worker, Chrome mobile preview

Note: This PWA version is designed for preview and submission without Android Studio. It can be installed from Chrome using Add to Home Screen when served through localhost.

## Minimum Screens

The app includes more than 5 functional screens:

1. Login / Create Account
2. Dashboard
3. Subject Registration
4. Class Schedule
5. Class Attendance
6. Class Note
7. Exam Result
8. Financial Info
9. Zakat
10. Register Club
11. Profile

## User Input Features

- Login Student ID and password
- Create Account form
- Subject register/drop buttons
- Payment gateway form fields
- Zakat application reason
- Club application reason
- Profile name and photo upload
- Chatbot message input

## Database Integration

The app uses `localStorage` as its working database. Records remain after refresh.

Stored data includes:

- Users
- Subject registrations
- Attendance records
- Transactions
- Applications
- Profile photo

## Add, View, Update, Delete Data

- Add: Register account, register subjects, make payment, submit Zakat, submit club application
- View: Dashboard, schedule, attendance, notes, exam result, transaction history
- Update: Profile name/photo, transaction update, application reason update
- Delete: Drop subjects, delete transaction, delete application

## Working Buttons And Navigation

- Sidebar navigation
- Mobile menu toggle
- Top-right profile dropdown
- Payment modal
- Zakat modal
- Club application modal
- Attendance detail modal
- Chatbot navigation actions

## Validation And Error Handling

- Empty login validation
- Wrong password validation
- Duplicate Student ID validation
- Password minimum length validation
- Payment amount validation
- Receipt email validation
- Card, FPX, eWallet, and DuitNow field validation
- Zakat and club reason required validation
- Photo file type validation

## Testing Evidence

| Test Case | Expected Result |
|---|---|
| Login with valid account | Dashboard opens |
| Login with wrong password | Error toast appears |
| Create account | New user is saved |
| Register subject | Subject appears as registered |
| Drop subject | Subject is removed, at least one subject remains |
| Open class schedule | Calendar day view appears |
| Open attendance subject | Weekly records modal opens |
| Submit Zakat | Application saved as Pending |
| Submit club application | Club card becomes Pending and disabled |
| Pay outstanding balance | Transaction is added and balance updates |
| Upload profile photo | Photo preview appears and persists |
| Ask chatbot next class | Chatbot answers and opens Class Schedule |

## Final Demonstration Steps

1. Open `index.html` through localhost or GitHub Pages.
2. Login or create an account.
3. Show Dashboard.
4. Register/drop a subject.
5. Open Schedule calendar.
6. Open Attendance records.
7. View Class Notes.
8. View Exam Result filters.
9. Make a payment in Financial Info.
10. Submit Zakat or Club application.
11. Update Profile photo/name.
12. Ask chatbot: "what is my next class?"
