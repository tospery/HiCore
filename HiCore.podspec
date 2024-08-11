Pod::Spec.new do |s|
  s.name             = 'HiCore'
  s.version          = '1.0.6'
  s.summary          = 'Core module.'
  s.description      = <<-DESC
						Core module using Swift.
                       DESC
  s.homepage         = 'https://github.com/tospery/HiCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YangJianxiang' => 'tospery@gmail.com' }
  s.source           = { :git => 'https://github.com/tospery/HiCore.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.swift_version = '5.3'
  s.ios.deployment_target = '13.0'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
  
  s.source_files = 'HiCore/**/*'
  s.dependency 'HiBase', '~> 1.0'
  s.dependency 'FCUUID', '~> 1.0'
  s.dependency 'DeviceKit', '~> 5.0'
  s.dependency 'SwiftyBeaver', '~> 1.0'
  s.dependency 'SwifterSwift/UIKit', '~> 6.0'
  s.dependency 'SwifterSwift/CoreGraphics', '~> 6.0'
  
end
