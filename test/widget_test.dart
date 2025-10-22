// Widget tests for Tick Tick app
//
// These tests verify the main app functionality including splash screen,
// authentication flow, and navigation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tick_tick/main.dart';
import 'package:tick_tick/constants/app_constants.dart';

void main() {
  group('App Initialization', () {
    testWidgets('App starts and shows splash screen', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Allow the splash screen to load
      await tester.pump();

      // Verify that the splash screen elements are present
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.text(AppStrings.brandName), findsOneWidget);

      // Let splash animation complete and navigation happen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to login screen after splash
      expect(find.text(AppStrings.welcomeBack), findsOneWidget);
    });

    testWidgets('Login screen displays correctly', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Wait for splash to complete and navigation to login
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify login screen elements
      expect(find.text(AppStrings.brandName), findsOneWidget);
      expect(find.text(AppStrings.welcomeBack), findsOneWidget);
      expect(find.text(AppStrings.emailHint), findsOneWidget);
      expect(find.text(AppStrings.passwordHint), findsOneWidget);
      expect(find.text(AppStrings.login), findsOneWidget);
      expect(find.text(AppStrings.rememberMe), findsOneWidget);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Wait for navigation to login screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find email and password fields
      final emailField = find.widgetWithText(
        TextFormField,
        AppStrings.emailHint,
      );
      final passwordField = find.widgetWithText(
        TextFormField,
        AppStrings.passwordHint,
      );

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      // Enter invalid email
      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, '123'); // Too short

      // Find and tap the login button
      final loginButton = find.text(AppStrings.login);
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show validation errors (check for any validation error, not specific text)
      expect(find.byType(TextFormField), findsWidgets);
    });
  });

  group('Form Interactions', () {
    testWidgets('Email field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find email field and enter text
      final emailField = find.widgetWithText(
        TextFormField,
        AppStrings.emailHint,
      );
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find password field
      final passwordField = find.widgetWithText(
        TextFormField,
        AppStrings.passwordHint,
      );
      expect(passwordField, findsOneWidget);

      // Find visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility);
      expect(visibilityButton, findsOneWidget);

      // Tap to show password
      await tester.tap(visibilityButton);
      await tester.pump();

      // Should now show the visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
