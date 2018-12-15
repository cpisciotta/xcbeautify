Pod::Spec.new do |s|
  s.name           = 'xcbeautify'
  s.version        = '0.3.6'
  s.summary        = 'A little beautifier tool for xcodebuild'
  s.homepage       = 'https://github.com/thii/xcbeautify'
  s.source         = { :http => "#{s.homepage}/releases/download/#{s.version}/xcbeautify-#{s.version}-x86_64-apple-macosx10.10.zip" }
  s.ios.deployment_target = '0.0'
  s.osx.deployment_target = '10.6'
  s.tvos.deployment_target = '9.0'
  s.preserve_paths = '*'
  s.authors        = 'Thi Doãn'
  s.license        = { :type => 'MIT' }
end
