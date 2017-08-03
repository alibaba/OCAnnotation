#
# Be sure to run `pod lib lint OCAnnotation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OCAnnotation'
  s.version          = '0.0.2'
  s.summary          = 'A tool enable Objective-C with the feature of annotation'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'OCAnnotation is a lightweighted framework empowering the Objective-C lauguage with the ability of annotation. As in Java, annotation is a form of syntactic metadata that can be added to the source code. It provides a handy way to apply certain behaviours to related program elements, such as class, methods, etc. By embedding this feature, we could make Objective-C a more flexible language, and bring our iOS development work more convinience and possibilities.'

  s.homepage         = 'https://github.com/alibaba/OCAnnotation'

  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache', :file => 'OCAnnotation/LICENSE' }
  s.author           = { 'Ant Financial Wealth Mobile Team' => 'wrshi313@gmail.com'}
  s.source           = { :git => 'https://github.com/alibaba/OCAnnotation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'OCAnnotation/Sources/**/*'
  
  # s.resource_bundles = {
  #   'OCAnnotation' => ['OCAnnotation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
