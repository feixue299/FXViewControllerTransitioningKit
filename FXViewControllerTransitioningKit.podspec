#
#  Be sure to run `pod spec lint FXViewControllerTransitioningKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "FXViewControllerTransitioningKit"
  spec.version      = "0.1.3"
  spec.summary      = "A FXViewControllerTransitioningKit"
  spec.homepage     = "https://github.com/feixue299/FXViewControllerTransitioningKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "wupengfei" => "1569485690@qq.com" }
  spec.source       = { :git => "https://github.com/feixue299/FXViewControllerTransitioningKit.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/**/*.{h,m}"  
  spec.ios.deployment_target  = '9.0'

end
