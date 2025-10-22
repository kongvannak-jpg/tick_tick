# 🛠️ Google Sheets Access Fix

## 🔍 **Problem Identified**: Private Sheet + CORS

Your Google Sheet is private and requires authentication, which causes:

- ❌ CORS policy blocks access from Flutter web app
- ❌ Cannot read CSV data directly
- ❌ Cannot write data automatically

## ✅ **Solution 1: Make Sheet Public (Recommended)**

1. **Open your sheet**: https://docs.google.com/spreadsheets/d/1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs/edit
2. **Share button** → **"Anyone with the link"** → **"Viewer"**
3. **Test again** with the orange button in your app

## ✅ **Solution 2: Google Apps Script (More Secure)**

If you prefer to keep the sheet private:

### Create Apps Script:

1. **Go to**: https://script.google.com
2. **New Project** → Name: "TickTick Registration API"
3. **Replace code** with:

```javascript
function doPost(e) {
  try {
    var sheet = SpreadsheetApp.openById(
      "1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs"
    ).getActiveSheet();
    var data = JSON.parse(e.postData.contents);

    if (data.action === "addUser") {
      var user = data.data;
      sheet.appendRow([
        user.id,
        user.firstName,
        user.lastName,
        user.email,
        user.position,
        user.createdAt,
      ]);
      return ContentService.createTextOutput(
        JSON.stringify({ success: true })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  } catch (error) {
    return ContentService.createTextOutput(
      JSON.stringify({ success: false, error: error.toString() })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  try {
    var sheet = SpreadsheetApp.openById(
      "1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs"
    ).getActiveSheet();
    var data = sheet.getDataRange().getValues();
    var users = [];

    // Skip header row
    for (var i = 1; i < data.length; i++) {
      users.push({
        id: data[i][0],
        firstName: data[i][1],
        lastName: data[i][2],
        email: data[i][3],
        position: data[i][4],
        createdAt: data[i][5],
      });
    }

    return ContentService.createTextOutput(
      JSON.stringify({ success: true, users: users })
    ).setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    return ContentService.createTextOutput(
      JSON.stringify({ success: false, error: error.toString() })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}
```

### Deploy as Web App:

1. **Deploy** → **New deployment**
2. **Type**: Web app
3. **Execute as**: Me
4. **Access**: Anyone
5. **Copy the Web App URL**

### Update Flutter Code:

Replace line 11 in `google_sheets_database.dart`:

```dart
static const String? _webAppUrl = 'YOUR_APPS_SCRIPT_URL_HERE';
```

## 🎯 **Recommendation**

**Try Solution 1 first** (make sheet public with "Viewer" access):

- ✅ Simpler setup
- ✅ Works immediately
- ✅ Read-only public access is safe
- ✅ Only people with the link can view

**Test the orange button again after making the sheet public!**
