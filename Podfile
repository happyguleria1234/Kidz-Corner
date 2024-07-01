# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KidzCorner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KidzCorner
pod 'DropDown' , '2.3.13'
pod 'SDWebImage' , '5.2.2'
pod 'YPImagePicker'
pod 'IQKeyboardManagerSwift'
pod 'ReachabilitySwift'
pod 'SwipeCellKit'
pod 'FSCalendar'
pod 'Socket.IO-Client-Swift', '~> 16.0.1'
pod 'Firebase/Messaging'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
