Pod::Spec.new do |s|
  s.name         = "NSObject+YOLO"
  s.version      = "0.1"
  s.summary      = "Make method swizzling so much easier to use."
  s.homepage     = "http://github.com/neonichu/NSObject-YOLO/"

  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  
  s.authors      = { "Boris Bügling" => "boris@buegling.com" }
  s.source       = { :git => "https://github.com/neonichu/NSObject-YOLO.git", 
                     :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'NSObject+YOLO.{h,m}'
end
