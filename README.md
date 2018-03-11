# FLTextFieldAutoComplete

## Requirements

- iOS 9.0+
- Xcode 8.2

## Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Swift and Objective-C projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

Depending on your Deployment Target, specify the following in your Podfile:

### Deployment Target: iOS 9.0+

```ruby
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

pod 'FLTextFieldAutoComplete'
```

After editing your Podfile, run the following command:

```bash
$ pod install
```

## Usage

```objc

@import FLTextFieldAutoComplete;
...
@property (weak, nonatomic) IBOutlet FLTextFieldAutoComplete* сompleteField;
...

// Array as data
[self.сompleteField setStringsDataArray:<data array>];
	
// or block 
[self.сompleteField setDataByBlock:^NSArray *(NSString *inputValue) {
	// some code and return result
}];


```


## License

FLTextFieldAutoComplete is available under the MIT license. See the [LICENSE](https://github.com/felarmir/FLTextFieldAutoComplete/blob/master/LICENSE) file for more info.
