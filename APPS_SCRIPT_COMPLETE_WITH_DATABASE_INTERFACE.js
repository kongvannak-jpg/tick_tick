/**
 * COMPLETE GOOGLE APPS SCRIPT WITH DATABASE INTERFACE SUPPORT
 * 
 * This script implements all DatabaseInterface methods with password hashing
 * Deploy as Web App with Execute as: Me, Access: Anyone
 * 
 * Features:
 * - All CRUD operations (Create, Read, Update, Delete)
 * - Password hashing with SHA-256
 * - User search functionality
 * - Pagination support
 * - Connection testing
 * - Error handling and logging
 */

function doPost(e) {
    try {
        // Parse the request
        const params = e.parameter;
        const action = params.action;

        Logger.log('Received action: ' + action);
        Logger.log('Parameters: ' + JSON.stringify(params));

        // Get the active spreadsheet
        const sheet = SpreadsheetApp.getActiveSheet();

        // Route to appropriate handler
        let result;
        switch (action) {
            case 'register':
                result = handleRegister(sheet, params);
                break;
            case 'login':
                result = handleLogin(sheet, params);
                break;
            case 'getUserById':
                result = handleGetUserById(sheet, params);
                break;
            case 'getUserByEmail':
                result = handleGetUserByEmail(sheet, params);
                break;
            case 'updateUser':
                result = handleUpdateUser(sheet, params);
                break;
            case 'deleteUser':
                result = handleDeleteUser(sheet, params);
                break;
            case 'getUsers':
                result = handleGetUsers(sheet, params);
                break;
            case 'searchUsers':
                result = handleSearchUsers(sheet, params);
                break;
            case 'testConnection':
                result = handleTestConnection();
                break;
            default:
                result = {
                    success: false,
                    message: 'Unknown action: ' + action
                };
        }

        Logger.log('Result: ' + JSON.stringify(result));

        return ContentService
            .createTextOutput(JSON.stringify(result))
            .setMimeType(ContentService.MimeType.JSON);

    } catch (error) {
        Logger.log('Error: ' + error.toString());
        return ContentService
            .createTextOutput(JSON.stringify({
                success: false,
                message: 'Server error: ' + error.toString()
            }))
            .setMimeType(ContentService.MimeType.JSON);
    }
}

/**
 * Handle user registration with password hashing
 */
function handleRegister(sheet, params) {
    try {
        const email = params.email;
        const firstName = params.firstName || '';
        const lastName = params.lastName || '';
        const position = params.position || '';
        const password = params.password;

        if (!email || !password) {
            return { success: false, message: 'Email and password are required' };
        }

        // Check if user already exists
        const existingUser = findUserByEmail(sheet, email);
        if (existingUser) {
            return { success: false, message: 'User already exists' };
        }

        // Hash password
        const hashedPassword = hashPassword(password);

        // Generate ID
        const userId = generateUserId();
        const timestamp = new Date().toISOString();

        // Add user to sheet
        sheet.appendRow([
            userId,           // A: ID
            email,           // B: Email
            firstName,       // C: First Name
            lastName,        // D: Last Name
            position,        // E: Position
            hashedPassword,  // F: Password (hashed)
            timestamp,       // G: Created At
            '',              // H: Avatar (empty)
        ]);

        // Return user data (without password)
        const user = {
            id: userId,
            email: email,
            firstName: firstName,
            lastName: lastName,
            position: position,
            createdAt: timestamp,
            avatar: null
        };

        return { success: true, user: user };

    } catch (error) {
        Logger.log('Register error: ' + error.toString());
        return { success: false, message: 'Registration failed: ' + error.toString() };
    }
}

/**
 * Handle user login with password verification
 */
function handleLogin(sheet, params) {
    try {
        const email = params.email;
        const hashedPassword = params.hashedPassword;

        if (!email || !hashedPassword) {
            return { success: false, message: 'Email and password are required' };
        }

        // Find user by email
        const userData = findUserByEmail(sheet, email);
        if (!userData) {
            return { success: false, message: 'Invalid credentials' };
        }

        // Verify password
        if (userData.password !== hashedPassword) {
            return { success: false, message: 'Invalid credentials' };
        }

        // Return user data (without password)
        const user = {
            id: userData.id,
            email: userData.email,
            firstName: userData.firstName,
            lastName: userData.lastName,
            position: userData.position,
            createdAt: userData.createdAt,
            avatar: userData.avatar
        };

        return { success: true, user: user };

    } catch (error) {
        Logger.log('Login error: ' + error.toString());
        return { success: false, message: 'Login failed: ' + error.toString() };
    }
}

/**
 * Get user by ID
 */
function handleGetUserById(sheet, params) {
    try {
        const userId = params.id;
        if (!userId) {
            return { success: false, message: 'User ID is required' };
        }

        const userData = findUserById(sheet, userId);
        if (!userData) {
            return { success: false, message: 'User not found' };
        }

        // Return user data (without password)
        const user = {
            id: userData.id,
            email: userData.email,
            firstName: userData.firstName,
            lastName: userData.lastName,
            position: userData.position,
            createdAt: userData.createdAt,
            avatar: userData.avatar
        };

        return { success: true, user: user };

    } catch (error) {
        Logger.log('GetUserById error: ' + error.toString());
        return { success: false, message: 'Failed to get user: ' + error.toString() };
    }
}

/**
 * Get user by email
 */
function handleGetUserByEmail(sheet, params) {
    try {
        const email = params.email;
        if (!email) {
            return { success: false, message: 'Email is required' };
        }

        const userData = findUserByEmail(sheet, email);
        if (!userData) {
            return { success: false, message: 'User not found' };
        }

        // Return user data (without password)
        const user = {
            id: userData.id,
            email: userData.email,
            firstName: userData.firstName,
            lastName: userData.lastName,
            position: userData.position,
            createdAt: userData.createdAt,
            avatar: userData.avatar
        };

        return { success: true, user: user };

    } catch (error) {
        Logger.log('GetUserByEmail error: ' + error.toString());
        return { success: false, message: 'Failed to get user: ' + error.toString() };
    }
}

/**
 * Update user information
 */
function handleUpdateUser(sheet, params) {
    try {
        const userId = params.id;
        const firstName = params.firstName;
        const lastName = params.lastName;
        const email = params.email;
        const position = params.position;

        if (!userId) {
            return { success: false, message: 'User ID is required' };
        }

        // Find user row
        const data = sheet.getDataRange().getValues();
        const headerRow = data[0];

        for (let i = 1; i < data.length; i++) {
            const row = data[i];
            if (row[0] === userId) { // ID column
                // Update the fields
                if (firstName !== undefined) row[2] = firstName; // First Name
                if (lastName !== undefined) row[3] = lastName;   // Last Name
                if (email !== undefined) row[1] = email;         // Email
                if (position !== undefined) row[4] = position;   // Position

                // Write back to sheet
                const range = sheet.getRange(i + 1, 1, 1, row.length);
                range.setValues([row]);

                return { success: true };
            }
        }

        return { success: false, message: 'User not found' };

    } catch (error) {
        Logger.log('UpdateUser error: ' + error.toString());
        return { success: false, message: 'Failed to update user: ' + error.toString() };
    }
}

/**
 * Delete user
 */
function handleDeleteUser(sheet, params) {
    try {
        const userId = params.id;
        if (!userId) {
            return { success: false, message: 'User ID is required' };
        }

        // Find user row
        const data = sheet.getDataRange().getValues();

        for (let i = 1; i < data.length; i++) {
            const row = data[i];
            if (row[0] === userId) { // ID column
                sheet.deleteRow(i + 1);
                return { success: true };
            }
        }

        return { success: false, message: 'User not found' };

    } catch (error) {
        Logger.log('DeleteUser error: ' + error.toString());
        return { success: false, message: 'Failed to delete user: ' + error.toString() };
    }
}

/**
 * Get all users with pagination
 */
function handleGetUsers(sheet, params) {
    try {
        const page = parseInt(params.page) || 1;
        const limit = parseInt(params.limit) || 50;

        const data = sheet.getDataRange().getValues();
        const users = [];

        // Skip header row
        for (let i = 1; i < data.length; i++) {
            const row = data[i];
            const user = {
                id: row[0],
                email: row[1],
                firstName: row[2],
                lastName: row[3],
                position: row[4],
                createdAt: row[6],
                avatar: row[7] || null
            };
            users.push(user);
        }

        // Apply pagination
        const startIndex = (page - 1) * limit;
        const endIndex = startIndex + limit;
        const paginatedUsers = users.slice(startIndex, endIndex);

        return {
            success: true,
            users: paginatedUsers,
            total: users.length,
            page: page,
            limit: limit
        };

    } catch (error) {
        Logger.log('GetUsers error: ' + error.toString());
        return { success: false, message: 'Failed to get users: ' + error.toString() };
    }
}

/**
 * Search users by query
 */
function handleSearchUsers(sheet, params) {
    try {
        const query = params.query;
        if (!query) {
            return { success: false, message: 'Search query is required' };
        }

        const data = sheet.getDataRange().getValues();
        const users = [];
        const searchTerm = query.toLowerCase();

        // Skip header row
        for (let i = 1; i < data.length; i++) {
            const row = data[i];
            const email = (row[1] || '').toString().toLowerCase();
            const firstName = (row[2] || '').toString().toLowerCase();
            const lastName = (row[3] || '').toString().toLowerCase();
            const position = (row[4] || '').toString().toLowerCase();

            // Check if any field contains the search term
            if (email.includes(searchTerm) ||
                firstName.includes(searchTerm) ||
                lastName.includes(searchTerm) ||
                position.includes(searchTerm)) {

                const user = {
                    id: row[0],
                    email: row[1],
                    firstName: row[2],
                    lastName: row[3],
                    position: row[4],
                    createdAt: row[6],
                    avatar: row[7] || null
                };
                users.push(user);
            }
        }

        return { success: true, users: users };

    } catch (error) {
        Logger.log('SearchUsers error: ' + error.toString());
        return { success: false, message: 'Failed to search users: ' + error.toString() };
    }
}

/**
 * Test connection
 */
function handleTestConnection() {
    try {
        return { success: true, message: 'Connection successful' };
    } catch (error) {
        Logger.log('TestConnection error: ' + error.toString());
        return { success: false, message: 'Connection failed: ' + error.toString() };
    }
}

/**
 * Find user by email
 */
function findUserByEmail(sheet, email) {
    const data = sheet.getDataRange().getValues();

    for (let i = 1; i < data.length; i++) {
        const row = data[i];
        if (row[1] === email) { // Email column
            return {
                id: row[0],
                email: row[1],
                firstName: row[2],
                lastName: row[3],
                position: row[4],
                password: row[5],
                createdAt: row[6],
                avatar: row[7]
            };
        }
    }

    return null;
}

/**
 * Find user by ID
 */
function findUserById(sheet, userId) {
    const data = sheet.getDataRange().getValues();

    for (let i = 1; i < data.length; i++) {
        const row = data[i];
        if (row[0] === userId) { // ID column
            return {
                id: row[0],
                email: row[1],
                firstName: row[2],
                lastName: row[3],
                position: row[4],
                password: row[5],
                createdAt: row[6],
                avatar: row[7]
            };
        }
    }

    return null;
}

/**
 * Generate unique user ID
 */
function generateUserId() {
    return 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

/**
 * Hash password using SHA-256
 */
function hashPassword(password) {
    const salt = 'ticktick_salt_2025'; // Should match AppConfig.passwordSalt
    const saltedPassword = salt + password + salt;
    return Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_256, saltedPassword)
        .map(function (byte) {
            return ('0' + (byte & 0xFF).toString(16)).slice(-2);
        })
        .join('');
}

/**
 * Setup headers if sheet is empty
 */
function setupHeaders() {
    const sheet = SpreadsheetApp.getActiveSheet();
    const data = sheet.getDataRange().getValues();

    if (data.length === 0 || !data[0][0]) {
        sheet.getRange(1, 1, 1, 8).setValues([
            ['ID', 'Email', 'First Name', 'Last Name', 'Position', 'Password', 'Created At', 'Avatar']
        ]);

        // Format header row
        const headerRange = sheet.getRange(1, 1, 1, 8);
        headerRange.setFontWeight('bold');
        headerRange.setBackground('#f0f0f0');
    }
}

// Initialize headers when script is deployed
function onInstall() {
    setupHeaders();
}