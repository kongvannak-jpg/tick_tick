# 🚨 Register Page Error Troubleshooting Guide

## Issue Found: Windows Developer Mode Required

**Primary Error:**

```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
Run: start ms-settings:developers
```

## Quick Fix Steps:

### 1. Enable Windows Developer Mode

1. **Windows Settings opened** - Look for "Developer Mode" toggle
2. **Turn ON "Developer Mode"**
3. **Restart your computer** (recommended)

### 2. Test Register Functionality

After enabling Developer Mode, let's test the register feature:

```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### 3. Common Register Page Errors & Solutions

#### Error: "All fields are required"

- **Cause:** Empty form fields
- **Solution:** Fill all fields: First Name, Last Name, Email, Position, Password

#### Error: "Password must be at least 6 characters"

- **Cause:** Password too short
- **Solution:** Use password with 6+ characters

#### Error: "Please enter a valid email address"

- **Cause:** Invalid email format
- **Solution:** Use proper email format (e.g., user@example.com)

#### Error: "Please accept the terms and conditions"

- **Cause:** Terms checkbox not checked
- **Solution:** Check the terms and conditions checkbox

#### Error: Navigation or provider issues

- **Cause:** Provider not initialized or route issues
- **Solution:** Check main.dart provider setup

### 4. Debug Register Process

Your register flow:

1. **RegisterScreen** → `_handleRegister()` method
2. **AuthProvider** → `register()` method
3. **AuthService** → `register()` method
4. **Navigate to Home** → `context.go(AppRoutes.home)`

### 5. Test with Sample Data

Use this test data to verify registration works:

```
First Name: John
Last Name: Doe
Email: john.doe@example.com
Position: Developer
Password: password123
✅ Accept Terms and Conditions
```

### 6. Check Error Messages

The app shows errors via SnackBar. Look for:

- Red error messages at bottom of screen
- Form field validation messages
- Console/debug output

### 7. Alternative Test Method

If register still fails, try:

1. **Test login first** with existing user:

   - Email: `test@example.com`
   - Password: `password`

2. **Check console output** for detailed error messages

3. **Try web version** if desktop fails:
   ```powershell
   flutter run -d chrome
   ```

## 🔧 Expected Behavior

**Successful Registration:**

1. Fill all form fields correctly
2. Check terms and conditions
3. Tap "Create Account" button
4. Loading indicator appears
5. Navigation to Home screen
6. User data saved (and synced to Google Drive if connected)

## 🚨 If Still Having Issues

Try this simplified register test:

1. **Disable Google Drive integration temporarily** in auth provider
2. **Test basic register functionality**
3. **Re-enable integrations** once basic flow works

Let me know the specific error message you see when clicking "Create Account" and I'll help fix it!

---

**Most Likely Fix:** Enable Windows Developer Mode and restart your computer, then try again.
