#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint cortex.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'cortex'
  s.version          = '0.0.8'
  s.summary          = 'A flutter plugin for Cortex mobile library.'
  s.description      = <<-DESC
A flutter plugin for Cortex mobile library.
                       DESC
  s.homepage         = 'https://github.com/Emotiv/flutter-plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Emotiv Inc' => 'hello@emotiv.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.ios.deployment_target = '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
