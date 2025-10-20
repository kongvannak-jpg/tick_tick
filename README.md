# Tick Tick - Flutter App with Riverpod & GoRouter

A well-structured Flutter application demonstrating best practices with Riverpod for state management and GoRouter for navigation.

## 📁 Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── constants/               # App constants (colors, strings, etc.)
├── models/                  # Data models
│   └── user.dart           # User model
├── providers/              # Riverpod providers
│   └── auth_provider.dart  # Authentication state management
├── routes/                 # Navigation configuration
│   └── app_router.dart     # GoRouter setup
├── screens/                # UI screens
│   ├── login_screen.dart   # Login screen matching your design
│   └── home_screen.dart    # Home screen after login
├── services/               # Business logic & API calls
│   └── auth_service.dart   # Authentication service
└── widgets/                # Reusable UI components
    ├── custom_button.dart  # Custom button widget
    └── custom_text_field.dart # Custom text field widget
```

## 🚀 Features

- ✅ **Riverpod State Management**: Clean, scalable state management
- ✅ **GoRouter Navigation**: Declarative routing with authentication guards
- ✅ **Clean Architecture**: Well-organized folder structure
- ✅ **Custom Widgets**: Reusable UI components
- ✅ **Form Validation**: Email and password validation
- ✅ **Loading States**: Proper loading indicators
- ✅ **Error Handling**: User-friendly error messages

## 📱 Login Screen Features

- **Beautiful UI**: Matches your provided design
- **KE MOK HERY** branding with shield icon
- **Email & Password fields** with validation
- **Remember Me** checkbox
- **Password visibility toggle**
- **Loading states** during authentication
- **Error handling** with snackbar notifications
- **Register link** (ready for implementation)

## 🔧 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^3.0.3 # State management
  go_router: ^16.2.5 # Navigation
  riverpod_annotation: ^3.0.3 # Riverpod annotations
```

## 🔐 Authentication Flow

1. **Login Screen** (`/login`) - Default route
2. **Authentication** - Handled by `AuthService`
3. **Home Screen** (`/home`) - After successful login
4. **Auto-redirect** - Based on authentication state

## 🧪 Test Credentials

For demo purposes, use any of these:

- **Email**: `test@example.com`, **Password**: `password`
- **Email**: Any valid email format, **Password**: Any 6+ characters

## 🎨 Design System

- **Primary Color**: Royal Blue (`#4169E1`)
- **Typography**: Clean, modern font hierarchy
- **Components**: Consistent spacing and styling
- **Theme**: Material 3 design system

## 🚀 Getting Started

1. **Install dependencies**:

   ```bash
   flutter pub get
   ```

2. **Run the app**:

   ```bash
   flutter run
   ```

3. **Test the login**:
   - Use the test credentials above
   - Try form validation with invalid inputs
   - Experience the loading states

## 📋 Next Steps

You can extend this structure by adding:

- **Registration screen** (`lib/screens/register_screen.dart`)
- **Profile management** (`lib/screens/profile_screen.dart`)
- **Settings screen** (`lib/screens/settings_screen.dart`)
- **API integration** (update `AuthService`)
- **Local storage** (shared preferences, secure storage)
- **Push notifications**
- **Dark theme support**
- **Internationalization**

## 🏗️ Architecture Benefits

- **Scalable**: Easy to add new features
- **Maintainable**: Clear separation of concerns
- **Testable**: Well-structured for unit/widget testing
- **Type-safe**: Strong typing with Dart
- **Reactive**: Efficient state management with Riverpod
