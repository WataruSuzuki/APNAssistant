VERSION="latest"

if [ $# -eq 1 ]; then
    VERSION="$1"
fi

function exe_fast_lane() {
    fastlane "tests_$VERSION"
}

# CocoaPods
  # run: |
pod install --repo-update

# Change xcode version
  # run: |
# sudo xcode-select -s '/Applications/Xcode_11.1.app/Contents/Developer'

# Check environment
  # run: |
xcodebuild -version
xcrun xctrace list devices

# Run XCTest and XCUITest
  # run: |
exe_fast_lane
