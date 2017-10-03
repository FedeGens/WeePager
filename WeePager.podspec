Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "WeePager"
s.summary = "WeePager is a weeeeee pager."
s.requires_arc = true

# 2
s.version = "0.0.39"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Federico Gentile" => "fgentile95dev@icloud.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/FedeGens/WeePager"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/FedeGens/WeePager.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"

# 8
s.source_files = "WeePager/*.{swift}"

# 9
#s.resources = "WeePager/**/*.{png,jpeg,jpg,storyboard,xib}"
end
