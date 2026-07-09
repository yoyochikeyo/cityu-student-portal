# Student Portal Mobile App

This is a Flutter repackaging of the original HTML Student Portal into a mobile app that meets the project requirements.

## Features

- Login and register
- Dashboard
- Academic subject and schedule view
- Finance CRUD with SQLite
- Student support application CRUD
- Profile update
- Clubs page
- Validation and error handling

## Database

The app uses SQLite through `sqflite`.

Tables:

- `users`
- `subjects`
- `transactions`
- `applications`
- `clubs`

## Run

```bash
flutter create .
flutter pub get
flutter run
```

`flutter create .` is included because this submitted folder focuses on the app source code. It lets Flutter generate the Android/iOS/Web platform folders before running.

Default account:

- Student ID: `MILLER2026`
- Password: `123456`

## Testing Evidence Checklist

| Test | Expected Result |
|---|---|
| Login with default account | Dashboard opens |
| Register user | New user is saved |
| Add finance payment | Balance and transaction list update |
| Edit transaction | Transaction amount/description updates |
| Delete transaction | Transaction is removed |
| Submit application | Application appears as Pending |
| Edit application | Reason updates |
| Delete application | Application is removed |
| Update profile | User name/program updates |
