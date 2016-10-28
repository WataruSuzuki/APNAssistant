platform :ios, "7.0"
#inhibit_all_warnings!

target "ApnAssister2" do
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
  pod 'CMPopTipView'
  pod 'Firebase'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Auth'
  pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

target "ApnMemo" do
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
  FileUtils.cp_r('Pods/Target Support Files/Pods-ApnAssister2/Pods-ApnAssister2-acknowledgements.plist', 'ApnAssister/Settings.bundle/Pods-acknowledgements.plist')
end
