platform :ios, "10.0"
#inhibit_all_warnings!
use_frameworks!

target "APNAssistant" do
    pod 'Swifter'
    pod 'RealmSwift'
    pod 'DZNEmptyDataSet'
    pod 'FTLinearActivityIndicator'
    pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

target "TodayWidget" do
    inherit! :search_paths
    pod 'Swifter'
    pod 'RealmSwift'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-APNAssistant/Pods-APNAssistant-acknowledgements.plist', 'APNAssistant/Settings.bundle/Pods-acknowledgements.plist')
end
