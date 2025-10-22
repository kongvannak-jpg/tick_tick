// SIMPLE WORKING VERSION - Copy this to Google Apps Script
function doPost(e) {
    try {
        console.log("📋 Received request from Flutter");
        console.log("📋 Parameters received:", JSON.stringify(e.parameter || {}));

        // Your Google Sheet
        var sheet = SpreadsheetApp.openById("1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs").getActiveSheet();

        // Get the form data that Flutter sends
        var userData = e.parameter;

        if (!userData || !userData.id) {
            console.log("❌ No data received");
            return ContentService.createTextOutput(
                JSON.stringify({
                    success: false,
                    message: "No data received from Flutter"
                })
            ).setMimeType(ContentService.MimeType.JSON);
        }

        console.log("📋 Adding user to sheet:", userData.email);

        // Add headers if sheet is empty
        if (sheet.getLastRow() === 0) {
            sheet.appendRow(['ID', 'First Name', 'Last Name', 'Email', 'Position', 'Created At']);
        }

        // Add the user data
        sheet.appendRow([
            userData.id,
            userData.firstName,
            userData.lastName,
            userData.email,
            userData.position,
            userData.createdAt
        ]);

        console.log("✅ User added successfully!");

        return ContentService.createTextOutput(
            JSON.stringify({
                success: true,
                message: "Registration successful!",
                email: userData.email
            })
        ).setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        console.error("❌ Error:", error.toString());

        return ContentService.createTextOutput(
            JSON.stringify({
                success: false,
                message: "Error: " + error.toString()
            })
        ).setMimeType(ContentService.MimeType.JSON);
    }
}

function doGet(e) {
    return ContentService.createTextOutput("TickTick API Working").setMimeType(ContentService.MimeType.TEXT);
}