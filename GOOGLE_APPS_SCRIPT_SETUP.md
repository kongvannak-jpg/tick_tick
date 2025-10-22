# 🚀 Google Apps Script Setup - Auto Save to Your Sheet!

## Step 1: Create Google Apps Script

1. **Go to**: https://script.google.com
2. **Click**: "New Project"
3. **Name it**: "TickTick User Registration"

## Step 2: Replace Code.gs Content

Delete everything and paste this code:

```javascript
function doPost(e) {
  try {
    // Get your spreadsheet
    var sheet = SpreadsheetApp.openById(
      "1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs"
    ).getActiveSheet();

    // Parse the data from Flutter app
    var data = JSON.parse(e.postData.contents);

    if (data.action === "addUser") {
      var userData = data.data;

      // Add new row with user data
      sheet.appendRow([
        userData.id,
        userData.firstName,
        userData.lastName,
        userData.email,
        userData.position,
        userData.createdAt,
      ]);

      return ContentService.createTextOutput(
        JSON.stringify({ success: true, message: "User added successfully" })
      ).setMimeType(ContentService.MimeType.JSON);
    }

    return ContentService.createTextOutput(
      JSON.stringify({ success: false, message: "Invalid action" })
    ).setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    return ContentService.createTextOutput(
      JSON.stringify({ success: false, message: error.toString() })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  return ContentService.createTextOutput(
    "TickTick Registration API is working!"
  ).setMimeType(ContentService.MimeType.TEXT);
}
```

## Step 3: Deploy as Web App

1. **Click**: "Deploy" → "New deployment"
2. **Type**: Choose "Web app"
3. **Execute as**: Me (your Gmail account)
4. **Who has access**: Anyone
5. **Click**: "Deploy"
6. **Copy the Web App URL** (looks like: https://script.google.com/macros/s/ABC123.../exec)

## Step 4: Update Flutter App

You'll need to paste that Web App URL into your Flutter app so it can automatically save users to your Google Sheet!

## 🎯 Result

After setup:

- ✅ User registers in Flutter app
- ✅ Data automatically appears in your Google Sheet
- ✅ No manual copy-paste needed!
- ✅ Real-time database functionality

**Copy the Web App URL and I'll update your Flutter code!**
