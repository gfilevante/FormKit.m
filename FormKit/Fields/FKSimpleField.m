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

#import "FKSimpleField.h"

#import "UITableViewCell+FormKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKSimpleField

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.errorLabel.backgroundColor = [UIColor clearColor];
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.errorLabel];
    self.xMargin = 5;
    self.helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.helpButton
        setImage:[UIImage
                     imageNamed:@"FormKit.bundle/cuentatranferencia_but_error"]
        forState:UIControlStateNormal];
    [self.helpButton addTarget:self
                        action:@selector(showHelp)
              forControlEvents:UIControlEventTouchUpInside];
    [self.helpButton setBackgroundColor:[UIColor clearColor]];
    [self.helpButton setEnabled:YES];
    [self.helpButton setHidden:YES];
    [self.contentView addSubview:self.helpButton];
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
  [super prepareForReuse];

  self.errorLabel.text = nil;
  self.backgroundColor = [UIColor whiteColor];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect textLabelFrame = self.textLabel.frame;
  textLabelFrame.origin.y = 5;
  textLabelFrame.origin.x = self.xMargin;
  self.textLabel.frame = textLabelFrame;

  CGRect detailTextLabelFrame = self.detailTextLabel.frame;
  detailTextLabelFrame.origin.y = 5;
  self.detailTextLabel.frame = detailTextLabelFrame;

  if (nil != self.errorLabel.text) {
    CGFloat errorLabelWidth =
        self.contentView.frame.size.width - self.textLabel.frame.origin.x * 2;

    CGSize stringSize =
        [self.errorLabel.text sizeWithFont:self.errorLabel.font
                         constrainedToSize:CGSizeMake(errorLabelWidth, 5000)
                             lineBreakMode:self.errorLabel.lineBreakMode];

    self.errorLabel.frame = CGRectMake(
        self.textLabel.frame.origin.x,
        self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 10,
        errorLabelWidth, stringSize.height);
    [self.helpButton setHidden:NO];
    self.helpButton.frame = CGRectMake(self.frame.size.width - 30, 0, 26, 26);
  }
}

- (void)createHelpView {
  self.helpView = [[UIView alloc] init];

  // sets the alpha to 1.0
  [self.helpView setAlpha:1.0];

  // calculates the point depending on the objectview of the formobject

  // sets the frame for the current Form Object
  CGRect frame = [self.contentView
      convertRect:CGRectMake(40, self.textLabel.frame.origin.y + 20, 227, 115)
           toView:self.superview];
  [self.helpView setFrame:frame];
  [self.helpView setBackgroundColor:[UIColor clearColor]];

  // sets the background image
  UIImage *image = [UIImage imageNamed:@"FormKit.bundle/comun_popover_error"];
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
  [self.helpView addSubview:backgroundView];

  // sets the text for the title of the help
  UILabel *helpTitleLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(7, 13, 210, 20)];
  [helpTitleLabel setTextColor:[UIColor whiteColor]];
  [helpTitleLabel setNumberOfLines:1];

  [helpTitleLabel setText:@"Error"];

  [self.helpView addSubview:helpTitleLabel];

  // sets the text for the help
  self.helpTextLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(6, 34, 220, 50)];
  [self.helpTextLabel setFont:[UIFont systemFontOfSize:14]];
  [self.helpTextLabel setNumberOfLines:0];

  [self.helpView addSubview:self.helpTextLabel];

  UIButton *closeButton = [[UIButton alloc]
      initWithFrame:CGRectMake(10, 10, self.helpView.frame.size.width,
                               self.helpView.frame.size.height)];
  [closeButton setBackgroundColor:[UIColor clearColor]];
  [closeButton addTarget:self
                  action:@selector(dismissErrorPopover)
        forControlEvents:UIControlEventTouchUpInside];
  [self.helpView addSubview:closeButton];

  [self.superview addSubview:self.helpView];
}

- (void)showHelp {
  if (!self.helpView) {
    [self createHelpView];
  }
  self.helpTextLabel.text = self.errorLabel.text;
  self.helpView.alpha = 1;
}

// Function that dismisses the popover
- (void)dismissErrorPopover {

  if (self.helpView != nil) {
    [UIView animateWithDuration:0.2
                     animations:^{ [self.helpView setAlpha:0.0]; }];
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKFieldErrorProtocol

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addError:(NSString *)error {
  self.errorLabel.text = error;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)errorHeightWithError:(NSString *)error
                      tableView:(UITableView *)tableView {
  static CGFloat contentViewWidth = 0;
  static UIFont *errorLabelFont = nil;
#ifdef __IPHONE_6_0
  static NSLineBreakMode errorLabelLineBreakMode = 0;
#else
  static UILineBreakMode errorLabelLineBreakMode = 0;
#endif

  if (0 == contentViewWidth) {
    FKSimpleField<FKFieldErrorProtocol> *cell =
        [self fk_cellForTableView:tableView configureCell:nil];
    contentViewWidth =
        cell.contentView.frame.size.width - cell.textLabel.frame.origin.x * 2;

    errorLabelFont = cell.errorLabel.font;
    errorLabelLineBreakMode = cell.errorLabel.lineBreakMode;
  }

  CGSize stringSize = [error sizeWithFont:errorLabelFont
                        constrainedToSize:CGSizeMake(contentViewWidth, 5000)
                            lineBreakMode:errorLabelLineBreakMode];

  return stringSize.height + 10;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorTextColor:(UIColor *)color {
  self.errorLabel.textColor = color;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorBackgroundColor:(UIColor *)color {
  self.backgroundColor = color;
  self.contentView.backgroundColor = color;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorBorderColor:(UIColor *)color {
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKFieldStyleProtocol

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLabelTextColor:(UIColor *)color {
  self.textLabel.textColor = color;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValueTextColor:(UIColor *)color {
  self.detailTextLabel.textColor = color;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
  self.textLabel.textAlignment = textAlignment;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValueTextAlignment:(NSTextAlignment)valueTextAlignment {
  self.detailTextLabel.textAlignment = valueTextAlignment;
}

@end
