Pod::Spec.new do |s|

  s.name         = "CSGrowingTextView"
  s.version      = "1.0.4"
  s.summary      = "CSGrowingTextView is a iOS text view that sizes while user types using keyboard."

  s.description  = <<-DESC
                   * CSGrowingTextView was developed in need for text view that sizes while user types.
                   * It has growing modes so it can resize automatically or leave it to you and is suitable for usage with autolayout.
                   DESC

  s.homepage     = "https://github.com/cloverstudio/CSGrowingTextView"
  
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  s.authors          = { "Clover Developers" => "github@clover-studio.com", "Josip Bernat" => "josip.bernat@gmail.com" }

  s.platform     = :ios, '6.0'
  
  s.source       = { :git => "https://github.com/cloverstudio/CSGrowingTextView.git", :tag => "v1.0.4" }

  s.source_files  = 'CSGrowingTextView/CSGrowingTextView/**/*.{h,m}'

  s.requires_arc = true

end
