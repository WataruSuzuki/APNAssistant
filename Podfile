platform :ios, "7.0"
inhibit_all_warnings!

target "ApnAssister" do
  pod 'CocoaAsyncSocket'
  pod 'CocoaHTTPServer'
  pod 'Realm'
  pod 'CMPopTipView'
  pod 'DJKFlatIconAuthors', :git => 'https://github.com/WataruSuzuki/DJKFlatIconAuthors.git'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-ApnAssister/Pods-ApnAssister-acknowledgements.plist', 'ApnAssister/Settings.bundle/Pods-acknowledgements.plist')
end
