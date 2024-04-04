Pod::Spec.new do |s|
  s.name             = 'WidgetCore'
  s.version          = '0.1.0'
  s.summary          = 'WidgetCore pod.'

  s.description      = <<-DESC
WidgetCore contains all desired services to support widget lifecycle.
                       DESC

  s.homepage         = 'https://github.com/Artem Kulikov/WidgetCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Artem Kulikov' => 'koulikovar@gmail.com' }
  s.source           = { :git => 'https://github.com/Artem Kulikov/WidgetCore.git', :tag => s.version.to_s }
  s.ios.deployment_target = '16.0'

  s.source_files = 'WidgetCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WidgetCore' => ['WidgetCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
