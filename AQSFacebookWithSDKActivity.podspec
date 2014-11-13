Pod::Spec.new do |s|
  s.name         = "AQSFacebookWithSDKActivity"
  s.version      = "0.1.0"
  s.summary      = "[iOS] UIActivity Class for Facebook using SDK"
  s.homepage     = "https://github.com/AquaSupport/AQSFacebookWithSDKActivity"
  s.license      = "MIT"
  s.author       = { "kaiinui" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AquaSupport/AQSFacebookWithSDKActivity.git", :tag => "v0.1.0" }
  s.source_files  = "AQSFacebookWithSDKActivity/Classes/**/*.{h,m}"
  s.resources = ["AQSFacebookWithSDKActivity/Classes/**/*.png"]
  s.requires_arc = true
  s.platform = "ios", '7.0'

  s.dependency 'Facebook-iOS-SDK'
end
