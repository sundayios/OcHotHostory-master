//
//  CBSBoutiqueClassSearchViewController.m
//  CaiBaoStu
//
//  Created by cb_2018 on 2019/3/28.
//  Copyright © 2019 91cb. All rights reserved.
//  搜索界面

// 根据屏幕尺寸判断是否 iPhone X
#define JudgePhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航条高度
#define kNavBarHeight 44.0

// 状态栏+导航条
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#import "NSString+StringSize.h"

#import "CBSBoutiqueClassSearchViewController.h"
#import "CBSSearchHistoryCollectionViewCell.h"
#import "CBSHotSearchCollectionViewCell.h"
#import "CBSLeftAliginFlowLayout.h"

@interface CBSBoutiqueClassSearchViewController ()<UITextFieldDelegate,CBSSearchHistoryCollectionViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 1.头部搜索视图
 */
@property(nonatomic,weak)UIView *headerSearchView;
/**
 搜索输入框
 */
@property(nonatomic,weak)UITextField *inputTextField;
/**
 清空搜索框 x
 */
@property(nonatomic,weak)UIButton *clearSearchBarBtn;

/**
 2.热门搜索
 */
@property(nonatomic,strong)UICollectionView *hotSearchView;
@property (nonatomic, strong) NSArray *muhotDataSource;
@property (nonatomic, strong) CBSLeftAliginFlowLayout *flowlayOut;
/**
 历史搜索本地记录
 */
@property(nonatomic,strong)NSMutableArray *historySearchArr;
@end

@implementation CBSBoutiqueClassSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    
    NSArray *temparr = [[NSUserDefaults standardUserDefaults]objectForKey:@"CBXHistorySearchArr"];
    self.historySearchArr = temparr.mutableCopy;
}
    
#pragma mark- 视图
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
    
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
    

    
#pragma mark- 代理
#pragma mark TextfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 清空按钮
    if (resultStr.length > 0) {
        self.clearSearchBarBtn.hidden = NO;
    }else{
        self.clearSearchBarBtn.hidden = YES;
    }
    
    return YES;
}
    
    /**
     点击搜索
     
     @param textField <#textField description#>
     @return <#return value description#>
     */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self clickSearchBtn];
    
    return YES;
}
    
#pragma mark CBXSearchHistoryTableViewCellDelegate<点击删除某条历史记录>
-(void)clickDeleterBtnWithCell:(CBSSearchHistoryCollectionViewCell *)cell {
    [self.historySearchArr removeObjectAtIndex:self.historySearchArr.count - 1 - cell.tag];
    
    [self.hotSearchView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.historySearchArr forKey:@"CBXHistorySearchArr"];
}
    
    
#pragma mark- 点击事件
    /**
     点击热门搜索按钮 123
     
     @param sender <#sender description#>
     */
- (void)clickHotSearchBtn:(UIButton*)sender {
    int count = 0;
    switch (sender.tag) {
        case 1:
        //            self.inputTextField.text = @"小升初";
        count = 1;
        break;
        case 2:
        //            self.inputTextField.text = @"中考";
        count = 2;
        break;
        case 3:
        //            self.inputTextField.text = @"高考";
        count = 3;
        break;
        
        default:
        break;
    }
    // 点击热门搜索按钮 相当于选择知识点，而不是关键字
    // 跳转搜索结果
    UIViewController *vc = [[UIViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
    
    
    /**
     点击搜索栏放大镜
     
     @param sender <#sender description#>
     */
- (void)clickMagnifierBtn:(UIButton*)sender {
    
    NSLog(@"搜索");
    [self clickSearchBtn];
}
    /**
     点击清空搜索栏按钮
     
     @param sender <#sender description#>
     */
- (void)clickClearContentBtn:(UIButton*)sender {
    
    sender.hidden = YES;
    self.inputTextField.text = @"";
}
    
    /**
     点击取消
     */
- (void)clickDismissController {
    
    [self.navigationController popViewControllerAnimated:YES];
}
    
#pragma mark- 封装事件
    
    /**
     返回热门事件按钮
     
     @param frame frame
     @param str 内容
     @param tag <#tag description#>
     @return <#return value description#>
     */
- (UIButton*)creatHotSearchBtnWithFrame:(CGRect)frame andContent:(NSString*)str andTag:(int)tag {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.tag = tag;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(clickHotSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
    
- (void)clickSearchBtn {
    
//    DLog(@"搜索");
    // 输入内容不能为空
    if(self.inputTextField.text.length == 0){
//        [[CBXHudViewTool shareHud]showFailHudViewWithContent:@"搜索内容不能为空"];
        return;
    }
    
    // 优先删除相同的搜索内容
    //        for (int i = 0; i < self.historySearchArr.count; i++) {
    //            if ([self.inputTextField.text isEqualToString:self.historySearchArr[i]]) {
    //                // 如果内容相同，将不做任何改变
    //                [self.historySearchArr removeObjectAtIndex:i];
    //                break;
    //            }
    //        }
    
    // 是否包含相同元素
    BOOL hasSameStr = [self.historySearchArr containsObject: self.inputTextField.text];
    //  移除掉最早的记录: 不能超过5条上限 并且 不包含相同内容
    if (self.historySearchArr.count >= 5 && hasSameStr == NO) {
        [self.historySearchArr removeObjectAtIndex:0];
    }
    // 添加到新的历史记录: 不能包含相同的字符串
    if (hasSameStr == NO){
        [self.historySearchArr addObject:self.inputTextField.text];
    }
    
    // 更新偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:self.historySearchArr forKey:@"CBXHistorySearchArr"];
    
    [self.hotSearchView reloadData];
    
    [self.view endEditing:YES];
    UIViewController *vc = [[UIViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
    
#pragma mark- UI

    
- (void)setUpUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerSearchView.backgroundColor = [UIColor whiteColor];
    self.hotSearchView.backgroundColor = [UIColor clearColor];
    self.hotSearchView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

}
#pragma mark - CBSLeftAliginFlowLayout
- (CBSLeftAliginFlowLayout *)flowlayOut{
    if (_flowlayOut == nil) {
        _flowlayOut = [[CBSLeftAliginFlowLayout alloc] init];
        _flowlayOut.cellType = AlignWithLeft;
    }
    return _flowlayOut;
}
#pragma mark - UICollectionView
- (UICollectionView *)hotSearchView{
    if (_hotSearchView == nil) {
        _hotSearchView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowlayOut];
        _hotSearchView.delegate = self;
        _hotSearchView.dataSource = self;
        _hotSearchView.backgroundColor = [UIColor whiteColor];
        [_hotSearchView registerClass:[CBSHotSearchCollectionViewCell class] forCellWithReuseIdentifier:@"CBSHotSearchCollectionViewCell"];
        [_hotSearchView registerNib:[UINib nibWithNibName:@"CBSSearchHistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CBSSearchHistoryCollectionViewCell"];
        [_hotSearchView registerClass:[CBSHotSeachHearView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CBSHotSeachHearView"];
        [self.view addSubview:_hotSearchView];
    }
    return _hotSearchView;
}

- (NSArray *)muhotDataSource{
    if (_muhotDataSource == nil) {
        _muhotDataSource = [[NSArray alloc] init];
        _muhotDataSource = @[@"思维与口才",@"晟育教育",@"成语故事",@"热门视频排在第",@"热门视频得到的推荐",@"热门视频我的热点视频搜索"];
    }
    return _muhotDataSource;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        CBSHotSeachHearView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CBSHotSeachHearView" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
                view.title = @"热门搜索";
                view.hiddenBottomLine = YES;
            }
                break;
            case 1:
            {
                view.title = @"搜索历史";
                view.hiddenBottomLine = NO;
                
            }
                break;
                
            default:
                break;
        }
        return view;
    }
    return nil;
}
    
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.muhotDataSource.count;
    }else{
        return self.historySearchArr.count > 0 ? self.historySearchArr.count + 1 : 0;
    }
    
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CBSHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBSHotSearchCollectionViewCell" forIndexPath:indexPath];
        NSString *contentStr = self.muhotDataSource[indexPath.item];
        NSString *contentTemp = contentStr;
        if (contentStr.length > 6) {
            contentTemp = [NSString stringWithFormat:@"%@···",[contentStr substringToIndex:6]];
        }
        cell.title = contentTemp;
        return cell;
    }else{
        CBSSearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBSSearchHistoryCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        // 赋值内容
        if (indexPath.item == self.historySearchArr.count) {
            cell.isBottomCell = YES;
        }else{
            cell.isBottomCell = NO;
            // 逆向排序
            cell.contentStr = self.historySearchArr[self.historySearchArr.count - 1 - indexPath.row];
        }
        cell.tag = indexPath.row;
        
        cell.delegate = self;
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	// 跳转搜索结果
//	CBXClassSearchResultViewController *vc = [[CBXClassSearchResultViewController alloc]init];
//	if ([self.inputTextField.text isEqualToString:@"小升初"]) {
//		vc.typeIn = 3;
//		vc.typeTestIn = 1;
//	}else if ([self.inputTextField.text isEqualToString:@"中考"]){
//		vc.typeIn = 3;
//		vc.typeTestIn = 2;
//	}else if ([self.inputTextField.text isEqualToString:@"高考"]){
//		vc.typeIn = 3;
//		vc.typeTestIn = 3;
//	}else {
//		vc.searchContent = self.inputTextField.text;
//	}
	
//	[self.navigationController pushViewController:vc animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.item) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
                
            default:
                break;
        }
    }else{
        // 点击清除全部记录
        if (indexPath.item == self.historySearchArr.count) {
            [self.historySearchArr removeAllObjects];
            [[NSUserDefaults standardUserDefaults]setObject:self.historySearchArr forKey:@"CBXHistorySearchArr"];
            [self.hotSearchView reloadData];
        }else{
            NSString *contentStr = self.historySearchArr[indexPath.item];
            self.inputTextField.text = contentStr;

            [self.view endEditing:YES];
        }
        
        [self clickSearchBtn];
    }
	
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *contentStr = self.muhotDataSource[indexPath.item];
        NSString *contentTemp = contentStr;
        if (contentStr.length > 6) {
            contentTemp = [NSString stringWithFormat:@"%@···",[contentStr substringToIndex:6]];
        }
        CGFloat width = [contentTemp sizeWithpreferHeight:30 font:[UIFont systemFontOfSize:14]].width;
        return CGSizeMake(width + 20, 30);
    }else{
        return CGSizeMake(self.view.frame.size.width, 45);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(10, 12.5, 10, 10);
    }else{
        return UIEdgeInsetsZero;
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

    /**
     2.热门搜索视图
     
     @return <#return value description#>
     */

    
    /**
     1. 头部搜索视图
     
     @return <#return value description#>
     */
- (UIView *)headerSearchView {
    
    if (_headerSearchView == nil) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + 5, self.view.frame.size.height, kTopHeight)];
        
        [self.view addSubview:view];
        _headerSearchView = view;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(12.5, 28 + (JudgePhoneX ? 20 : 0), self.view.frame.size.width - 25 - 35 - 7, 27)];
        backView.layer.cornerRadius = 4;
        backView.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:backView];
        
        // 添加取消按钮
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 35 - 10, 28 + 4 + (JudgePhoneX ? 20 : 0), 35, 20)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [cancleBtn addTarget:self action:@selector(clickDismissController) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:cancleBtn];
        
        // 添加小放大镜
        UIButton *Magnifierbtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 12.5, 12.5)];
        [Magnifierbtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        
        [Magnifierbtn addTarget:self action:@selector(clickMagnifierBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:Magnifierbtn];
        
        // 添加输入框
        UITextField *inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Magnifierbtn.frame) + 8, 0, self.view.frame.size.width - 25 - 8 * 2 - 12.5 - 20  - 35 - 7, 27)];
        inputTextField.placeholder = @" 小升初、中考、高考";
        inputTextField.font = [UIFont systemFontOfSize:14];
        inputTextField.textColor = [UIColor blackColor];
        inputTextField.returnKeyType = UIReturnKeySearch;
        
        inputTextField.delegate = self;
        [backView addSubview:inputTextField];
        self.inputTextField = inputTextField;
        
        // 清空按钮
        UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25 - 20.5 -35 - 7, 8, 12.5, 12.5)];
        [clearBtn setImage:[UIImage imageNamed:@"btn_search_del"] forState:UIControlStateNormal];
        clearBtn.hidden = YES;
        
        [clearBtn addTarget:self action:@selector(clickClearContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:clearBtn];
        self.clearSearchBarBtn = clearBtn;
    }
    return _headerSearchView;
}
    
- (NSMutableArray *)historySearchArr {
    
    if (_historySearchArr == nil) {
        _historySearchArr = [NSMutableArray array];
    }
    return _historySearchArr;
}
	
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
