// Simple test to check if your Google Apps Script is working
// Run this in your browser's console while on the TickTick registration page

async function testRegistrationAPI() {
    const webAppUrl = 'https://script.google.com/macros/s/AKfycby8Nf4-tNM8VpVLazhjHu2tudpsGnskuAs87KTRy1NSImy6aE1cTKM3_iFYPDJoKO__lg/exec';

    const testData = {
        'id': 'TEST_' + Date.now(),
        'firstName': 'Browser',
        'lastName': 'Test',
        'email': 'browser.test@example.com',
        'position': 'Browser Tester',
        'createdAt': new Date().toISOString()
    };

    console.log('🧪 Testing registration API...');
    console.log('📤 Sending data:', testData);

    try {
        // Convert data to form format like Flutter does
        const formData = new URLSearchParams();
        Object.keys(testData).forEach(key => {
            formData.append(key, testData[key]);
        });

        const response = await fetch(webAppUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData.toString()
        });

        console.log('📥 Response status:', response.status);

        const responseText = await response.text();
        console.log('📄 Response body:', responseText);

        try {
            const result = JSON.parse(responseText);
            if (result.success) {
                console.log('✅ SUCCESS! Registration API is working!');
                console.log('📊 Check your Google Sheet now!');
            } else {
                console.log('❌ API Error:', result.message);
            }
        } catch (e) {
            console.log('⚠️ Response is not JSON:', responseText);
        }

    } catch (error) {
        console.error('❌ Network error:', error);
    }
}

// Run the test
testRegistrationAPI();