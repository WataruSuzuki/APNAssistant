platform :ios, "8.0"
#inhibit_all_warnings!
use_frameworks!

target "APNAssistant" do
    pod 'Swifter', '~> 1.4.7'
    pod 'RealmSwift'
    pod 'CMPopTipView'
    pod 'DZNEmptyDataSet'
    pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

target "TodayWidget" do
    inherit! :search_paths
    pod 'Swifter', '~> 1.4.7'
    pod 'RealmSwift'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-APNAssistant/Pods-APNAssistant-acknowledgements.plist', 'APNAssistant/Settings.bundle/Pods-acknowledgements.plist')
end
