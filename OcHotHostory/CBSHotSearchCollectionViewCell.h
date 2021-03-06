//
//  CBSHotSearchCollectionViewCell.h
//  CaiBaoStu
//
//  Created by cb_2018 on 2019/3/28.
//  Copyright © 2019 91cb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CBSHotSeachHearView : UICollectionReusableView
    
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hiddenBottomLine;
@end

@interface CBSHotSearchCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
