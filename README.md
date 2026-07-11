
# Notes Management App

A simple and beautiful Notes Management application built with Flutter and Firebase Firestore. This app allows users to create, update, view, and delete notes in real time.

## Features

- View all notes
- Add new notes
- Edit existing notes
- Delete notes
- Real-time data synchronization with Firebase Firestore
- Simple and attractive UI
- Responsive and clean user interface

---

## Built With

- Flutter
- Dart
- Firebase Firestore

---

## Project Structure

```text
lib/
├── models/
│   └── note_model.dart
├── services/
│   └── firestore_service.dart
├── screens/
│   ├── home_screen.dart
│   └── add_edit_note_screen.dart
├── widgets/
│   └── note_card.dart
├── firebase_options.dart
└── main.dart
```

---

## Getting Started

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Android Studio or VS Code
- Firebase CLI
- FlutterFire CLI

### Installation

1. Clone the repository.

```bash
git clone https://github.com/your-username/flutter_note_management_app.git
```

2. Navigate to the project directory.

```bash
cd flutter_note_management_app
```

3. Install dependencies.

```bash
flutter pub get
```

4. Run the application.

```bash
flutter run
```

---

## Firebase Configuration

This project uses Firebase Firestore as the database.

To configure Firebase:

```bash
flutterfire configure
```

Make sure you have:

- Enabled Firebase for your project.
- Created a Firestore Database.
- Updated your Firebase configuration files.

---

## Future Improvements

- User Authentication
- Search Notes
- Dark Mode
- Pin Important Notes
- Colorful Notes
- Note Creation Date & Time

---

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to fork this repository and submit a pull request.

---

## Author

**Habibullah Mohammad Masum**

B.Sc. in Computer Science & Engineering, IIUC

GitHub: https://github.com/Hm-masum

---

## Support

If you like this project, please consider giving it a star on GitHub. It motivates me to build more useful projects.

---

Built with Flutter and Firebase.
