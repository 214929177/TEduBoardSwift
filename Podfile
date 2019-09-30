# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'EDU' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  # Pods for EDU
  pod 'TEduBoard_iOS', '2.3.4'
  pod 'TXIMSDK_iOS', '4.5.45'
  pod 'TXLiteAVSDK_TRTC', '6.6.7460'
  pod 'coswift'
  pod 'SwiftMessages'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'SnapKit'
  
  #  -- start 腾讯IMKit --
  pod 'ISVImageScrollView'
  pod 'ReactiveObjC'
  pod 'MMLayout'
  pod 'SDWebImage'
  pod 'Toast'

  target 'EDUTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end
end

#git clone https://github.com/tencentyun/TIC.git /var/folders/dq/1gz9r_294w3fh6n_086kfk_80000gn/T/d20190929-16125-1cknvnw --template= --single-branch --depth 1 --branch 2.3.4 --verbose
