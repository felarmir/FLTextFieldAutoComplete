//
//  ContactInfoView.h
//  FLTextFieldAutoCompleteExample
//
//  Created by Denis Andreev on 11/03/2018.
//  Copyright © 2018 Denis Andreev. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FLTextFieldAutoComplete;

@interface ContactInfoView : UIView

@property (weak, nonatomic) IBOutlet FLTextFieldAutoComplete* citylist;
@property (weak, nonatomic) IBOutlet FLTextFieldAutoComplete* cityListByBlock;

@end
