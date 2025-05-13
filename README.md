#  Flutter Task Manager App

A clean and modern task management app built with **Flutter** and **BLoC architecture**. It allows you to create, update, delete, search, and filter tasks, with light/dark theme support.

---

##  Features

-  Create, edit, delete tasks
-  Search tasks by title or description
-  Filter tasks by status (All / Pending / Completed)
-  Light and dark theme toggle
-  Clean architecture with BLoC pattern
-  Mock API (local in-memory)

---

##  Folder Structure

```
lib/
├── bloc/
│   ├── task_bloc.dart
│   ├── task_event.dart
│   ├── task_state.dart
│   └── theme_cubit.dart
│
├── data/
│   ├── models/
│   │   └── task.dart
│   ├── providers/
│   │   └── task_remote_provider.dart
│   └── repositories/
│       └── task_repository.dart
│
├── ui/
│   ├── screens/
│   │   ├── task_list_screen.dart
│   │   └── task_form_screen.dart
│   └── widgets/
│       ├── task_card.dart
│       └── filter_dropdown.dart
│
└── main.dart
```

---

##  Getting Started

### 1. Install Flutter

Install Flutter SDK:  
 https://docs.flutter.dev/get-started/install

Then verify setup:

```bash
flutter doctor
```

---

### 2. Clone the Repo

```bash
git clone https://github.com/your-username/task_manager_flutter.git
cd task_manager_flutter
```

---

### 3. Install Dependencies

```bash
flutter pub get
```

---

### 4. Run the App

```bash
flutter run
```

---

##  Tech Stack

- Flutter 3+
- Dart
- flutter_bloc
- Material Design

---

##  License

Licensed under the MIT License.
