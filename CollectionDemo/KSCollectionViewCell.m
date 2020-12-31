//
//  KSCollectionViewCell.m
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import "KSCollectionViewCell.h"

@implementation KSCollectionViewCell

+ (NSString *)identifierCell {
    return @"KSCollectionViewCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel * contentLabel = [UILabel new];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"头部";
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
}

@end
