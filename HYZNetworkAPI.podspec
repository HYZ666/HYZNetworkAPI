
Pod::Spec.new do |spec|
  spec.name         = "HYZNetworkAPI"
  spec.version      = "0.0.3"
  spec.summary      = "HYZNetworkAPI是一个对AFNetworking进行简单二次封装的网络请求框架"
  spec.homepage     = "https://github.com/HYZ666/HYZNetworkAPI"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "huangyizhe" => "839926066@qq.com" }
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/HYZ666/HYZNetworkAPI.git", :tag => spec.version.to_s }
  spec.source_files  = "HYZNetworkAPI/Core/*.{h,m}"
  spec.dependency "AFNetworking", "~> 4.0.1"
  
end
