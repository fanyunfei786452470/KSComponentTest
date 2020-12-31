//
//  KSTableViewCell.m
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import "KSTableViewCell.h"
#import "KSCollectionViewCell.h"
#import "KSNotificationConfig.h"

@interface KSTableViewCell ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) CGFloat lastContentOffsetX;
@property (nonatomic, assign) BOOL isAllowedNotification;

@end

@implementation KSTableViewCell

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if(!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    return self.collectionView;
}

+ (NSString *)identifierCell {
    return @"KSTableViewCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    _nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor redColor];
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.text = @"产品名称";
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(150);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 150)/2, self.contentView.frame.size.height);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[KSCollectionViewCell class] forCellWithReuseIdentifier:[KSCollectionViewCell identifierCell]];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.top.bottom.right.equalTo(self);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KSCollectionViewCell identifierCell] forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 150)/2, self.contentView.frame.size.height);
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
    } else {
        self.isAllowedNotification = NO;
    }
    obj = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[KSNotificationConfig sharedManager].notificationKey object:nil];
}


@end
