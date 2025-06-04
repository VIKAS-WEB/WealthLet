# 💼 WealthLet — Personal Finance Management App

**WealthLet** is a powerful and intuitive personal finance management platform designed to help users track income, expenses, and savings efficiently. Built using **Flutter** and **Firebase**, it demonstrates practical skills in cross-platform mobile/web development, clean architecture, and cloud integration — making it a standout portfolio project for real-world problem solving.

---

## 🚀 Live Demo

📸 Screenshots

---

## 📸 Screenshots

<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 40px;">
  <img src="ScreenShots/DashboardMain.png" width="120" alt="Dashboard Overview" />
  <img src="ScreenShots/Opitions.png" width="120" alt="Crypto Trading" />
  <img src="ScreenShots/ElectricBoard.png" width="120" alt="Electric Bill" />
  <img src="ScreenShots/Invest.png" width="120" alt="Investment Dashboard" />
  <img src="ScreenShots/Offers.png" width="120" alt="Offers" />
  <img src="ScreenShots/Opitions.png" width="120" alt="Repeat Options" />
  <img src="ScreenShots/Savings.png" width="120" alt="Savings Overview" />
  <img src="ScreenShots/TravelDash.png" width="120" alt="Travel Dashboard" />
  <img src="ScreenShots/TravelWelcomScreen.png" width="120" alt="Travel Welcome" />
  <img src="ScreenShots/electric.png" width="120" alt="Electric Details" />
</div>

---

## 🧩 Key Features

- 🔐 **User Authentication** – Secure sign-up & login using Firebase Auth  
- 💰 **Expense & Income Tracking** – Add, update, and delete financial transactions  
- 📊 **Analytics Dashboard** – Visual insights using bar graphs  
- 📂 **Categorization** – Organize finances by custom tags or categories  
- 📆 **Date-wise Filtering** – View trends and filter transactions by date  
- 🌙 **Dark Mode** – Sleek Material UI design with theme toggle  

---

## 🛠️ Tech Stack

### 🎯 Frontend (Cross-platform)
- **Flutter** – Mobile + Web UI framework
- **Material UI (Flutter Widgets)** – Responsive and modern components
- **Bar Graphs** – `fl_chart` / `charts_flutter` for analytics and trends

### ☁️ Backend & Cloud
- **Firebase Firestore** – Real-time NoSQL database
- **Firebase Authentication** – Secure and scalable auth system
- **Cloudinary** – Image/media upload & optimization
- **Firebase Hosting / Vercel** – Hosting for Flutter Web (if deployed)

---

## 🧠 State Management – BLoC Pattern

WealthLet uses the **BLoC (Business Logic Component)** pattern to handle state management efficiently.

### ✅ Benefits:
- Clean separation between UI and logic  
- Reactive updates with streams  
- Easy to test and scale  

### 🔧 Example Flow:
1. **UI (e.g., `TopUpScreen.dart`)**
```dart
context.read<TransactionBloc>().add(AddTransaction(...));
BLoC Logic (transaction_bloc.dart)

dart
Copy
Edit
on<AddTransaction>((event, emit) async {
  emit(TransactionLoading());
  await repository.addTransaction(event.data);
  emit(TransactionSuccess());
});
UI Listens via BlocBuilder

dart
Copy
Edit
BlocBuilder<TransactionBloc, TransactionState>(
  builder: (context, state) {
    if (state is TransactionLoading) return CircularProgressIndicator();
    if (state is TransactionSuccess) return Text("Added!");
    return Container();
  },
);

📁 Folder Structure
bash
Copy
Edit
wealthlet/
├── android/                         # Android native files
├── ios/                             # iOS native files
├── linux/                           # Linux-specific files (if using desktop)
├── assets/                          # App images, icons, etc.
├── lib/
│   ├── core/                        # Core utilities, constants, themes
│   ├── features/                    # Feature-based modular structure
│   │   ├── Auth/                    # Authentication logic & UI
│   │   ├── Home/
│   │   │   ├── Bloc/                # BLoC state management
│   │   │   ├── Data/                # Models, services, repositories
│   │   │   └── Presentation/
│   │   │       ├── Screens/        # UI screens
│   │   │       └── Widgets/        # Reusable widgets
│   │   │           ├── DonationScreen.dart
│   │   │           ├── InvestScreen.dart
│   │   │           ├── LoanScreen.dart
│   │   │           ├── OffersPage.dart
│   │   │           ├── RemittanceScreen.dart
│   │   │           ├── Savings.dart
│   │   │           ├── Schedule_Transaction.dart
│   │   │           ├── ScheduleTransactionScreenMain.dart
│   │   │           └── TopUpScreen.dart
│   │   ├── Payments/               # Payments module
│   │   ├── Profile/                # User profile management
│   │   └── Travel/                 # Travel-related features
│   └── main.dart                   # App entry point
├── pubspec.yaml                    # Dependencies and config
└── README.md
