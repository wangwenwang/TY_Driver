//
//  UITableView+NoDataPrompt.h
//  newDriver
//
//  Created by 凯东源 on 16/12/19.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoDataPrompt)

- (void)noOrder:(NSString *)title;

//隐藏提示
- (void)removeNoOrderPrompt;

@end
