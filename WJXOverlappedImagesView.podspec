Pod::Spec.new do |spec|

  spec.name         = "WJXOverlappedImagesView"
  spec.version      = "0.0.1"
  spec.summary      = "WJXOverlappedImagesView is made up of a group of round-cornered image views whitch over lapped on each other with some distance.."

  spec.description  = <<-DESC
  WJXOverlappedImagesView is a very simple and common view made up of a group of round-cornered image views whitch over lapped on each other with some distance..
                   DESC

  spec.homepage     = "https://github.com/wjiuxing/WJXOverlappedImagesView"
  spec.screenshots  = "https://raw.githubusercontent.com/wjiuxing/WJXOverlappedImagesView/master/DemoPictures/overlapped-images-view.gif"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author		= { "Amos King" => "wangjiuxing2010@hotmail.com" }

  spec.platform     = :ios
  spec.platform     = :ios, "8.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/wjiuxing/WJXOverlappedImagesView.git", :tag => "#{spec.version}" }

  spec.source_files = "Classes", "WJXOverlappedImagesView/**/*.swift"

  spec.resource		= "WJXOverlappedImagesView/WJXOverlappedImagesViewResource.bundle"

  spec.swift_version = "5.0"

end

