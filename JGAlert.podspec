Pod::Spec.new do |spec|

  spec.name         = "JGAlert"
  spec.version      = "1.0.4"
  spec.summary      = "An iOS alert scheduler and popup queue manager."

  spec.description  = <<-DESC
  JGAlert helps iOS apps manage multiple alerts, action sheets, onboarding modals,
  upgrade prompts, and risk dialogs with queueing, priority-based scheduling,
  custom transitions, auto dismiss, and drag-to-dismiss support.
  DESC

  spec.homepage     = "https://github.com/JanyGee/JGAlert"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = "JanyGee"

  spec.ios.deployment_target = "13.0"
  spec.source       = { :git => "https://github.com/JanyGee/JGAlert.git", :tag => "#{spec.version}" }

  spec.swift_version = "5.0"
  spec.frameworks   = "UIKit"
  spec.source_files = "Source/**/*.swift"

end
