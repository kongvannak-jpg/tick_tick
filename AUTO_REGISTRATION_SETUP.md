# 🎯 AUTOMATIC GOOGLE SHEETS REGISTRATION SETUP

## 🚀 **Goal: Registration → Automatic Insert to Google Sheet**

When users register, data will automatically appear in your Google Sheet without manual copy-paste!

## 📝 **Step 1: Create Google Apps Script**

1. **Go to**: https://script.google.com
2. **Click**: "New Project"
3. **Name**: "TickTick Auto Registration"
4. **Delete all existing code** and **paste this**:

```javascript
function doPost(e) {
  try {
    console.log("Received registration request");

    // Your Google Sheet ID
    var sheet = SpreadsheetApp.openById(
      "1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs"
    ).getActiveSheet();

    // Parse the data from Flutter app
    var data = JSON.parse(e.postData.contents);
    console.log("Parsed data:", data);

    if (data.action === "addUser") {
      var user = data.data;

      // Add user to your Google Sheet automatically
      sheet.appendRow([
        user.id,
        user.firstName,
        user.lastName,
        user.email,
        user.position,
        user.createdAt,
      ]);

      console.log("✅ User added to sheet:", user.email);

      return ContentService.createTextOutput(
        JSON.stringify({
          success: true,
          message: "User registered and saved to Google Sheet!",
          user: user.email,
        })
      ).setMimeType(ContentService.MimeType.JSON);
    }

    return ContentService.createTextOutput(
      JSON.stringify({
        success: false,
        message: "Invalid action",
      })
    ).setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    console.error("Error:", error);
    return ContentService.createTextOutput(
      JSON.stringify({
        success: false,
        message: error.toString(),
      })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  return ContentService.createTextOutput(
    "TickTick Registration API is working!"
  ).setMimeType(ContentService.MimeType.TEXT);
}

// Test function (optional)
function testAddUser() {
  var testData = {
    action: "addUser",
    data: {
      id: "test_" + new Date().getTime(),
      firstName: "Test",
      lastName: "User",
      email: "test@example.com",
      position: "Developer",
      createdAt: new Date().toISOString(),
    },
  };

  var mockEvent = {
    postData: {
      contents: JSON.stringify(testData),
    },
  };

  var result = doPost(mockEvent);
  console.log("Test result:", result.getContent());
}
```

## 🚀 **Step 2: Deploy as Web App**

1. **Click "Deploy"** → **"New deployment"**
2. **Type**: Web app
3. **Description**: "TickTick Auto Registration"
4. **Execute as**: Me (vannakkong85@gmail.com)
5. **Who has access**: Anyone
6. **Click "Deploy"**
7. **Copy the Web App URL** (starts with `https://script.google.com/macros/s/...`)

## 📱 **Step 3: Update Flutter App**

After you get the Web App URL, I'll update your Flutter code to use it!

## 🎯 **Result After Setup**

✅ User registers in Flutter app  
✅ Data automatically appears in Google Sheet  
✅ No manual copy-paste needed  
✅ Real-time registration database

**Follow Step 1 and Step 2, then share the Web App URL with me to complete the setup!**
