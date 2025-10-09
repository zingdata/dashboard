# Task Completion Workflow

## Standard Workflow After Code Changes

When completing a coding task, follow these steps:

### 1. Format Code
```bash
dart format .
```
- Ensures consistent code formatting
- Required before committing
- Applies standard Dart formatting rules

### 2. Analyze Code
```bash
flutter analyze
```
- Runs static analysis and linting
- Must pass with no errors
- Checks against rules in `analysis_options.yaml`
- Based on `package:flutter_lints/flutter.yaml`

### 3. Run Tests
```bash
flutter test
```
- Executes all test files in `test/` directory
- Note: Current test suite is minimal (contains placeholder TODO test)
- Should pass before committing changes

### 4. Manual Testing (if applicable)
```bash
cd example && flutter run -d chrome
```
- Test changes in the example app
- Verify behavior on web, mobile, or desktop as needed
- Check that edit mode, resize, move, and swapping work correctly

## Pre-Commit Checklist

- [ ] Code formatted with `dart format .`
- [ ] No analysis errors from `flutter analyze`
- [ ] All tests passing with `flutter test`
- [ ] Manual testing completed (if UI changes)
- [ ] Documentation updated (if public API changed)
- [ ] Example app updated (if new features added)

## Publishing Workflow

Only needed when releasing a new version to pub.dev:

1. **Update version** in `pubspec.yaml`
2. **Update** `CHANGELOG.md` with changes
3. **Run pre-commit checks** (format, analyze, test)
4. **Dry run publish**: `flutter pub publish --dry-run`
5. **Review output** and fix any issues
6. **Publish**: `flutter pub publish` (requires pub.dev credentials)

## Git Workflow

Current branch structure:
- **Main branch**: `master` (for PRs)
- **Current branch**: May vary (check with `git branch --show-current`)

Typical git flow:
```bash
# After making changes and completing checklist
git add .
git commit -m "Descriptive message"
git push origin <branch-name>
```

## Notes

- **Tests**: The test suite is currently minimal. Consider adding tests when modifying core functionality.
- **Example App**: The example app in `example/` directory is important for demonstrating features.
- **Platform Testing**: Package supports web, mobile (iOS/Android), and desktop. Test on relevant platforms.
- **Breaking Changes**: This is a public package on pub.dev. Avoid breaking API changes when possible.
