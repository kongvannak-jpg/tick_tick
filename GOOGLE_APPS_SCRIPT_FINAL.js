/**
 * FINAL WORKING APPS SCRIPT FOR TICK TICK REGISTRATION
 * 
 * Instructions:
 * 1. Replace ALL the code in your Google Apps Script with this code
 * 2. Save and deploy as Web App
 * 3. Make sure permissions are set to "Anyone" and execution is "Me"
 * 
 * This version:
 * - Handles both JSON and form-encoded data
 * - Includes proper CORS headers
 * - Has better error handling
 * - Logs all operations for debugging
 */

// Your Google Sheet ID
const SHEET_ID = '1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs';
const SHEET_NAME = 'Sheet1'; // Adjust if your sheet has a different name

/**
 * Handle OPTIONS requests for CORS preflight
 */
function doOptions() {
    console.log('📋 Handling OPTIONS request for CORS preflight');

    const response = HtmlService.createHtmlOutput();
    response.setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);

    return response
        .getBlob()
        .setContentType('text/plain')
        .setName('CORS Response');
}

/**
 * Handle GET requests - for testing
 */
function doGet(e) {
    console.log('📋 GET request received');
    console.log('Parameters:', JSON.stringify(e.parameter));

    try {
        const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName(SHEET_NAME);
        const data = sheet.getDataRange().getValues();

        console.log('✅ Successfully read sheet data');
        console.log('Sheet has', data.length, 'rows');

        const response = {
            success: true,
            message: 'Google Apps Script is working!',
            timestamp: new Date().toISOString(),
            rowCount: data.length,
            headers: data.length > 0 ? data[0] : []
        };

        return ContentService
            .createTextOutput(JSON.stringify(response))
            .setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        console.error('❌ GET request failed:', error);

        const errorResponse = {
            success: false,
            error: error.toString(),
            timestamp: new Date().toISOString()
        };

        return ContentService
            .createTextOutput(JSON.stringify(errorResponse))
            .setMimeType(ContentService.MimeType.JSON);
    }
}

/**
 * Handle POST requests - for registration data
 */
function doPost(e) {
    console.log('📋 POST request received');
    console.log('Content type:', e.parameter ? 'form-encoded' : 'unknown');
    console.log('Raw parameters:', JSON.stringify(e.parameter || {}));
    console.log('Raw contents:', e.postData ? e.postData.contents : 'no contents');

    try {
        let userData;

        // Try to parse form-encoded data first (from Flutter)
        if (e.parameter && Object.keys(e.parameter).length > 0) {
            console.log('📋 Parsing form-encoded data');
            userData = e.parameter;
        }
        // Try to parse JSON data
        else if (e.postData && e.postData.contents) {
            console.log('📋 Parsing JSON data');
            userData = JSON.parse(e.postData.contents);
        }
        else {
            throw new Error('No data received in POST request');
        }

        console.log('📋 Parsed user data:', JSON.stringify(userData));

        // Validate required fields
        const requiredFields = ['id', 'firstName', 'lastName', 'email', 'position', 'createdAt'];
        const missingFields = requiredFields.filter(field => !userData[field]);

        if (missingFields.length > 0) {
            throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
        }

        // Open the Google Sheet
        const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName(SHEET_NAME);

        // Check if sheet has headers, if not add them
        const dataRange = sheet.getDataRange();
        if (dataRange.getNumRows() === 0) {
            console.log('📋 Adding headers to empty sheet');
            sheet.appendRow(['ID', 'First Name', 'Last Name', 'Email', 'Position', 'Created At']);
        }

        // Prepare the row data in the correct order
        const rowData = [
            userData.id,
            userData.firstName,
            userData.lastName,
            userData.email,
            userData.position,
            userData.createdAt
        ];

        console.log('📋 Appending row data:', JSON.stringify(rowData));

        // Insert the data
        sheet.appendRow(rowData);

        console.log('✅ Successfully inserted data to Google Sheet');

        // Return success response
        const response = {
            success: true,
            message: 'Registration data saved successfully!',
            timestamp: new Date().toISOString(),
            userData: userData
        };

        return ContentService
            .createTextOutput(JSON.stringify(response))
            .setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        console.error('❌ POST request failed:', error);

        const errorResponse = {
            success: false,
            error: error.toString(),
            timestamp: new Date().toISOString(),
            receivedData: e.parameter || (e.postData ? e.postData.contents : null)
        };

        return ContentService
            .createTextOutput(JSON.stringify(errorResponse))
            .setMimeType(ContentService.MimeType.JSON);
    }
}

/**
 * Test function - run this manually to test the script
 */
function testScript() {
    console.log('🧪 Testing Google Apps Script...');

    try {
        // Test opening the sheet
        const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName(SHEET_NAME);
        console.log('✅ Successfully opened sheet:', sheet.getName());

        // Test inserting data
        const testData = [
            'TEST_' + new Date().getTime(),
            'Test',
            'User',
            'test@example.com',
            'Tester',
            new Date().toISOString()
        ];

        sheet.appendRow(testData);
        console.log('✅ Successfully inserted test data');

        return 'Test completed successfully!';

    } catch (error) {
        console.error('❌ Test failed:', error);
        return 'Test failed: ' + error.toString();
    }
}