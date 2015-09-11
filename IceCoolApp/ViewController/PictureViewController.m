//
//  PictureViewController.m
//  IceCoolApp
//
//  Created by ice.hu on 15/9/10.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "NSString+SBJSON.h"
#import "MJRefresh.h"

#define defaultImageWidth 320
#define defaultImageHeight 320

typedef enum
{
    DBActionTypeLoadMore = 1,
    DBActionTypesRefresh = 2
} DBActionTypes;

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *dataSourceArray;
    NSMutableDictionary *imageSizeDic;
}

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataSourceArray = [NSMutableArray array];
    imageSizeDic = [NSMutableDictionary dictionary];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    
    // 设置刷新控件
    _picCollectionView.header = header;
    
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"释放加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor whiteColor];
    
    // 设置刷新控件
    _picCollectionView.footer = footer;

    
    
    // 下拉刷新
//    _picCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self loadDataSource:DBActionTypesRefresh];
//    }];
    
    // 上拉刷新
//    _picCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self loadDataSource:DBActionTypeLoadMore];
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    [self loadDataSource:DBActionTypeLoadMore];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Collection View

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataSourceArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    PictureCollectionViewCell *cell = (PictureCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(PictureCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *item = [dataSourceArray objectAtIndex:indexPath.row];
    NSURL *URL = [NSURL URLWithString:[item objectForKey:@"picUrl"]];
    
    [cell.imgPic sd_setImageWithURL:URL placeholderImage:nil options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (![imageSizeDic objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
            if(image.size.height>0 && image.size.width>0){
                [imageSizeDic setObject:@{@"width":[NSNumber numberWithFloat:image.size.width],@"height":[NSNumber numberWithFloat:image.size.height]} forKey:[NSNumber numberWithInteger:indexPath.row]];
                
                [_picCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            }
        }
    }];
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10,10);
}


#define column 2
#define xoffset 10
#define yoffset 10

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (![imageSizeDic objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
        return CGSizeMake(defaultImageWidth, defaultImageHeight);
    }
    else{
        NSDictionary *item = [imageSizeDic objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        
        float width = [[item objectForKey:@"width"]floatValue];
        float height = [[item objectForKey:@"height"]floatValue];
        
        float rWidth = ([[UIScreen mainScreen]bounds].size.width-(column+1)*xoffset)/column;
        float rHeight = height * rWidth / width;
        
        if (isnan(rWidth) || isnan(rHeight)) {
            NSLog(@"--%f,%f,%f",height,rWidth,width);
            return CGSizeMake(defaultImageWidth, defaultImageHeight);
        }
        
        return CGSizeMake(rWidth, rHeight);
    }
}



#pragma mark - DB
-(void)loadMore
{
    [self loadDataSource:DBActionTypeLoadMore];
}

-(void)refreshData
{
    [self loadDataSource:DBActionTypesRefresh];
}


- (void)loadDataSource:(DBActionTypes)type
{
    [ApplicationDelegate showLoadingHUD:@"Loading..." view:self.view];
    
    NSString *httpUrl = @"http://apis.baidu.com/txapi/mvtp/meinv";
    NSString *httpArg = @"num=30";
    [self request: httpUrl withHttpArg: httpArg type:type];
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg type:(DBActionTypes)type
{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"a3b62beaf144fca03b63b3855fa61418" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   [GlobalVariables handleErrorByString:@"登入失败!请确认网络连接!"];
                                   NSLog(@"Error: %@", error);
                                   [self dataSourceDidError:type];
                               } else {
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                   NSMutableDictionary *responseDic = [responseString JSONValue];
                                   NSEnumerator * enumerator = [responseDic keyEnumerator];
                                   
                                   //------------刷新清楚原数据-------------
                                   if (type == DBActionTypesRefresh) {
                                       [dataSourceArray removeAllObjects];
                                   }
                                   
                                   //定义一个不确定类型的对象
                                   id object;
                                   //遍历输出
                                   while(object = [enumerator nextObject])
                                   {
                                       if ([object isEqual:@"msg"] || [object isEqual:@"code"]) {
                                           NSLog(@"键值为：%@, %@",enumerator,object);
                                       }
                                       else{
                                           id objectValue = [responseDic objectForKey:object];
                                           if(objectValue != nil)
                                           {
                                               [dataSourceArray addObject:objectValue];
                                           }
                                       }
                                   }

                                   
                                   [self dataSourceDidLoad:type];
                                   
                               }
                           }];
}


- (void)loadDataSource1:(DBActionTypes)type
{
    [ApplicationDelegate showLoadingHUD:@"Loading..." view:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@meinv/?key=%@&num=%d",HuceoDBHost,HuceoAppKey,30];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!responseObject && ![responseObject isKindOfClass:[NSDictionary class]]) {
            [GlobalVariables handleErrorByString:@"登入失败!请确认网络连接!"];
            [self dataSourceDidError:type];
            return;
        }
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableDictionary *responseDic = [responseString JSONValue];
        
        
        //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
        NSEnumerator * enumerator = [responseDic keyEnumerator];
        //把keyEnumerator替换为objectEnumerator即可得到value值（1）
        
        //------------刷新清楚原数据-------------
        if (type == DBActionTypesRefresh) {
            [dataSourceArray removeAllObjects];
        }
        
        //定义一个不确定类型的对象
        id object;
        //遍历输出
        while(object = [enumerator nextObject])
        {
            if ([object isEqual:@"msg"] || [object isEqual:@"code"]) {
                NSLog(@"键值为：%@, %@",enumerator,object);
            }
            else{
                id objectValue = [responseDic objectForKey:object];
                if(objectValue != nil)
                {
                    [dataSourceArray addObject:objectValue];
                }
            }
        }
        
        [self dataSourceDidLoad:type];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GlobalVariables handleErrorByString:@"登入失败!请确认网络连接!"];
        NSLog(@"Error: %@", error);
        [self dataSourceDidError:type];
    }];
}

- (void)dataSourceDidLoad:(DBActionTypes)type {
    [[ApplicationDelegate HUD] dismiss];
    
    if (type == DBActionTypesRefresh) {
        [_picCollectionView.header endRefreshing];
    }
    else{
        [_picCollectionView.footer endRefreshing];
    }
    
    [_picCollectionView reloadData];
}

- (void)dataSourceDidError:(DBActionTypes)type {
    [[ApplicationDelegate HUD] dismiss];
    
    if (type == DBActionTypesRefresh) {
        [_picCollectionView.header endRefreshing];
    }
    else{
        [_picCollectionView.footer endRefreshing];
    }
    
    [_picCollectionView reloadData];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
