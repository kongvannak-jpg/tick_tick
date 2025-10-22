// DEBUG VERSION - Use this in Google Apps Script to see exactly what Flutter sends
function doPost(e) {
    try {
        console.log("🔍 DEBUGGING - Received POST request from Flutter");
        console.log("🔍 Raw postData:", JSON.stringify(e.postData));
        console.log("🔍 Parameters:", JSON.stringify(e.parameter || {}));
        console.log("🔍 Content length:", e.postData ? e.postData.length : 'undefined');
        console.log("🔍 Content type:", e.postData ? e.postData.type : 'undefined');

        // Your Google Sheet
        var sheet = SpreadsheetApp.openById("1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs").getActiveSheet();

        // Get data directly from form parameters (sent by Flutter)
        var userData = e.parameter;

        if (!userData) {
            console.log("❌ No parameter data received");
            return ContentService.createTextOutput(
                JSON.stringify({
                    success: false,
                    message: "No parameter data received",
                    debug: {
                        hasPostData: !!e.postData,
                        hasParameter: !!e.parameter,
                        postDataKeys: e.postData ? Object.keys(e.postData) : [],
                        parameterKeys: e.parameter ? Object.keys(e.parameter) : []
                    }
                })
            ).setMimeType(ContentService.MimeType.JSON);
        }

        if (!userData.id) {
            console.log("❌ No ID in userData:", JSON.stringify(userData));
            return ContentService.createTextOutput(
                JSON.stringify({
                    success: false,
                    message: "No ID field in user data",
                    receivedData: userData
                })
            ).setMimeType(ContentService.MimeType.JSON);
        }

        console.log("🔍 Processing user:", userData.email);
        console.log("🔍 All user data:", JSON.stringify(userData));

        // Check if sheet has headers, add them if needed
        if (sheet.getLastRow() === 0) {
            console.log("🔍 Adding headers to empty sheet");
            sheet.appendRow(['ID', 'First Name', 'Last Name', 'Email', 'Position', 'Created At']);
        }

        // Add user data to sheet
        var rowData = [
            userData.id,
            userData.firstName,
            userData.lastName,
            userData.email,
            userData.position,
            userData.createdAt
        ];

        console.log("🔍 Row data to insert:", JSON.stringify(rowData));
        sheet.appendRow(rowData);

        console.log("✅ User successfully added to Google Sheet:", userData.email);

        return ContentService.createTextOutput(
            JSON.stringify({
                success: true,
                message: "User registered successfully!",
                email: userData.email,
                timestamp: new Date().toISOString(),
                debug: {
                    receivedFields: Object.keys(userData),
                    insertedRow: rowData
                }
            })
        ).setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        console.error("❌ Error processing registration:", error.toString());
        console.error("❌ Error stack:", error.stack);

        return ContentService.createTextOutput(
            JSON.stringify({
                success: false,
                message: "Registration failed: " + error.toString(),
                timestamp: new Date().toISOString(),
                debug: {
                    errorStack: error.stack,
                    hasPostData: !!e.postData,
                    hasParameter: !!e.parameter
                }
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

// Test function that matches exactly what Flutter should send
function testFlutterFormat() {
    console.log("🧪 Testing Flutter format...");

    var mockEvent = {
        parameter: {
            id: "USR_" + new Date().getTime(),
            firstName: "Flutter",
            lastName: "Test",
            email: "flutter.test@example.com",
            position: "App Tester",
            createdAt: new Date().toISOString()
        }
    };

    var result = doPost(mockEvent);
    console.log("Test result:", result.getContent());

    return result.getContent();
}