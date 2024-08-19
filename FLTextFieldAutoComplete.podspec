Pod::Spec.new do |s|

  s.name         = 'FLTextFieldAutoComplete'
  s.version      = '0.1.0'
  s.summary      = 'FLTextFieldAutoComplete extends UITextField allowing you to add the autocomplete feature in a really easy way.'
  s.description  = <<-DESC

Even though creating the autocomplete feature over a UITextField is not a big issue, dealing with screen rotation, keyboard position, the look and feel, etc, makes this task harder than expected.
    The idea behind FLTextFieldAutoComplete is to help you adding this feature in just a few lines of code.

                   DESC

  s.homepage     = 'https://github.com/felarmir/FLTextFieldAutoComplete'
  s.license      = {type: 'MIT', file: 'LICENSE'}
  s.author             = { "Denis Andreev" => "felarmir@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/felarmir/FLTextFieldAutoComplete.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/*.{h,m}"
  s.public_header_files = "Classes/*.h"
  s.framework  = "Foundation"
  s.requires_arc = true
end
