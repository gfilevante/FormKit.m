//
//  FKFieldStyleProtocol.h
//  FormKitDemo
//
//  Created by cesar4 on 27/02/14.
//
//

#import <Foundation/Foundation.h>

@protocol FKFieldStyleProtocol <NSObject>

@optional

- (void)setLabelWidth:(CGFloat)width;

- (void)setValueTextWidth:(CGFloat)width;

- (void)hideLabel;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;

- (void)setValueTextAlignment:(NSTextAlignment)valueTextAlignment;

- (void)setLabelTextColor:(UIColor *)color;

- (void)setValueTextColor:(UIColor *)color;

@end
