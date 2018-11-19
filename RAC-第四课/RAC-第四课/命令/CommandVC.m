//
//  CommandVC.m
//  RAC-第四课
//
//  Created by Yutian Duan on 2018/11/18.
//  Copyright © 2018年 Wanwin. All rights reserved.
//

#import "CommandVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

/*
 场景：对信号进行一些状态的控制
 RACCommand
 
 */


@interface CommandVC ()

@end

@implementation CommandVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"指令信号";

  [self observeSignal];
  
//  [self commandTest];

}

- (void)observeSignal {
  
  //! 1.创建命令
  RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    NSLog(@"%@",input);
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
      //! 发送数据
      [subscriber sendNext:@"执行命令之后 发送数据"];
      //! 通知命令 结束事件
      [subscriber sendCompleted];
      return nil;
    }];
    
    
  }];
  
  //! 监听事件有没有执行完毕
  [command.executing subscribeNext:^(NSNumber * _Nullable x) {
    // 0 没有执行  1 执行ing
    if ([x boolValue] == YES) {
      NSLog(@"执行中");
    } else {
      NSLog(@"尚未开始或者已经结束了");
    }
    
  }];
  
  [[command execute:@"执行！"] subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@",x);
  }];

  
  
}

- (void)commandSecond {
  
  
  //! 1.创建命令
  RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    NSLog(@"%@",input);
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
      //! 发送数据
      [subscriber sendNext:@"执行命令之后 发送数据"];
      return nil;
    }];
  }];
  
  
  /* TODO: 2.1 信号源 订阅
   * executionSignals:信号源，发送信号的信号。
   *
   *
   */
  /*
  [command.executionSignals subscribeNext:^(RACSignal *signal) {
    NSLog(@"%@",signal);
    //! 信号订阅
    [signal subscribeNext:^(id  _Nullable x) {
      NSLog(@"%@",x);
    }];
  }];
  */
  
  //TDOD: 2.2 另一种方式
  [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@",x);
  }];
  
  
  
  //! 3.执行命令 execute会触发上面的block
  [command execute:@"输入命令"];
  
  
}

////: 命令控制信号
- (void)commandTest {
  
  //! 1.创建命令
  RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    NSLog(@"%@",input);
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
      //! 发送数据
      [subscriber sendNext:@"执行命令之后 发送数据"];
      return nil;
    }];
  }];
  
  //! 2.执行命令，返回的signal 就是 上面的 RACSignal 信号, execute会触发上面的block
  RACSignal *signal = [command execute:@"输入命令"];
  
  //! 3. 订阅信号,来触发 发送数据
  [signal subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@",x);
  }];

}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  NSLog(@"CommandVC dealloc");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

