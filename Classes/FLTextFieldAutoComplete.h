//
//  FLTextFieldAutoComplete.h
//  TextFealdAutocompleat
//
//  Created by Denis Andreev on 09/03/2018.
//  Copyright © 2018 Denis Andreev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray* (^SetDataBlock)(NSString* inputValue);

@interface FLTextFieldAutoComplete : UITextField


/**
 Autocomplete list table
 */
@property (strong, nonatomic) UITableView *autocompleteList;

/**
 Autocomplete list Text size
 */
@property IBInspectable NSInteger listTextFontSize;

/**
 Autocomplete list Text label color
 */
@property IBInspectable UIColor *listTextColor;


/**
  Autocomplete list background color
 */
@property IBInspectable UIColor *listBackgroundColor;



/**
 Set data Array for autocomplete

 @param data NSArray contains NSStrings
 */
- (void)setStringsDataArray:(NSArray<NSString*>*)data;


/**
 Set data by changing fir load from remote data source

 @param dataBlock Block 
 */
- (void)setDataByBlock:(SetDataBlock)dataBlock;

@end
