#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_google_cast_button'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin whitch provides the cast button and sync cast state with it.'
  s.description      = <<-DESC
A Flutter plugin whitch provides the cast button and sync cast state with it.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true

  s.dependency 'Flutter'
  s.dependency 'google-cast-sdk', '~> 4.3'

  s.ios.deployment_target = '8.0'
end

