//
//  CBSSearchHistoryCollectionViewCell.m
//  CaiBaoStu
//
//  Created by cb_2018 on 2019/3/29.
//  Copyright © 2019 91cb. All rights reserved.
//

#import "CBSSearchHistoryCollectionViewCell.h"

@interface CBSSearchHistoryCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIButton *deleterBtn;
@end

@implementation CBSSearchHistoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIsBottomCell:(BOOL)isBottomCell {
    
    _isBottomCell = isBottomCell;
    
    if (self.isBottomCell == YES) {
        self.iconImageView.hidden = YES;
        self.deleterBtn.hidden = YES;
        self.contentLable.text = @"清除搜索历史";
        self.contentLable.textColor = [UIColor blackColor];
        self.contentLable.textAlignment = NSTextAlignmentCenter;
    }else{
        self.iconImageView.hidden = NO;
        self.deleterBtn.hidden = NO;
        self.contentLable.textColor = [UIColor blackColor];
        self.contentLable.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setContentStr:(NSString *)contentStr {
    
    _contentStr = contentStr;
    self.contentLable.text = contentStr;
}
@end
