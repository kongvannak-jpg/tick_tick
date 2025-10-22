# 🔧 Android Configuration for Google Drive

## Required Changes to Android Build Files

### 1. Update `android/build.gradle.kts`

Add the Google Services plugin to your project-level build file:

```kotlin
// android/build.gradle.kts
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
```

### 2. Update `android/app/build.gradle.kts`

Add the Google Services plugin to your app-level build file:

```kotlin
// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this line
}

android {
    namespace = "com.example.tick_tick"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.tick_tick"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
```

### 3. File Structure You Need

After downloading from Google Cloud Console, place files here:

```
android/
├── app/
│   ├── google-services.json          # ← Place Google Services file here
│   └── build.gradle.kts
├── build.gradle.kts
└── ...
```

### 4. PowerShell Commands to Apply Changes

Run these commands in your project root:

```powershell
# Navigate to your project
cd "d:\lekha project\flutter\tick\tick_tick"

# Clean and get dependencies
flutter clean
flutter pub get

# Build to test configuration
flutter build apk --debug
```

## 🔑 Getting Your SHA-1 Fingerprint

### For Development (Debug):

```powershell
# Get debug keystore SHA-1
keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### For Release:

```powershell
# If you have a release keystore
keytool -list -v -keystore path\to\your\release.keystore -alias your-alias
```

## ⚠️ Important Notes

1. **Package Name:** Your app uses `com.example.tick_tick` - use this exactly in Google Cloud Console

2. **Debug vs Release:**

   - Use debug SHA-1 for development
   - Add release SHA-1 when publishing to Play Store

3. **File Location:**

   - `google-services.json` MUST be in `android/app/` directory
   - Not in `android/` or anywhere else

4. **Testing:**
   - Test on a real device or emulator with Google Play Services
   - Emulator needs Google APIs enabled

## 🧪 Test Your Setup

After configuration, run:

```powershell
flutter run
```

Then in your app:

1. Go to "Google Drive Sync"
2. Tap "Connect to Google Drive"
3. Sign in with your Google account
4. Check if connection succeeds

## 🚨 Troubleshooting

### Build Errors:

```powershell
# Clear everything and rebuild
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### SHA-1 Mismatch:

- Re-generate SHA-1 with correct keystore
- Update in Google Cloud Console
- Restart app

### Google Services Error:

- Verify `google-services.json` placement
- Check package name matches exactly
- Ensure Google Services plugin is applied

---

**Once these files are updated and you have your `google-services.json` file in place, your Google Drive integration will be ready!** 🚀
