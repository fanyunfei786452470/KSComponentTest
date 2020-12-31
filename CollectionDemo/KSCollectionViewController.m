//
//  KSCollectionViewController.m
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import "KSCollectionViewController.h"

#import "KSTableViewCell.h"
#import "KSCollectionViewCell.h"
#import "KSTableViewSectionHeaderView.h"
#import "KSNotificationConfig.h"

@interface KSCollectionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) KSTableViewSectionHeaderView * sectionHeader;

@property (nonatomic, assign) CGFloat lastContentOffsetX;
@property (nonatomic, strong) UIBarButtonItem * rightItem;

@end

@implementation KSCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [KSNotificationConfig sharedManager].notificationKey = [NSString stringWithFormat:@"%p",self];
    self.navigationItem.rightBarButtonItems = @[self.rightItem];
    [self setupUI];
    [self addNotification];
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStyleDone target:self action:@selector(resetContentOffset)];
     }
    return _rightItem;
}

- (void)resetContentOffset {
    self.lastContentOffsetX = 0.0;
    [[NSNotificationCenter defaultCenter] postNotificationName:[KSNotificationConfig sharedManager].notificationKey object:self userInfo:@{KSScrollViewContentOffsetXKey:@(self.lastContentOffsetX)}];
    [self.tableView reloadData];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ks_scrollViewDidScroll:) name:[KSNotificationConfig sharedManager].notificationKey object:nil];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    [self.tableView registerClass:[KSTableViewCell class] forCellReuseIdentifier:[KSTableViewCell identifierCell]];
    [self.tableView registerClass:[KSTableViewSectionHeaderView class] forHeaderFooterViewReuseIdentifier:[KSTableViewSectionHeaderView identifier]];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader * mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf loadDataIsRefresh: YES];
    }];
    self.tableView.mj_header = mj_header;
    
    MJRefreshAutoNormalFooter * mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf loadDataIsRefresh: NO];
    }];
    self.tableView.mj_footer = mj_footer;
    
}

- (void)loadDataIsRefresh:(BOOL)isRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KSTableViewSectionHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[KSTableViewSectionHeaderView identifier]];
    if (!header) {
        header = [[KSTableViewSectionHeaderView alloc] initWithReuseIdentifier:[KSTableViewSectionHeaderView identifier]];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[KSTableViewCell identifierCell] forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[KSNotificationConfig sharedManager].notificationKey object:self userInfo:@{KSScrollViewContentOffsetXKey:@(self.lastContentOffsetX)}];
    }
}

- (void)ks_scrollViewDidScroll:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    float x = [noticeInfo[KSScrollViewContentOffsetXKey] floatValue];
    if (self.lastContentOffsetX != x) {//避免重复设置偏移量
        self.lastContentOffsetX = x;
    }
    noticeInfo = nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[KSNotificationConfig sharedManager].notificationKey object:nil];
}


@end
