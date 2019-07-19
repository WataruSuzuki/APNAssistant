VERSION="latest"

function exe_fast_lane() {
    fastlane "tests_$1"
}

# CocoaPods
  # run: |
pod install --repo-update

# Change xcode version
  # run: |
sudo xcode-select -s '/Applications/Xcode_11.app/Contents/Developer'

# Check environment
  # run: |
xcodebuild -version
instruments -s device

# Run XCTest and XCUITest
  # run: |
exe_fast_lane ${VERSION}
