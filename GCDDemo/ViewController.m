//
//  ViewController.m
//  GCDDemo
//
//  Created by zyh on 16/7/5.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self testBarrierSyncWithConCurrentQueue];
    
}

- (void)testBarrierSyncWithConCurrentQueue {
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.zangqilong.www", DISPATCH_QUEUE_CONCURRENT);
    
    for (int index = 0; index<10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index = %d", index);
        });
        
    }
    for (int j = 0; j<10000; j++) {
    
        dispatch_barrier_sync(concurrent_queue, ^{
            if (j == 10000-1) {
                NSLog(@"barrier Finished");
//                NSLog(@"current thread is %@", [NSThread currentThread]);
            }
        });
    }
    
    NSLog(@"Running on Main Thread");
    
    for (int index =10; index<20; index++) {
        
        dispatch_async(concurrent_queue, ^{
            
            NSLog(@"index = %d", index);
            NSLog(@"current thread is %@", [NSThread currentThread]);
        });
    }
}

#pragma mark - GCDDispatch_after
- (void)GCDDispatch_after
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        NSLog(@"3秒后执行");
    });
}

#pragma mark - GCDQueue和同步，异步总结
- (void)GCDQueueWithDispatch_asyncAndDispatch_sync
{
    /*
     GCD 有三种 queue
     main queue    串行  更新UI
     global queue  并行
     custom queue  串行或者并行
     */
    
    //global queue
    //开启一个异步线程，在全局队列中执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //do something
    });
    
    //custom queue
    //自定义串行
    dispatch_queue_t serial_queue = dispatch_queue_create("com.reviewcode.www", DISPATCH_QUEUE_SERIAL);
    
    //自定义并行
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.zangqilong.www", DISPATCH_QUEUE_CONCURRENT);
    
    //在dispatch_async使用串行队列
    [self testSerialQueueWithAsync];
    
    //在dispatch_async使用并行队列
    [self testConcurrentQueueWithAsync];
    
    /*
     dispatch_async 异步会开线程，不会卡主线程，如果是串行队列会在开的一个线程里串行执行，如果是并行队列会在开的多个线程里并发执行
     
     dispatch_sync  同步不会开线程，所以不管是串行还是并行都会在主线程线程里串行执行
     */

}

- (void)testSerialQueueWithAsync
{
    dispatch_queue_t serial_queue = dispatch_queue_create("com.reviewcode.www", DISPATCH_QUEUE_SERIAL);
    
    for (int index = 0; index < 10; index++) {
        
        dispatch_async(serial_queue, ^{
            
            NSLog(@"index = %d",index);
            NSLog(@"current thread is %@",[NSThread currentThread]);
            });
    }
    
    NSLog(@"Runing on main Thread");
}

- (void)testConcurrentQueueWithAsync
{
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.zangqilong.www", DISPATCH_QUEUE_CONCURRENT);
    
    for (int index = 0; index < 10; index++) {
        
        dispatch_async(concurrent_queue, ^{
            
            NSLog(@"index = %d",index);
            NSLog(@"current thread is %@",[NSThread currentThread]);
        });
    }
    
    NSLog(@"Runing on main Thread");
}

@end
