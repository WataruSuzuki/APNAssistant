platform :ios, "7.0"
inhibit_all_warnings!

pod 'CocoaAsyncSocket'
pod 'CocoaHTTPServer'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'ApnAssister/Settings.bundle/Pods-acknowledgements.plist')
end
