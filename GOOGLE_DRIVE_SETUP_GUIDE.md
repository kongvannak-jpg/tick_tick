# 🚀 Complete Google Drive Setup Guide for TickTick App

## 📋 Overview

This guide will help you set up Google Drive integration so your TickTick app can save user data to **your personal Google Drive account** as a database.

## Step 1: Google Cloud Console Setup

### 1.1 Create a Google Cloud Project

1. **Go to Google Cloud Console**

   - Visit: https://console.cloud.google.com
   - Sign in with your Google account

2. **Create New Project**

   - Click "Select a project" dropdown at the top
   - Click "New Project"
   - Project Name: `TickTick-App` (or any name you prefer)
   - Click "Create"
   - Wait for project creation to complete

3. **Select Your Project**
   - Make sure your new project is selected in the dropdown

### 1.2 Enable Required APIs

1. **Navigate to APIs & Services**

   - Click the hamburger menu (☰) → "APIs & Services" → "Library"

2. **Enable Google Drive API**

   - Search for "Google Drive API"
   - Click on "Google Drive API"
   - Click "Enable"
   - Wait for activation

3. **Enable Google Sign-In API**
   - Search for "Google Sign-In API" or "Google+ API"
   - Click on it and click "Enable"

## Step 2: Create OAuth 2.0 Credentials

### 2.1 Configure OAuth Consent Screen

1. **Go to OAuth Consent Screen**

   - APIs & Services → "OAuth consent screen"

2. **Choose User Type**

   - Select "External" (unless you have G Suite)
   - Click "Create"

3. **Fill App Information**

   ```
   App name: TickTick
   User support email: [your-email@gmail.com]
   Developer contact: [your-email@gmail.com]
   ```

   - Click "Save and Continue"

4. **Scopes** (Step 2)

   - Click "Add or Remove Scopes"
   - Search and add: `../auth/drive.file`
   - This allows your app to access files it creates
   - Click "Save and Continue"

5. **Test Users** (Step 3)
   - Add your email address as a test user
   - Click "Save and Continue"

### 2.2 Create OAuth 2.0 Client IDs

#### For Android:

1. **Create Android Credentials**

   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth 2.0 Client IDs"
   - Application type: "Android"

2. **Get SHA-1 Fingerprint**
   Open PowerShell and run:

   ```powershell
   # For debug keystore (development)
   keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

   Copy the SHA-1 fingerprint (looks like: `A1:B2:C3:...`)

3. **Configure Android Client**

   ```
   Name: TickTick Android
   Package name: com.example.tick_tick
   SHA-1 certificate fingerprint: [paste your SHA-1]
   ```

   - Click "Create"

4. **Download Configuration**
   - Download the `google-services.json` file
   - Save it to: `d:\lekha project\flutter\tick\tick_tick\android\app\google-services.json`

#### For iOS (if you plan to build for iOS):

1. **Create iOS Credentials**

   - Click "Create Credentials" → "OAuth 2.0 Client IDs"
   - Application type: "iOS"

   ```
   Name: TickTick iOS
   Bundle ID: com.example.tickTick
   ```

2. **Download Configuration**
   - Download `GoogleService-Info.plist`
   - Add to your iOS project in Xcode

## Step 3: Configure Your Flutter Project

### 3.1 Update Android Configuration

1. **Project-level build.gradle** (`android/build.gradle`):

   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.3.15'
       }
   }
   ```

2. **App-level build.gradle** (`android/app/build.gradle`):
   ```gradle
   plugins {
       id 'com.android.application'
       id 'kotlin-android'
       id 'dev.flutter.flutter-gradle-plugin'
       id 'com.google.gms.google-services'  // Add this line
   }
   ```

### 3.2 Verify Dependencies

Your `pubspec.yaml` should already have:

```yaml
dependencies:
  google_sign_in: ^6.2.1
  googleapis: ^13.2.0
  googleapis_auth: ^1.6.0
  shared_preferences: ^2.2.2
```

### 3.3 Run Flutter Commands

```powershell
cd "d:\lekha project\flutter\tick\tick_tick"
flutter clean
flutter pub get
```

## Step 4: Test the Integration

### 4.1 Run Your App

```powershell
flutter run
```

### 4.2 Test Google Drive Connection

1. **Open your app**
2. **Register a new user** (this should auto-save to Drive)
3. **Go to Home → Google Drive Sync**
4. **Tap "Connect to Google Drive"**
5. **Sign in with your Google account**
6. **Grant permissions** when prompted

### 4.3 Verify Data in Google Drive

1. **Go to Google Drive** (drive.google.com)
2. **Look for "TickTick_Data" folder**
3. **Check for user JSON files** inside the folder

## Step 5: Troubleshooting

### Common Issues:

#### ❌ "Sign in failed" or "Connection failed"

**Solution:**

- Check if `google-services.json` is in correct location
- Verify SHA-1 fingerprint matches your debug keystore
- Ensure APIs are enabled in Google Cloud Console

#### ❌ "Permission denied"

**Solution:**

- Check OAuth consent screen configuration
- Verify scopes include `drive.file`
- Make sure you're added as test user

#### ❌ "App not verified"

**Solution:**

- This is normal for development
- Click "Advanced" → "Go to TickTick (unsafe)"
- For production, submit for verification

#### ❌ Build errors

**Solution:**

```powershell
flutter clean
flutter pub get
flutter run
```

### Debug Commands:

```powershell
# Check Flutter doctor
flutter doctor

# See detailed logs
flutter run --verbose

# Check Android dependencies
cd android
./gradlew dependencies
```

## Step 6: Production Setup

### For App Store Release:

1. **Generate Release SHA-1:**

   ```powershell
   keytool -list -v -keystore [path-to-release-keystore] -alias [alias-name]
   ```

2. **Add Release SHA-1** to your OAuth client in Google Cloud Console

3. **Update OAuth Consent Screen** for production

4. **Submit for Verification** if needed

## 📱 How Your Users Will Experience It:

1. **First Time:**

   - User registers in your app
   - Data automatically saves to their Google Drive
   - No additional setup needed

2. **New Device:**

   - Install TickTick app
   - Go to "Google Drive Sync"
   - Connect with same Google account
   - Restore their data

3. **Daily Usage:**
   - All profile changes auto-sync
   - Manual backup available
   - Data always accessible

## 🔒 Privacy & Security:

- **Your users' data** goes to **their own Google Drive**
- **App-specific folder** - only TickTick can access it
- **OAuth 2.0 security** - industry standard
- **No server storage** - direct app-to-Drive connection

## ✅ Final Checklist:

- [ ] Google Cloud project created
- [ ] Drive API enabled
- [ ] OAuth consent screen configured
- [ ] Android OAuth client created
- [ ] SHA-1 fingerprint added
- [ ] `google-services.json` downloaded and placed
- [ ] `build.gradle` files updated
- [ ] Dependencies installed (`flutter pub get`)
- [ ] App tested with Drive connection

**Once completed, your TickTick app will use Google Drive as its database!** 🎉

---

## 🆘 Need Help?

If you encounter any issues:

1. **Check the console logs** in your terminal
2. **Verify all configuration files** are in place
3. **Double-check SHA-1 fingerprint** matches
4. **Ensure APIs are enabled** in Google Cloud Console
5. **Try with a fresh Google account** for testing

Your Google Drive will become the database for all TickTick user data! 🚀
