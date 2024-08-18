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
pod 'Kingfisher'

end
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
