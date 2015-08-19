//
//  GWTableViewWithSearchBar.m
//  GWTableViewWithSearchBar
//
//  Created by Guan on 15/8/19.
//  Copyright (c) 2015年 GuanGuan. All rights reserved.
//

#import "GWTableViewWithSearchBar.h"
#import "pinyin.h"//抓取汉字首字母的库
#import "Linkman.h"//数据模型

@interface GWTableViewWithSearchBar()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchVC;

// 存放按姓氏排序后的结果
@property (nonatomic, strong) NSMutableArray *rankArray;

// 存放搜索结果
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation GWTableViewWithSearchBar

//在此添加子控件
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        NSLog(@"init______________________");
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

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        NSLog(@"______________________");
        // UISearchController初始化
        self.searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchVC.searchResultsUpdater = self;
        self.searchVC.delegate = self;
        
        //        self.searchVC.searchBar.frame = CGRectMake(0, 100, WIDTH, 44);
         self.searchVC.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        self.searchVC.searchBar.backgroundImage = [UIImage imageNamed:@"tabbg"];
        self.tableHeaderView = self.searchVC.searchBar;
        // 设置为NO,可以点击搜索出来的内容
        self.searchVC.dimsBackgroundDuringPresentation = NO;
    }

    return self;
}


//重新排序后重新加载
-(void)setRankArray:(NSMutableArray *)rankArray
{
    _rankArray = rankArray;
    [self reloadData];
    
}

-(void)setDataArrGW:(NSArray *)dataArrGW
{
    _dataArrGW = dataArrGW;//进来就排序
    [self figureRankArrayWithdataArrGW:_dataArrGW];
}


#pragma mark -- 这里重写排序的依据变量
-(void)figureRankArrayWithdataArrGW:(NSArray*)dataArrGW
{

//    初始化一个字典数组
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];
    [keyArray addObject: @{[NSString stringWithFormat:@"#"]:[[NSMutableArray alloc]init]}];
    for (int i = 0; i < 26 ; i ++ )
    {
        NSDictionary *dict = @{[NSString stringWithFormat:@"%c",'a'+ i]:[[NSMutableArray alloc]init]};
        [keyArray addObject:dict];
    }
    
//拿到联系人的首字母，添加到对应的数组
    for (Linkman *lm in dataArrGW)
    {
        int flag = 0 ;
        NSString *str = lm.UserName;
        NSString *letter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([str characterAtIndex:0])];
        
        for ( NSDictionary *dict in  keyArray)
        {
            if (dict[letter])
            {
                [dict[letter] addObject:lm];
                flag = 1;
                continue;
            }
        }
        if (flag == 0) {
            [ [keyArray firstObject][@"#"] addObject:lm ];
        }
    }
    
//   删除联系人为空的字典
    for (int i = 0 ; i < keyArray.count; i++) {
        if (![[[keyArray[i] allValues] firstObject] count]) {
            [keyArray removeObject:keyArray[i]];
            i -- ;
        }
    }
    
    self.rankArray = keyArray;
}


#pragma mark - --数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      NSLog(@"self.rankArray.count--%lu",(unsigned long)self.rankArray.count);
    return self.rankArray.count;
  
}

/**设置区域组title*/
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = [[self.rankArray[section] allKeys] firstObject] ;
    char title = [str characterAtIndex:0];
    return [NSString stringWithFormat:@"%c",(title - 32)];
}

/**设置区域组数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.rankArray[section] allValues] firstObject] count];
}

#pragma mark - 返回cell自定义cell可重写set Model方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    Linkman *lm = [[self.rankArray[indexPath.section] allValues] firstObject][indexPath.row];
    cell.textLabel.text = lm.UserName;
    cell.imageView.image = [UIImage imageNamed:lm.Photo];
    cell.detailTextLabel.text = lm.Telephone;
    
    return cell;
}

/**设置行高*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - 这里设置索引
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    [titles addObject:[NSString stringWithFormat:@"#"]];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c",'A' + i];
        [titles addObject:str];
    }
    return titles;

}


#pragma mark - 这里实现按索引的跳转，不同的搜索方式，跳转也不一样
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    int flag ;
    
//    判断点索引在序列中的位置，跳转
    for (int i = 0 ; i < self.rankArray.count; )
    {
        if ([[[self.rankArray[i] allKeys] firstObject] isEqualToString:[NSString stringWithFormat:@"%c",[title characterAtIndex:0] +32]]) {
             flag = i;
             break;
        }
        ++i;
    }
    return flag;
}



// 搜索界面将要出现
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  开始  搜索时触发的方法");
}

// 搜索界面将要消失
-(void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  取消  搜索时触发的方法");
}

#pragma mark - 这里取消搜索后的方法
//取消搜索
-(void)didDismissSearchController:(UISearchController *)searchController
{
    [self.resultArray removeAllObjects];
    [self figureRankArrayWithdataArrGW:self.dataArrGW];
//    [self reloadData];
    
}

#pragma mark -- 搜索方法
// 搜索时触发的方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchStr = [self.searchVC.searchBar text];
    
//    还没开始输入不做任何操作
    if([searchStr isEqualToString:@""])
    {
        
    }
    else
    {//有输入了
       
        if (!self.resultArray ) //清空或者初始化搜索结果数组
        {
            self.resultArray = [[NSMutableArray alloc]init];
        }
        else
        {
            [self.resultArray removeAllObjects];
        }
        
        for (Linkman *lm in self.dataArrGW)
        {
            if ([lm.UserName containsString:searchStr] || [lm.Telephone containsString:searchStr ])
            {
                [self.resultArray addObject:lm];
                continue;
            }
        }
        
        [self figureRankArrayWithdataArrGW:self.resultArray];//刷新
    }
}


//要么不写，要么这样写
-(void)layoutSubviews
{
    [super layoutSubviews];
   
    
}




@end
