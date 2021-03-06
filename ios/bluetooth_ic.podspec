#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'bluetooth_ic'
  s.version          = '0.0.1'
  s.summary          = 'bluetooth plugin'
  s.description      = <<-DESC
bluetooth plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.preserve_paths = 'ICDeviceManager.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework ICDeviceManager' }
  s.vendored_frameworks = 'ICDeviceManager.framework'
  s.ios.deployment_target = '8.0'
end

