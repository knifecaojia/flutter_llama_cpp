# Contributing to LLaMA CPP Flutter

Thank you for your interest in contributing to LLaMA CPP Flutter! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues

1. **Search existing issues** first to avoid duplicates
2. **Use the issue template** to provide necessary information
3. **Include relevant details**:
   - Device model and Android version
   - Flutter version
   - Model files being used
   - Steps to reproduce the issue
   - Expected vs actual behavior

### Submitting Pull Requests

1. **Fork the repository** and create a new branch from `main`
2. **Follow the naming convention**: `feature/description` or `fix/description`
3. **Make your changes** with clear, focused commits
4. **Test thoroughly** on different devices and Android versions
5. **Update documentation** if needed
6. **Submit a pull request** with a clear description

### Development Setup

1. Install Flutter SDK (3.0+)
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/llama-cpp-flutter.git`
3. Install dependencies: `flutter pub get`
4. Create a new branch: `git checkout -b feature/your-feature`

## 📝 Code Guidelines

### Code Style

- Follow [Dart style guidelines](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small
- Use proper error handling

### Flutter Best Practices

- Use `const` constructors where possible
- Implement proper resource disposal in `dispose()` methods
- Handle async operations safely (check `mounted` before using `BuildContext`)
- Use `setState()` appropriately for UI updates

### Performance Considerations

- Test on lower-end devices
- Monitor memory usage during inference
- Optimize image processing and compression
- Use isolates for heavy computations

## 🧪 Testing

### Required Testing

- Test on multiple Android devices (different screen sizes, RAM, CPU)
- Verify with different model sizes and formats
- Test edge cases (large images, corrupted files, etc.)
- Check memory usage and performance

### Test Checklist

- [ ] App launches successfully
- [ ] File selection works for all file types
- [ ] Image compression functions correctly
- [ ] Inference runs without crashes
- [ ] Real-time streaming works
- [ ] Error handling displays appropriate messages
- [ ] UI remains responsive during inference

## 📋 Commit Message Format

Use clear, descriptive commit messages:

```
type(scope): description

Examples:
feat(ui): add file selection buttons
fix(compression): resolve image quality issues
docs(readme): update installation instructions
perf(inference): optimize model loading
```

Types:
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests

## 🎯 Areas for Contribution

### High Priority

- iOS support
- Performance optimizations
- Better error handling
- Model format support expansion
- UI/UX improvements

### Medium Priority

- Batch image processing
- Voice input support
- Model downloading interface
- Configuration export/import
- Accessibility improvements

### Low Priority

- Additional languages support
- Advanced model parameters UI
- Performance benchmarking tools
- Integration tests

## 🐛 Bug Reports

When reporting bugs, please include:

- **Environment**: Device model, Android version, Flutter version
- **Steps to reproduce**: Clear, numbered steps
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Screenshots/logs**: If applicable
- **Model information**: Model size, format, source

## 💡 Feature Requests

For feature requests:

- **Use case**: Why is this feature needed?
- **Description**: Detailed description of the feature
- **Examples**: Similar implementations or mockups
- **Priority**: High/Medium/Low based on impact

## 📚 Documentation

Help improve documentation by:

- Fixing typos and grammar
- Adding missing information
- Creating tutorials and guides
- Translating to other languages
- Adding code examples

## 🌟 Recognition

Contributors will be recognized in:

- README acknowledgments
- Release notes
- Contributor list
- Special recognition for significant contributions

## 🔄 Review Process

1. **Automated checks**: Code passes linting and formatting
2. **Manual review**: Maintainers review code quality and functionality
3. **Testing**: Changes are tested on multiple devices
4. **Feedback**: Constructive feedback provided for improvements
5. **Merge**: Approved changes are merged to main branch

## 📞 Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For general questions and ideas
- **Code Review**: Ask for feedback on your changes

## 🎉 Thank You

Every contribution, no matter how small, is valuable to the project. Thank you for helping make LLaMA CPP Flutter better for everyone!

---

Happy coding! 🚀