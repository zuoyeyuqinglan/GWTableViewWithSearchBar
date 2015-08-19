//
//  GWSearchView.m
//  GWTableViewWithSearchBar
//
//  Created by Guan on 15/8/19.
//  Copyright (c) 2015年 GuanGuan. All rights reserved.
//

#import "GWSearchView.h"

@interface GWSearchView()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchVC;

// 存放排好序的数据(汉字)
@property (nonatomic, strong) NSMutableDictionary *sectionDictionary;

// 存放汉字拼音大写首字母
@property (nonatomic, strong) NSMutableArray *rankArray;

@end


@implementation GWSearchView

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        
        // UISearchController初始化
        self.searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchVC.searchResultsUpdater = self;
        self.searchVC.delegate = self;
        
        //        self.searchVC.searchBar.frame = CGRectMake(0, 100, WIDTH, 44);
        self.searchVC.searchBar.barTintColor = [UIColor yellowColor];
        self.tableHeaderView = self.searchVC.searchBar;
        
        // 设置为NO,可以点击搜索出来的内容
        self.searchVC.dimsBackgroundDuringPresentation = NO;
        
    }
    
    return self;
}


-(NSMutableArray *)rankArray
{
    if (!_rankArray) {
        NSMutableArray *keyArray = [[NSMutableArray alloc]init];
        [keyArray addObject: @{[NSString stringWithFormat:@"#"]:[[NSMutableArray alloc]init]}];
        for (int i = 0; i < 26 ; i ++ ) {
            NSDictionary *dict = @{[NSString stringWithFormat:@"%c",'a'+ i]:[[NSMutableArray alloc]init]};
            [keyArray addObject:dict];
        }
        _rankArray = keyArray;
    }
    return _rankArray;
}


-(void)setDataArr:(NSArray *)dataArr
{
    

}
-(NSArray *)dataArr
{
    
    return nil;
}







@end
