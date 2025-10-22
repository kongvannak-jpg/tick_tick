// WORKING GOOGLE APPS SCRIPT - SIMPLE VERSION FOR FLUTTER
function doPost(e) {
    try {
        console.log("📋 Received POST request from Flutter");
        console.log("📋 Parameters:", JSON.stringify(e.parameter || {}));

        // Your Google Sheet
        var sheet = SpreadsheetApp.openById("1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs").getActiveSheet();

        // Get data directly from form parameters (sent by Flutter)
        var userData = e.parameter;

        if (!userData || !userData.id) {
            throw new Error("No user data received from Flutter");
        }

        console.log("📋 Processing user:", userData.email);

        // Check if sheet has headers, add them if needed
        if (sheet.getLastRow() === 0) {
            sheet.appendRow(['ID', 'First Name', 'Last Name', 'Email', 'Position', 'Created At']);
        }

        // Add user data to sheet
        sheet.appendRow([
            userData.id,
            userData.firstName,
            userData.lastName,
            userData.email,
            userData.position,
            userData.createdAt
        ]);

        console.log("✅ User successfully added to Google Sheet:", userData.email);

        return ContentService.createTextOutput(
            JSON.stringify({
                success: true,
                message: "User registered successfully!",
                email: userData.email,
                timestamp: new Date().toISOString()
            })
        ).setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        console.error("❌ Error processing registration:", error.toString());

        return ContentService.createTextOutput(
            JSON.stringify({
                success: false,
                message: "Registration failed: " + error.toString(),
                timestamp: new Date().toISOString()
            })
        ).setMimeType(ContentService.MimeType.JSON);
    }
}

function doGet(e) {
    console.log("📋 GET request received - API is working");

    return ContentService.createTextOutput(
        JSON.stringify({
            status: "TickTick Registration API is working!",
            timestamp: new Date().toISOString()
        })
    ).setMimeType(ContentService.MimeType.JSON);
}

// Test function - run this manually to test the script
function testRegistration() {
    console.log("🧪 Testing registration function...");

    var mockEvent = {
        parameter: {
            id: "TEST_" + new Date().getTime(),
            firstName: "Test",
            lastName: "User",
            email: "test@example.com",
            position: "Tester",
            createdAt: new Date().toISOString()
        }
    };

    var result = doPost(mockEvent);
    console.log("Test result:", result.getContent());

    return result.getContent();
}