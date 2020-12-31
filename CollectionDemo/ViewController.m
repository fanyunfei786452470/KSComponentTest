//
//  ViewController.m
//  CollectionDemo
//
//  Created by 范云飞 on 2020/11/23.
//

#import "ViewController.h"
#import "KSCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 80, 30);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click:(UIButton *)sender {
    KSCollectionViewController * vc = [[KSCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
