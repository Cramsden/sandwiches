workspace 'sandwiches'
project 'sandwiches.xcodeproj'
platform :ios, '9.3'
use_frameworks!

def testing_pods
  pod 'Quick'
  pod 'Nimble'
end

def sammy_pods
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON', '~> 3.0.0'
  pod 'SwiftLint'
end

target 'sandwiches' do
  sammy_pods
end

target 'sandwichesTests' do
  testing_pods
  sammy_pods
end
