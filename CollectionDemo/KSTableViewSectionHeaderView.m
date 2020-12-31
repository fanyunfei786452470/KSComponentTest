//
//  KSTableViewSectionHeaderView.m
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import "KSTableViewSectionHeaderView.h"
#import "KSCollectionViewCell.h"

#import "KSNotificationConfig.h"

@interface KSTableViewSectionHeaderView ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, assign) CGFloat lastContentOffsetX;
@property (nonatomic, assign) BOOL isAllowedNotification;

@end

@implementation KSTableViewSectionHeaderView

+ (NSString *)identifier {
    return @"KSTableViewSectionHeaderView";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self addNotification];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self addNotification];
    }
    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ks_scrollViewDidScroll:) name:[KSNotificationConfig sharedManager].notificationKey object:nil];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _tipLabel = [[UILabel alloc] init];
    self.tipLabel.backgroundColor = [UIColor blueColor];
    self.tipLabel.font = [UIFont systemFontOfSize:18];
    self.tipLabel.text = @"主要指标";
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(150);
    }];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.minimumInteritemSpacing = 0;
    collectionViewFlowLayout.minimumLineSpacing = 0;
    collectionViewFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 150)/2, self.frame.size.height);
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel.mas_right);
        make.top.bottom.right.equalTo(self);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 150)/2, self.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isAllowedNotification = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isAllowedNotification = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isAllowedNotification) {
        // 是自身才发通知去tableView以及其他的cell
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:[KSNotificationConfig sharedManager].notificationKey object:self userInfo:@{KSScrollViewContentOffsetXKey:@(scrollView.contentOffset.x)}];
    }
    self.isAllowedNotification = NO;
}

- (void)ks_scrollViewDidScroll:(NSNotification*)notification {
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[KSScrollViewContentOffsetXKey] floatValue];
    
    if (obj != self) {
        self.isAllowedNotification = YES;
        if (self.lastContentOffsetX != x) {
            [self.collectionView setContentOffset:CGPointMake(x, 0) animated:NO];
        }
        self.lastContentOffsetX = x;
    }else{
        self.isAllowedNotification = NO;
    }
    obj = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[KSNotificationConfig sharedManager].notificationKey object:nil];
}


@end
