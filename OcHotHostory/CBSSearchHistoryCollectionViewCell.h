//
//  CBSSearchHistoryCollectionViewCell.h
//  CaiBaoStu
//
//  Created by cb_2018 on 2019/3/29.
//  Copyright © 2019 91cb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBSSearchHistoryCollectionViewCell;
NS_ASSUME_NONNULL_BEGIN
@protocol CBSSearchHistoryCollectionViewCellDelegate <NSObject>

- (void)clickDeleterBtnWithCell:(CBSSearchHistoryCollectionViewCell*)cell;

@end

@interface CBSSearchHistoryCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)id<CBSSearchHistoryCollectionViewCellDelegate> delegate;
/**
 内容
 */
@property(nonatomic,copy)NSString *contentStr;

/**
 清除单元格 和 普通单元格区分mark
 */
@property(nonatomic,assign)BOOL isBottomCell;
@end

NS_ASSUME_NONNULL_END
