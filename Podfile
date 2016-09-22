platform :ios, "7.0"
inhibit_all_warnings!

target "ApnBookmarks" do
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
  pod 'CMPopTipView'
  pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

target "TodayWidget" do
  #use_frameworks!
  inherit! :search_paths
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-ApnBookmarks/Pods-ApnBookmarks-acknowledgements.plist', 'ApnBookmarks/Settings.bundle/Pods-acknowledgements.plist')
end
