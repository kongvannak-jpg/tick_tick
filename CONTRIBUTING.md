# Contributing to Tick Tick

Thank you for your interest in contributing to Tick Tick! This document provides guidelines and instructions for contributing to the project.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.24.x or later)
- Dart SDK (included with Flutter)
- Git
- IDE with Flutter support (VS Code, Android Studio, or IntelliJ)

### Setup Development Environment
1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/tick_tick.git
   cd tick_tick
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 📋 Development Workflow

### Branch Naming Convention
- `feature/description` - for new features
- `bugfix/description` - for bug fixes
- `hotfix/description` - for urgent fixes
- `chore/description` - for maintenance tasks

### Commit Message Convention
We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:
```
feat(auth): add social login functionality
fix(login): resolve password validation issue
docs: update API documentation
```

## 🏗️ Code Standards

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format code
- Maximum line length: 80 characters
- Use meaningful variable and function names

### Architecture Guidelines
- Follow the established architecture patterns
- Use Riverpod for state management
- Organize code by feature, not by type
- Keep widgets small and focused
- Use proper error handling

### File Organization
```
lib/
├── constants/      # App constants
├── models/         # Data models
├── providers/      # Riverpod providers
├── routes/         # Navigation
├── screens/        # UI screens
├── services/       # Business logic
└── widgets/        # Reusable widgets
```

## 🧪 Testing

### Test Requirements
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows
- Minimum 80% code coverage

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/auth_service_test.dart
```

### Test Structure
```dart
group('AuthService', () {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
  });

  test('should login successfully with valid credentials', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';

    // Act
    final result = await authService.login(email, password);

    // Assert
    expect(result.isSuccess, isTrue);
  });
});
```

## 📝 Documentation

### Code Documentation
- Document public APIs with dartdoc comments
- Include examples in documentation
- Keep documentation up to date

### README Updates
- Update README.md for significant changes
- Include screenshots for UI changes
- Update installation instructions if needed

## 🔄 Pull Request Process

### Before Submitting
1. Ensure all tests pass: `flutter test`
2. Run static analysis: `flutter analyze`
3. Format code: `dart format .`
4. Update documentation if needed
5. Add/update tests for new functionality

### PR Checklist
- [ ] Code follows project standards
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] PR description is clear and complete

### Review Process
1. Automated checks must pass
2. At least one code review required
3. All feedback addressed
4. Final approval from maintainer

## 🐛 Bug Reports

### Before Reporting
1. Check existing issues
2. Ensure you're using the latest version
3. Try to reproduce the issue

### Bug Report Template
Use the provided bug report template and include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Screenshots/logs if applicable

## 💡 Feature Requests

### Before Requesting
1. Check existing feature requests
2. Ensure it aligns with project goals
3. Consider if it can be implemented as a plugin

### Feature Request Template
Use the provided template and include:
- Clear feature description
- Use cases and benefits
- Proposed implementation approach
- Alternative solutions considered

## 🔒 Security

### Reporting Security Issues
- **DO NOT** create public issues for security vulnerabilities
- Email security concerns to: [your-email@example.com]
- Include detailed description and steps to reproduce

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

## ❓ Questions?

- Open a discussion in GitHub Discussions
- Join our Discord community (if applicable)
- Check the FAQ section in the README

## 🙏 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes for significant contributions
- Project documentation

Thank you for contributing to Tick Tick! 🎉