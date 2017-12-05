#
# Be sure to run `pod lib lint Butterfly.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Butterfly'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Butterfly.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Butterfly is a lightweight and pure Swift implemented library for downloading and cacheing image from the web
                       DESC

  s.homepage         = 'https://github.com/chdzq/Butterfly'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chdzq' => 'zhangqi_248@qq.com' }
  s.source           = { :git => 'https://github.com/chdzq/Butterfly.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = ['Sources/**/*.swift', 'Sources/Classes/**/*.h']
  s.resources = ['Sources/CommonCrypto']

  # s.resource_bundles = {
  #   'Butterfly' => ['Butterfly/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=macosx*]'           => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/macOSX',
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/iPhoneOS',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/iPhoneSimulator',
    'SWIFT_INCLUDE_PATHS[sdk=appletvos*]'        => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/appleTVOS',
    'SWIFT_INCLUDE_PATHS[sdk=appletvsimulator*]' => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/appleTVSimulator',
    'SWIFT_INCLUDE_PATHS[sdk=watchos*]'          => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/watchOS',
    'SWIFT_INCLUDE_PATHS[sdk=watchsimulator*]'   => '$(PODS_ROOT)/Butterfly/Sources/CommonCrypto/watchSimulator',
    'SWIFT_VERSION'                              => '4.0' 
  }

end
