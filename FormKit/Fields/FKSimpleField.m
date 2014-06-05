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
  textLabelFrame.origin.y = 0;
  textLabelFrame.origin.x = self.xMargin;
  self.textLabel.frame = textLabelFrame;

  CGRect detailTextLabelFrame = self.detailTextLabel.frame;
  detailTextLabelFrame.origin.y = 0;
  self.detailTextLabel.frame = detailTextLabelFrame;

  if (nil != self.errorLabel.text && self.errorLabel.text.length > 0) {
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
  } else {
    [self.helpButton setHidden:YES];
  }
}

- (void)createHelpView {
  self.helpView = [[UIView alloc] init];

  // sets the alpha to 1.0
  [self.helpView setAlpha:1.0];

  // calculates the point depending on the objectview of the formobject

  // sets the frame for the current Form Object
  CGRect frame = [self.contentView
      convertRect:CGRectMake(self.textLabel.frame.origin.x,
                             self.textLabel.frame.origin.y + 30, 227, 115)
           toView:self.superview];
  [self.helpView setFrame:frame];
  [self.helpView setBackgroundColor:[UIColor clearColor]];

  // sets the background image
  UIImage *image = [UIImage imageNamed:@"FormKit.bundle/comun_popover_error"];
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
  [self.helpView addSubview:backgroundView];

  // sets the text for the title of the help
  self.helpTitleLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(7, 13, 210, 20)];
  [self.helpTitleLabel setTextColor:[UIColor whiteColor]];
  [self.helpTitleLabel setNumberOfLines:1];

  [self.helpTitleLabel setText:@"Error"];
  self.helpTitleLabel.backgroundColor = [UIColor clearColor];

  [self.helpView addSubview:self.helpTitleLabel];

  // sets the text for the help
  self.helpTextLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(5, 28, 235, 60)];
  [self.helpTextLabel setNumberOfLines:0];

  // sets default font if exists
  if ([UILabel appearance].font) {
    [self.helpTitleLabel setFont:[[UILabel appearance].font fontWithSize:13]];
    [self.helpTextLabel setFont:[[UILabel appearance].font fontWithSize:12]];
  } else {
    [self.helpTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.helpTextLabel setFont:[UIFont systemFontOfSize:14]];
  }
  [self.helpView addSubview:self.helpTextLabel];

  self.closeButton = [[UIButton alloc]
      initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width,
                               self.superview.frame.size.height)];
  [self.closeButton setBackgroundColor:[UIColor clearColor]];
  [self.closeButton addTarget:self
                       action:@selector(dismissErrorPopover)
             forControlEvents:UIControlEventTouchUpInside];
  self.closeButton.hidden = YES;

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissErrorPopover)];
  [self.helpView addGestureRecognizer:tapGesture];

  [self.superview addSubview:self.closeButton];

  [self.superview addSubview:self.helpView];
}

- (void)showHelp {
  if (!self.helpView) {
    [self createHelpView];
  }
  self.helpTextLabel.text = self.helpText;
  self.helpTitleLabel.text = self.helpTitle;
  self.helpView.alpha = 1;
  self.closeButton.hidden = NO;
}

// Function that dismisses the popover
- (void)dismissErrorPopover {

  if (self.helpView != nil) {
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.helpView setAlpha:0.0];
                         self.closeButton.hidden = YES;
                     }];
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKFieldErrorProtocol

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addError:(NSString *)error withTitle:(NSString *)title {

  self.errorLabel.text = error;
  self.helpText = error;
  self.helpTitle = title;
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
