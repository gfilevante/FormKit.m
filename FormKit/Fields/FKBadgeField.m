//
// Created by Bruno Wernimont on 2012
// Copyright 2012 FormKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FKBadgeField.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKBadgeField

////////////////////////////////////////////////////////////////////////////////////////////////////
@synthesize textField = _textField;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.customTextFieldClass = [UITextField class];
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCustomTextFieldClass:(Class)customTextFieldClass {
  if (_customTextFieldClass != customTextFieldClass) {
    _customTextFieldClass = customTextFieldClass;
    UIView *view = [[UIView alloc] init];
    _textField = [[self.customTextFieldClass alloc]
        initWithFrame:CGRectMake(0, 0, 250, 30)];
    _textField.rightView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _textField.rightViewMode = UITextFieldViewModeAlways;

    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.text = @"";
    _rightLabel.textAlignment = NSTextAlignmentRight;

    self.textField.textAlignment = NSTextAlignmentRight;
    [view addSubview:_textField];
    [view addSubview:_rightLabel];

    //    self.textField.rightView = _rightLabel;
    //    self.textField.rightViewMode = UITextFieldViewModeAlways;

    [self.textField addTarget:self
                       action:@selector(textFieldDidChangeValue)
             forControlEvents:UIControlEventAllEditingEvents];
    self.valueView = view;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect rect = _textField.frame;
  rect.size.width = self.valueView.frame.size.width - 40;
  _textField.frame = rect;
  rect = _rightLabel.frame;
  rect.origin.x = self.valueView.frame.size.width - 40;
  _rightLabel.frame = rect;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
  [super prepareForReuse];

  self.textField.placeholder = nil;
  self.textField.text = nil;
  self.textField.delegate = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidChangeValue {
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKFieldStyleProtocol

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValueTextAlignment:(NSTextAlignment)valueTextAligment {
  self.textField.textAlignment = valueTextAligment;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValueTextColor:(UIColor *)color {
  self.textField.textColor = color;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorBorderColor:(UIColor *)color {
  self.textField.layer.borderColor = [UIColor redColor].CGColor;
  self.textField.layer.borderWidth = 1.0;
}

@end
