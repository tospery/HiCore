Pod::Spec.new do |s|
  s.name             = 'HiCore'
  s.version          = '1.0.0'
  s.summary          = 'Core function.'
  s.description      = <<-DESC
						Core function using Swift.
                       DESC
  s.homepage         = 'https://github.com/tospery/HiCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YangJianxiang' => 'tospery@gmail.com' }
  s.source           = { :git => 'https://github.com/tospery/HiCore.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.swift_version = '5.3'
  s.ios.deployment_target = '13.0'
  s.frameworks = 'Foundation'
  
  s.source_files = 'HiCore/**/*'
  s.dependency 'FCUUID', '1.3.1'
  s.dependency 'DeviceKit', '5.2.3'
  s.dependency 'SwiftyBeaver', '1.9.5'
  s.dependency 'ObjectMapper', '4.4.2'
  s.dependency 'SwifterSwift', '6.0.0'
  
end
