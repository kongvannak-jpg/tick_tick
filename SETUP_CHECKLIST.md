# ✅ Google Drive Setup Checklist

## 📋 Step-by-Step Checklist

### ✅ 1. Android Build Files (COMPLETED)

- [x] Updated `android/build.gradle.kts` with Google Services classpath
- [x] Updated `android/app/build.gradle.kts` with Google Services plugin
- [x] Flutter dependencies already added to `pubspec.yaml`

### 🔧 2. Google Cloud Console Setup (YOU NEED TO DO)

#### Create Google Cloud Project:

- [ ] Go to https://console.cloud.google.com
- [ ] Create new project named "TickTick-App"
- [ ] Select the project

#### Enable APIs:

- [ ] Go to "APIs & Services" → "Library"
- [ ] Enable "Google Drive API"
- [ ] Enable "Google Sign-In API"

#### Configure OAuth Consent Screen:

- [ ] Go to "OAuth consent screen"
- [ ] Choose "External" user type
- [ ] Fill in app name: "TickTick"
- [ ] Add your email as support and developer contact
- [ ] Add scope: `../auth/drive.file`
- [ ] Add yourself as test user

#### Create Android OAuth Client:

- [ ] Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"
- [ ] Application type: "Android"
- [ ] Package name: `com.example.tick_tick`
- [ ] Get SHA-1 fingerprint (see command below)
- [ ] Add SHA-1 to the OAuth client

### 🔑 3. Get Your SHA-1 Fingerprint

Open PowerShell and run:

```powershell
keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Copy the SHA-1 line (looks like: `A1:B2:C3:D4:...`)

### 📁 4. Download and Place Configuration File

- [ ] Download `google-services.json` from Google Cloud Console
- [ ] Place it in: `d:\lekha project\flutter\tick\tick_tick\android\app\google-services.json`

### 🧪 5. Test Your Setup

Run these commands:

```powershell
cd "d:\lekha project\flutter\tick\tick_tick"
flutter clean
flutter pub get
flutter run
```

### 📱 6. Test in Your App

- [ ] Open the app
- [ ] Register a new user
- [ ] Go to Home → "Google Drive Sync"
- [ ] Tap "Connect to Google Drive"
- [ ] Sign in with your Google account
- [ ] Grant permissions
- [ ] Check if connection shows "Connected"

### 🔍 7. Verify Data in Google Drive

- [ ] Go to https://drive.google.com
- [ ] Look for "TickTick_Data" folder
- [ ] Check for user JSON files inside

## 🚨 Common Issues & Solutions

### "Build failed" or "Google Services error"

```powershell
flutter clean
flutter pub get
flutter run
```

### "SHA-1 certificate fingerprint mismatch"

- Re-run the SHA-1 command above
- Update the fingerprint in Google Cloud Console
- Clean and rebuild the app

### "Sign in failed"

- Check `google-services.json` is in correct location
- Verify package name matches exactly: `com.example.tick_tick`
- Ensure all APIs are enabled

### "Permission denied"

- Check OAuth consent screen is configured
- Verify you added yourself as test user
- Ensure Drive scope is included

## 📞 Need Help?

1. Check the detailed guides:

   - `GOOGLE_DRIVE_SETUP_GUIDE.md` - Complete setup instructions
   - `ANDROID_CONFIG.md` - Android-specific configuration

2. Check console logs:

   ```powershell
   flutter run --verbose
   ```

3. Verify your setup:
   ```powershell
   flutter doctor
   ```

---

## 🎯 What Happens After Setup:

1. **Users register** → Data automatically saves to their Google Drive
2. **Users switch devices** → Connect to Drive → Restore their data
3. **Cross-device sync** → Same data available everywhere
4. **Your app uses Google Drive as database** → No server costs for you!

**Once you complete the checklist above, your TickTick app will be fully integrated with Google Drive!** 🚀

---

## 📋 Quick Summary:

**You need to:**

1. Set up Google Cloud Console project
2. Get SHA-1 fingerprint with the PowerShell command
3. Create OAuth credentials with your SHA-1
4. Download and place `google-services.json` file
5. Test the app

**Already done for you:**

- ✅ Android build files updated
- ✅ Flutter dependencies added
- ✅ Google Drive service code created
- ✅ UI screens implemented
- ✅ State management configured
