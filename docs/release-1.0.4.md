# JGAlert 1.0.4 Release Checklist

## Suggested Release Notes

`1.0.4` focuses on presentation and distribution improvements for the open source release.

- refreshed README with clearer positioning around popup queueing and priority scheduling
- added Swift Package Manager support
- improved the repository demo GIF for GitHub presentation
- updated CocoaPods metadata for better discoverability

## Recommended Release Steps

Run these commands from the repository root:

```bash
git add README.md Package.swift JGAlert.podspec .gitignore docs/release-1.0.4.md demo.gif scripts/generate_demo_gif.swift
git commit -m "Prepare 1.0.4 release"
git tag 1.0.4
git push origin main --tags
pod trunk push JGAlert.podspec --allow-warnings
```

## Notes

- `JGAlert.podspec` is now explicitly unignored in the repository via `.gitignore`.
- The tracked Xcode user state file is unrelated to the release and can be left out of the commit.
