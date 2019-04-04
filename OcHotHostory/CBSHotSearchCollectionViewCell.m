//
//  CBSHotSearchCollectionViewCell.m
//  CaiBaoStu
//
//  Created by cb_2018 on 2019/3/28.
//  Copyright © 2019 91cb. All rights reserved.
//

#import "CBSHotSearchCollectionViewCell.h"
@interface CBSHotSeachHearView()
    
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation CBSHotSeachHearView
    
- (UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = SQFont(14);
        _titleLable.textColor = [ToolUtils getColor:@"999999"];
    }
    return _titleLable;
}
- (UIView *)bottomLineView{
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [ToolUtils getColor:@"e5e5e5"];
    }
    return _bottomLineView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (instancetype)init{
	if (self = [super init]) {
		[self setUpUI];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    [self addSubview:self.titleLable];
	[self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.mas_left).offset(12.5f);
		make.centerY.mas_equalTo(self.mas_centerY);
	}];
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

    
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLable.text = title;
}
- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine{
    _hiddenBottomLine = hiddenBottomLine;
    self.bottomLineView.hidden = hiddenBottomLine;
}
@end

@interface CBSHotSearchCollectionViewCell()
@property (nonatomic, strong) UILabel *titleLable;
@end

@implementation CBSHotSearchCollectionViewCell

- (UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = SQFont(14);
        _titleLable.textColor = [ToolUtils getColor:@"999999"];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    [self.contentView addSubview:self.titleLable];
}
    
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLable.text = title;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}
@end
