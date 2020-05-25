Pod::Spec.new do |s|
  s.name             = 'SCMediaBrowser'
  s.version          = '1.0.1'
  s.summary          = 'SCMediaBrowser.'
  s.homepage         = 'https://github.com/Samueler/SCMediaBrowser.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ty.chen' => 'samueler.chen@gmail.com' }
  s.source           = { :git => 'https://github.com/Samueler/SCMediaBrowser.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SCMediaBrowser/Classes/**/*'
  s.resource = 'SCMediaBrowser/Assets/SCMediaBrowser.bundle'
  
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'SCResponderChainPass', '~> 1.1.0'
  s.dependency 'SCAVPlayer', '1.0.2'
  
end
