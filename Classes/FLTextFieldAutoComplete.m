//
//  FLTextFieldAutoComplete.m
//  TextFealdAutocompleat
//
//  Created by Denis Andreev on 09/03/2018.
//  Copyright © 2018 Denis Andreev. All rights reserved.
//

#import "FLTextFieldAutoComplete.h"

#define LISTCELL @"LISTCELL"

@interface FLTextFieldAutoComplete()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong) NSArray<NSString*> *data;
@property (strong) NSArray<NSString*> *sortedData;

@end


@implementation FLTextFieldAutoComplete
{
	CGPoint viewPositionByRootVC;
	UIView *firstBaselineView;
	UIActivityIndicatorView *activeView;
	
	NSLayoutConstraint *autocompleteListHeightConstraint;
	SetDataBlock loadDataBlock;
}

-(void)awakeFromNib {
	[super awakeFromNib];
	self.delegate = self;
	
	firstBaselineView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForEndEditing:)];
	[tap setCancelsTouchesInView:NO];
	[firstBaselineView addGestureRecognizer:tap];
}

- (void)tapForEndEditing:(UITapGestureRecognizer*)sender {
	UIView* view = sender.view;
	CGPoint locationPoint = [sender locationInView:view];
	
	if(![NSStringFromClass([[view hitTest:locationPoint withEvent:nil] class]) isEqualToString:@"UITableViewCellContentView"]) {
		[self endEditing:YES];
		[self hideAndDestroyAutocompleteList];
	}
}

- (void)setStringsDataArray:(NSArray<NSString*>*)data {
	self.data = data;
}

- (void)setDataByBlock:(SetDataBlock)dataBlock {
	loadDataBlock = dataBlock;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	viewPositionByRootVC = [self.superview convertPoint:self.frame.origin toView:nil];
	
	self.autocompleteList = [[UITableView alloc] initWithFrame:self.bounds
														 style:UITableViewStylePlain];
	if (self.listBackgroundColor == nil) {
		[self.autocompleteList setBackgroundColor: [UIColor whiteColor]];
	} else {
		[self.autocompleteList setBackgroundColor: self.listBackgroundColor];
	}
	
	self.autocompleteList.delegate = self;
	self.autocompleteList.dataSource = self;
	[self.autocompleteList registerClass:[UITableViewCell class] forCellReuseIdentifier:LISTCELL];
	[self.autocompleteList setHidden:YES];
	
	[self.autocompleteList setTranslatesAutoresizingMaskIntoConstraints:NO];
	[firstBaselineView addSubview:self.autocompleteList];
	
	
	autocompleteListHeightConstraint = [NSLayoutConstraint constraintWithItem:self.autocompleteList
																	attribute:NSLayoutAttributeHeight
																	relatedBy:NSLayoutRelationEqual
																	   toItem:nil
																	attribute:NSLayoutAttributeHeight
																   multiplier:1.0
																	 constant:0];
		
	[firstBaselineView addConstraint:autocompleteListHeightConstraint];

	
	[firstBaselineView addConstraint: [NSLayoutConstraint constraintWithItem:self.autocompleteList
																   attribute:NSLayoutAttributeTop
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeBottom
																  multiplier:1.0
																	constant:0]];
	
	[firstBaselineView addConstraint: [NSLayoutConstraint constraintWithItem:self.autocompleteList
																   attribute:NSLayoutAttributeTrailing
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeTrailing
																  multiplier:1.0
																	constant:-3]];
	
	[firstBaselineView addConstraint: [NSLayoutConstraint constraintWithItem:self.autocompleteList
																   attribute:NSLayoutAttributeLeading
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeLeading
																  multiplier:1.0
																	constant:3]];
	
	
	activeView = [[UIActivityIndicatorView alloc] init];
	[activeView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[activeView setHidden:YES];
	[firstBaselineView addSubview:activeView];
	
	
	[firstBaselineView addConstraint: [NSLayoutConstraint constraintWithItem:activeView
																   attribute:NSLayoutAttributeCenterX
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.autocompleteList
																   attribute:NSLayoutAttributeCenterX
																  multiplier:1.0
																	constant:0]];
	
	[firstBaselineView addConstraint: [NSLayoutConstraint constraintWithItem:activeView
																   attribute:NSLayoutAttributeCenterY
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.autocompleteList
																   attribute:NSLayoutAttributeCenterY
																  multiplier:1.0
																	constant:0]];

	return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[self.autocompleteList setHidden:NO];
	NSString *inputText = [NSString stringWithFormat:@"%@%@", textField.text, string];
	
	if (loadDataBlock != nil) {
		if (autocompleteListHeightConstraint.constant == 0) {
			autocompleteListHeightConstraint.constant = 80.0;
		}
		
		[activeView setHidden:NO];
		[activeView startAnimating];
		
		dispatch_async(dispatch_queue_create("com.FLTextFieldAutoComplete", DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
			NSArray *dataFromBlock = loadDataBlock(inputText);
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[activeView setHidden:YES];
				[activeView stopAnimating];
				[self setStringsDataArray:dataFromBlock];
				[self showSortedAutocompleteList:nil];
			});
			
		});
	} else {
		[self showSortedAutocompleteList:inputText];
	}
	
	return YES;
}

- (void)showSortedAutocompleteList:( NSString* _Nullable )value {
	if (value != nil) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", value];
		self.sortedData = [self.data filteredArrayUsingPredicate:predicate];
	} else {
		self.sortedData = self.data;
	}
	
	[self.autocompleteList reloadData];
	autocompleteListHeightConstraint.constant = self.autocompleteList.contentSize.height;
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.sortedData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LISTCELL forIndexPath:indexPath];
	cell.textLabel.text = self.sortedData[indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell.textLabel setTextColor:self.listTextColor];
	[cell setBackgroundColor:[UIColor clearColor]];
	
	if (self.listTextFontSize == 0) {
		[cell.textLabel setFont: self.font];
	} else {
		[cell.textLabel setFont: [UIFont fontWithName:self.font.fontName size:self.listTextFontSize]];
	}
	
	return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	self.text = cell.textLabel.text;
	[self hideAndDestroyAutocompleteList];
}


- (void)hideAndDestroyAutocompleteList {
	[self.autocompleteList setHidden:YES];
	[self endEditing:YES];
	self.autocompleteList = nil;
	self.sortedData = nil;
}

@end
