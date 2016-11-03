platform :ios, "7.0"
inhibit_all_warnings!

target "APNAssistant" do
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
  pod 'CMPopTipView'
  pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

target "APNAssistantLite" do
  inherit! :search_paths
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
  pod 'CMPopTipView'
  pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

target "TodayWidget" do
  inherit! :search_paths
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-APNAssistant/Pods-APNAssistant-acknowledgements.plist', 'APNAssistant/Settings.bundle/Pods-acknowledgements.plist')
end
