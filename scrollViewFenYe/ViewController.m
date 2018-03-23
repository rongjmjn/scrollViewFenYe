//
//  ViewController.m
//  scrollViewFenYe
//
//  Created by FanrongZeng on 2018/3/23.
//  Copyright © 2018年 FanrongZeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation ViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];

    //添加图片和设置scrollView的属性
    [self addPictures];

    
}

#pragma mark - 业务处理

/** 添加图片 */
- (void)addPictures{
    //添加图片
    CGFloat pictureW = self.scrollView.frame.size.width;
    CGFloat pictureH = self.scrollView.frame.size.height;
    int count = 5;
 
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i * pictureW, 0, pictureW, pictureH);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_0%d", i+1]];
        [self.scrollView addSubview:imageView];
    }
    
    //设置scrollView属性
    self.scrollView.contentSize = CGSizeMake(count * pictureW, 0);
    self.scrollView.delegate = self;//设置代理
    self.scrollView.pagingEnabled = YES;
    
   //设置pageControl属性
    self.pageControl.numberOfPages = count;
    
    self.pageControl.hidesForSinglePage = YES;
    
    [self.pageControl setValue:[UIImage imageNamed:@"current"] forKey:@"_currentPageImage"];
    [self.pageControl setValue:[UIImage imageNamed:@"other"] forKey:@"_pageImage"];
    
    //开启定时器
    [self startTimer];
}

/** 滚到下一页 */
- (void)nextPage: (NSTimer *)timer{
    //获取页码
    NSInteger page = self.pageControl.currentPage + 1;
    
    if (page == 5){
        page = 0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(page * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - 定时器

/** 开启定时器 */
- (void)startTimer{
    
    //返回一个自动开启任务的定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
    
    // NSDefaultRunLoopMode(默认):同一时间只能执行一个任务
    // NSRunLoopCommonModes(公用):分配一定的时间处理其他任务
    
    // 修改timer在mainRunLoop中的模式为NSRunLoopCommonModes.
    // 目的:不管主线程在做什么操作,都要分配一定的时间处理timer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}

/** 关闭定时器 */
- (void)endTimer{
    
    [self.timer invalidate];
    
}

#pragma mark - scrollView代理方法
/** 拖动就调用此方法 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算页码
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    //设置yema
    self.pageControl.currentPage = page;
}
/** 用户即将拖动scrollView的时候,停止定时器 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endTimer];
}

/** 用户已经结束拖动,开启定时器 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self startTimer];
}

@end
