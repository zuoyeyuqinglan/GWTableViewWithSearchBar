//
//  ViewController.m
//  GWTableViewWithSearchBar
//
//  Created by Guan on 15/8/19.
//  Copyright (c) 2015年 GuanGuan. All rights reserved.
//

#import "ViewController.h"
#import "GWTableViewWithSearchBar.h"
#import "Linkman.h"

@interface ViewController ()
@property (nonatomic,strong)GWTableViewWithSearchBar *table;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GWTableViewWithSearchBar *gwt = [[GWTableViewWithSearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    self.table = gwt;
    gwt.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:gwt];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"linkman.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:file];
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in arr) {
        Linkman *lm = [[Linkman alloc]init];
        [lm setValuesForKeysWithDictionary:dict];
        [data addObject:lm];
    }
    
    gwt.dataArrGW = data;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
