Pod::Spec.new do |s|
  s.name             = "LNRSimpleNotifications"
  s.version          = "0.8.0"
  s.summary          = "Simple Swift in-app notifications."
  s.description      = <<-DESC
                       LNRSimpleNotifications is a simplified Swift port of TSMessages. It's built for developers who want beautiful in-app notifications that can be set up in minutes.
                       DESC
  s.homepage         = "https://github.com/LISNR/LNRSimpleNotifications"
  s.license          = 'MIT'
  s.author           = { "Jon Schneider" => "jon@lisnr.com" }
  s.source           = { :git => "https://github.com/LISNR/LNRSimpleNotifications.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*'

  s.frameworks = 'UIKit', 'AudioToolbox'
end
