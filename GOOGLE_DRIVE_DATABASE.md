# Google Drive as Database Setup Guide

This guide explains how to set up Google Drive as a database for your TickTick app data storage and synchronization.

## 🎯 Overview

Instead of using Google Drive for authentication, we're using it as a **cloud database** to:

- Store user profiles and data
- Sync data across multiple devices
- Backup user information automatically
- Restore data when needed

## 📋 Features Implemented

### ✅ **Data Storage**

- **User Profiles** - Save complete user profiles to Google Drive
- **App Settings** - Backup app preferences and configurations
- **Automatic Sync** - Data saved automatically during registration
- **Cross-Device Access** - Access your data from any device

### ✅ **Data Management**

- **Backup Current Profile** - Manual backup of logged-in user
- **Restore Data** - Load saved profiles from Google Drive
- **View Drive Data** - See what's stored in your Google Drive
- **Delete Data** - Remove specific user data when needed

### ✅ **App Integration**

- **Registration Integration** - New users automatically backed up
- **Data Sync Screen** - Dedicated UI for managing Drive data
- **Connection Management** - Connect/disconnect from Google Drive
- **Error Handling** - Proper error messages and recovery

## 🚀 Setup Instructions

### 1. Google Cloud Console Setup

1. **Create a Project:**

   - Go to [Google Cloud Console](https://console.cloud.google.com)
   - Create a new project or select existing one

2. **Enable APIs:**

   - Go to "APIs & Services" > "Library"
   - Enable **Google Drive API**
   - Enable **Google Sign-In API** (for authentication only)

3. **Create OAuth 2.0 Credentials:**
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth 2.0 Client IDs"
   - Configure for your platforms (Android/iOS/Web)

### 2. Android Configuration

1. **Get SHA-1 Fingerprint:**

   ```bash
   # Debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

2. **Configure OAuth Client:**

   - Create Android OAuth client in Google Cloud Console
   - Add your package name: `com.example.tick_tick`
   - Add SHA-1 fingerprint

3. **Download and Configure:**

   - Download `google-services.json`
   - Place in `android/app/` directory

4. **Update build.gradle files:**

   **Project level** (`android/build.gradle`):

   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```

   **App level** (`android/app/build.gradle`):

   ```gradle
   plugins {
       id 'com.google.gms.google-services'
   }
   ```

### 3. iOS Configuration

1. **Configure OAuth Client:**

   - Create iOS OAuth client in Google Cloud Console
   - Add bundle ID: `com.example.tickTick`

2. **Download and Configure:**

   - Download `GoogleService-Info.plist`
   - Add to your Xcode project

3. **Update Info.plist:**
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSE_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSE_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

## 🎯 How to Use

### **Connect to Google Drive**

1. **Open the app** and go to **Home Screen**
2. **Tap "Google Drive Sync"** button
3. **Tap "Connect to Google Drive"**
4. **Sign in** with your Google account
5. **Grant permissions** for Drive access

### **Automatic Data Backup**

- **Registration:** New users are automatically backed up to Drive
- **Profile Updates:** Changes sync automatically (if implemented)
- **Manual Backup:** Use "Backup My Profile" button in Data Sync screen

### **Data Management**

1. **Backup Current User:**

   - Go to Data Sync screen
   - Tap "Backup My Profile"
   - Your current profile saves to Google Drive

2. **Restore Data:**

   - Go to Data Sync screen
   - Tap "Restore Data"
   - Select from available backups
   - Data loads into the app

3. **View Stored Data:**

   - Go to Data Sync screen
   - Tap "View Drive Data"
   - See list of backed up users

4. **Sync Settings:**
   - Backup app preferences
   - Sync theme and notification settings

## 📁 Google Drive Structure

Your app creates this folder structure in Google Drive:

```
Google Drive/
└── TickTick_Data/
    ├── user_{user_id}.json      # Individual user profiles
    ├── user_{user_id_2}.json    # Another user profile
    └── app_settings.json        # App settings and preferences
```

### **Data Format Examples**

**User Profile (`user_123.json`):**

```json
{
  "id": "123",
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "position": "Software Developer",
  "createdAt": "2024-01-15T10:30:00.000Z"
}
```

**App Settings (`app_settings.json`):**

```json
{
  "theme": "light",
  "notifications": true,
  "sync_enabled": true,
  "last_sync": "2024-01-15T10:30:00.000Z"
}
```

## 🔧 Advanced Features

### **Multi-User Support**

- Store multiple user profiles
- Switch between different accounts
- Restore any saved user profile

### **Data Synchronization**

- Real-time backup during registration
- Manual sync options
- Conflict resolution (latest wins)

### **Privacy & Security**

- Data stored in app-specific folder
- Only your app can access the data
- Standard Google Drive encryption

## 🧪 Testing the Integration

### **Test Data Storage:**

1. **Register a new user** → Check if data appears in Google Drive
2. **Connect to Drive** → Verify connection status
3. **Backup profile** → Confirm manual backup works
4. **View Drive data** → See stored files
5. **Restore data** → Load saved profile

### **Test Scenarios:**

1. **New Device:** Install app → Connect to Drive → Restore data
2. **Multiple Users:** Register several users → All saved to Drive
3. **Offline Mode:** Use app without Drive → Connect later → Sync data
4. **Data Recovery:** Delete app → Reinstall → Restore from Drive

## 🔍 Troubleshooting

### **Common Issues:**

1. **"Failed to connect":**

   - Check internet connection
   - Verify OAuth credentials
   - Ensure Drive API is enabled

2. **"Permission denied":**

   - Check OAuth scopes include Drive access
   - Verify app signing matches credentials

3. **"No data found":**

   - Ensure you're signed in to correct Google account
   - Check if data exists in Drive folder

4. **Android signing issues:**
   - Verify SHA-1 fingerprint matches
   - Check `google-services.json` is correct

### **Debug Steps:**

```bash
# Check dependencies
flutter pub deps

# Clean and rebuild
flutter clean
flutter pub get

# View Drive API calls
flutter run --verbose
```

## 📱 User Experience

### **First Time Setup:**

1. Register in app
2. Go to Data Sync screen
3. Connect to Google Drive
4. Data automatically backed up

### **Daily Usage:**

- Data saves automatically
- Manual backup available
- Restore when switching devices

### **Multi-Device:**

- Same Google account on all devices
- Data syncs across devices
- Latest data always available

## 🔒 Privacy & Data

- **Your data stays yours** - Stored in your personal Google Drive
- **App-specific folder** - Only TickTick can access the data
- **No server storage** - Data goes directly to your Drive
- **Standard encryption** - Google Drive's built-in security

## 📞 Support

If you encounter issues:

1. Check Google Cloud Console configuration
2. Verify API permissions and scopes
3. Test with a fresh Google account
4. Check device logs for error details

---

**Your Google Drive is now your personal database for TickTick!** 🎉

All user data, profiles, and settings are safely stored in your own Google Drive account, giving you complete control over your data while enabling seamless sync across all your devices.
