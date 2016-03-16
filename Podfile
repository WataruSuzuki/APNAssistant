platform :ios, "6.0"
pod 'CocoaAsyncSocket'
pod 'CocoaHTTPServer'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'ApnAssister/Settings.bundle/Pods-acknowledgements.plist')
end
