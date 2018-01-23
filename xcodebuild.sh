xcodebuild test -workspace APNAssistant.xcworkspace -scheme APNAssistant -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 5s,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=10.3.1' \
    -destination 'platform=iOS Simulator,name=iPhone 7 Plus' \
    -destination 'platform=iOS Simulator,name=iPhone X,OS=11.2' \
    -destination 'platform=iOS Simulator,name=iPad Air 2,OS=10.3.1' \
    -destination 'platform=iOS Simulator,name=iPad Pro (10.5-inch),OS=11.2' \
