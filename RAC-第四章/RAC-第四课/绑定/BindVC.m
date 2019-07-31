//
//  BindVC.m
//  RAC-第四课
//
//  Created by Yutian Duan on 2018/11/18.
//  Copyright © 2018年 Wanwin. All rights reserved.
//

#import "BindVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

#import <ReactiveObjC/RACReturnSignal.h>

/*  场景： 对源信号的数据进行处理 再返回，比如对数据进行解析等
 *  bindSignal
 *
 *
 */

@interface BindVC ()

@end

@implementation BindVC

- (void)viewDidLoad {
  [super viewDidLoad];


  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"绑定信号";


  //! 1. 创建信号
  RACSubject *subject = [RACSubject subject];
  
  // 2. 绑定信号
  RACSignal *bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
    
    /*
    RACSignal * _Nullable (^RACSignalBindBlock)(ValueType _Nullable value, BOOL *stop);

     */
    return ^RACSignal *(id  value, BOOL *stop) {
      /* value 源信号发送的消息
       * 只要源信号发送数据，即可调用这个block
       */
      NSLog(@"%@",value);
      if ([value isKindOfClass:[NSString class]]) {
        value = @"操作数据";
      }
      return [RACReturnSignal return:value];
    };
  }];
  
  //! 3.订阅信号
  [bindSignal subscribeNext:^(id  _Nullable x) {
    NSLog(@"bind=%@",x);
  }];
  
  //! 4.发送信号
  [subject sendNext:@"发送原始数据"];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)dealloc {
  NSLog(@"BindVC dealloc");
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

