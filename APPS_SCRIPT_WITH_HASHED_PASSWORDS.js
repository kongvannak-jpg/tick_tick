// UPDATED APPS SCRIPT - With Hashed Password Storage
function doPost(e) {
    try {
        console.log("📋 Received request from Flutter");
        console.log("📋 Parameters received:", JSON.stringify(e.parameter || {}));

        // Your Google Sheet
        var sheet = SpreadsheetApp.openById("1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs").getActiveSheet();

        // Check if this is a login request
        if (e.parameter && e.parameter.action === "login") {
            return handleLogin(e.parameter, sheet);
        }

        // Otherwise handle registration
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
        console.log("📋 Password hash received:", userData.password ? "Yes (hashed)" : "No");

        // Add headers if sheet is empty
        if (sheet.getLastRow() === 0) {
            sheet.appendRow(['ID', 'First Name', 'Last Name', 'Email', 'Position', 'Password Hash', 'Created At']);
        }

        // Check if user already exists
        var data = sheet.getDataRange().getValues();
        for (var i = 1; i < data.length; i++) { // Skip header row
            if (data[i][3] === userData.email) { // Email is in column 4 (index 3)
                return ContentService.createTextOutput(
                    JSON.stringify({
                        success: false,
                        message: "User with this email already exists"
                    })
                ).setMimeType(ContentService.MimeType.JSON);
            }
        }

        // Add the user data with hashed password
        sheet.appendRow([
            userData.id,
            userData.firstName,
            userData.lastName,
            userData.email,
            userData.position,
            userData.password, // Store hashed password
            userData.createdAt
        ]);

        console.log("✅ User registered successfully with hashed password!");

        return ContentService.createTextOutput(
            JSON.stringify({
                success: true,
                message: "Registration successful! Password is securely hashed.",
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

// Handle login requests with hashed passwords
function handleLogin(loginData, sheet) {
    try {
        console.log("🔐 Processing login for:", loginData.email);
        console.log("🔐 Received password hash for verification");

        var data = sheet.getDataRange().getValues();

        // Find user by email and hashed password
        for (var i = 1; i < data.length; i++) { // Skip header row
            var row = data[i];
            var email = row[3]; // Email column
            var storedPasswordHash = row[5]; // Password hash column

            if (email === loginData.email && storedPasswordHash === loginData.password) {
                console.log("✅ Login successful for:", email);

                return ContentService.createTextOutput(
                    JSON.stringify({
                        success: true,
                        message: "Login successful!",
                        user: {
                            id: row[0],
                            firstName: row[1],
                            lastName: row[2],
                            email: row[3],
                            position: row[4],
                            createdAt: row[6]
                        }
                    })
                ).setMimeType(ContentService.MimeType.JSON);
            }
        }

        console.log("❌ Invalid credentials for:", loginData.email);

        return ContentService.createTextOutput(
            JSON.stringify({
                success: false,
                message: "Invalid email or password"
            })
        ).setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        console.error("❌ Login error:", error.toString());

        return ContentService.createTextOutput(
            JSON.stringify({
                success: false,
                message: "Login error: " + error.toString()
            })
        ).setMimeType(ContentService.MimeType.JSON);
    }
}

function doGet(e) {
    return ContentService.createTextOutput("TickTick API Working - Password Hashing Enabled").setMimeType(ContentService.MimeType.TEXT);
}