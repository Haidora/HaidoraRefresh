Pod::Spec.new do |s|
  s.name             = "HaidoraRefresh"
  s.version          = "0.1"
  s.summary          = "A general of refresh."
  s.description      = <<-DESC
                       DESC
  s.homepage         = "https://github.com/Haidora/HaidoraRefresh"
  s.license          = 'MIT'
  s.author           = { "mrdaios" => "mrdaios@gmail.com" }
  s.source           = { :git => "https://github.com/Haidora/HaidoraRefresh.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'HaidoraRefresh' => ['Pod/Assets/*']
  }
  s.frameworks = 'UIKit', 'Foundation'
  
end
