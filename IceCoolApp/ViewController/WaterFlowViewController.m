//
//  WaterFlowViewController.m
//  IceCoolApp
//
//  Created by ice.hu on 15/8/19.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import "WaterFlowViewController.h"
#import "PSCollectionViewCell.h"
#import "CellView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "NSString+SBJSON.h"

@interface WaterFlowViewController ()

@end

@implementation WaterFlowViewController
@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [NSMutableArray array];
    
    collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:collectionView];
    collectionView.collectionViewDelegate = self;
    collectionView.collectionViewDataSource = self;
    collectionView.pullDelegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    collectionView.numColsPortrait = 2;
    collectionView.numColsLandscape = 3;
    
    collectionView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    collectionView.pullBackgroundColor = [UIColor yellowColor];
    collectionView.pullTextColor = [UIColor blackColor];
    //    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    //    [headerView setBackgroundColor:[UIColor redColor]];
    //    self.collectionView.headerView=headerView;
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    collectionView.loadingView = loadingLabel;
    
    //    [self loadDataSource];
    if(!collectionView.pullTableIsRefreshing) {
        collectionView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshTable
{
    [self.items removeAllObjects];
    [self loadDataSource];
    self.collectionView.pullLastRefreshDate = [NSDate date];
    self.collectionView.pullTableIsRefreshing = NO;
    [self.collectionView reloadData];
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    //    [self loadDataSource];
    [self.items addObjectsFromArray:self.items];
    [self.collectionView reloadData];
    self.collectionView.pullTableIsLoadingMore = NO;
}
#pragma mark - PullTableViewDelegate

- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}
- (void)viewDidUnload
{
    [self setCollectionView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You should probably subclass PSCollectionViewCell
    CellView *v = (CellView *)[self.collectionView dequeueReusableView];
    //    if (!v) {
    //        v = [[[PSCollectionViewCell alloc] initWithFrame:CGRectZero] autorelease];
    //    }
    if(v == nil) {
        NSArray *nib =
        [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        v = [nib objectAtIndex:0];
    }
    
    //    [v fillViewWithObject:item];
    
    NSURL *URL = [NSURL URLWithString:[item objectForKey:@"picUrl"]];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    [v.picView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
     //    [v.picView  setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You should probably subclass PSCollectionViewCell
    return [PSCollectionViewCell heightForViewWithObject:item inColumnWidth:self.collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    // Do something with the tap
}

- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [self.items count];
}




- (void)loadDataSource {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@meinv/?key=%@&num=%d",HuceoDBHost,HuceoAppKey,10];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", responseString);
        
        NSMutableDictionary *responseDic = [responseString JSONValue];
        
        
        //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
        NSEnumerator * enumerator = [responseDic keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
        
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
                    [self.items addObject:objectValue];
                }
            }
        }

        [self dataSourceDidLoad];
        
        if (!responseObject && ![responseObject isKindOfClass:[NSDictionary class]]) {
            [GlobalVariables handleErrorByString:@"登入失败!请确认网络连接!"];
//            [self dataSourceDidError];
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GlobalVariables handleErrorByString:@"登入失败!请确认网络连接!"];
        NSLog(@"Error: %@", error);
//        [self dataSourceDidError];
    }];
    
//    NSString *httpUrl = @"http://apis.baidu.com/txapi/mvtp/meinv";
//    NSString *httpArg = @"num=10";
//    [self request: httpUrl withHttpArg: httpArg];
}



-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"a3b62beaf144fca03b63b3855fa61418" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   self.items = [[(NSDictionary *)responseString objectForKey:@"0"]mutableCopy];
                                   [self dataSourceDidLoad];

                               }
                           }];
}

- (void)dataSourceDidLoad {
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    [self.collectionView reloadData];
}

@end
