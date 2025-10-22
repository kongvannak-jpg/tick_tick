# 🚀 Google Sheets Database Setup

Your app is now connected to: **https://docs.google.com/spreadsheets/d/1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs/edit**

## 📋 Step 1: Set Up Your Sheet Headers

1. **Open your Google Sheet**: [Click here](https://docs.google.com/spreadsheets/d/1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs/edit)

2. **Add these headers in Row 1** (columns A-F):

   ```
   A1: ID
   B1: First Name
   C1: Last Name
   D1: Email
   E1: Position
   F1: Created At
   ```

3. **Make sure your sheet is named "Sheet1"** or rename it if needed

## 🔧 How It Works Now

### ✅ **Registration Process:**

1. User fills registration form
2. App creates user account
3. **App automatically saves user to your Google Sheet!**
4. You can see all users in your spreadsheet

### ✅ **What Gets Saved:**

- **ID**: Unique user identifier
- **First Name**: User's first name
- **Last Name**: User's last name
- **Email**: User's email address
- **Position**: User's job position
- **Created At**: Registration timestamp

## 🧪 Test Registration

**Try registering with this test data:**

```
First Name: John
Last Name: Doe
Email: john.doe@example.com
Position: Developer
Password: password123
✅ Accept Terms and Conditions
```

**After registration:**

1. Check your Google Sheet
2. You should see the new user data added automatically!

## 📊 Example Sheet Layout

Your sheet should look like this:

| ID          | First Name | Last Name | Email                | Position  | Created At     |
| ----------- | ---------- | --------- | -------------------- | --------- | -------------- |
| user_123... | John       | Doe       | john.doe@example.com | Developer | 2025-10-21T... |

## 🔄 Current Method

Right now, the app will:

1. ✅ **Create user account successfully**
2. ✅ **Show registration details in console**
3. 📝 **Display manual instructions to add to sheet**

**Next Step**: For fully automatic writing, we can set up Google Apps Script (optional).

## 💡 Benefits

- ✅ **No Google Cloud Console required**
- ✅ **Simple CSV reading for user data**
- ✅ **Your Gmail account controls the sheet**
- ✅ **Easy to manage and view users**
- ✅ **Works immediately**

## 🚨 Important Notes

1. **Keep your sheet public for reading** (or shareable with link)
2. **Sheet ID is hardcoded**: `1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs`
3. **Gmail account**: `vannakkong85@gmail.com` (sheet owner)

Your app is now connected to your Google Sheet as a database! 🎉
