//
//  ViewController.m
//  RAC-第一课
//
//  Created by Yutian Duan on 2018/11/13.
//  Copyright © 2018年 Wanwin. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self signal];
  
}

//! 基类信号 RACSignal
- (void)signal {
  
  //TODO: 1.创建信号 -> 返回的是子类 RACDynamicSignal 爆出 didSubscribe block
  RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //TODO: 3. 在主线程，RACSubscriber对象发送信号
    [subscriber sendNext:@"发送一个对象"];
    
    return [RACDisposable disposableWithBlock:^{
      /* TODO: 信号自动销毁
       最后生成的 RACDisposable 会调用 销毁block，这一步发生在最后  addDisposable 方法里面
      */
      NSLog(@"信号销毁");
    }];
  }];
  
  /*  TODO: 2.订阅信号 调用 RACDynamicSignal 的 父亲类的 subscribeNext 方法，里面生成
  RACSubscriber 对象，再调用 自己实现的 subscribe 发送信号的方法。调用创建信号时，保存的block
   发送信号之后， 返回 RACDisposable 对象
  */
  [signal subscribeNext:^(id  _Nullable x) {
    // x 收到的信号
    NSLog(@"收到的信号：%@",x);
  }];

}

//! 信号子类 RACSubject
- (void)subject {
  //! 1. 创建信号，建立一个销毁对象和一个数组 _subscribers
  RACSubject *subject = [RACSubject subject];
  /* 2. 订阅信号, 调用父类方法，并重写里面的 subscribe 方法。
      拿到之前的_subscribers 只保存这个订阅者，并未触发其他方法
  */
  [subject subscribeNext:^(id  _Nullable x) {
    NSLog(@"接受到了数据:%@",x);
  }];
  
  //!3. 发送数据
  //遍历出所有的订阅者,调用nextBlock
  [subject sendNext:@"子类信号"];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
