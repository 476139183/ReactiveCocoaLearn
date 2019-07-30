//
//  ViewController.m
//  RAC-第二课
//
//  Created by Yutian Duan on 2018/11/16.
//  Copyright © 2018年 Wanwin. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "KFCModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
}

//！ 元祖 解析
- (void)tuple {
  
  RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"我",@"才刚到",@(12)]];
  
  /*
   tuple[0],
   tuple[1],
   tuple[2]
   */
  /* 也可用宏直接解析 */
  RACTupleUnpack(NSString *name, NSString *action, NSNumber *age) = tuple;
  NSLog(@"元祖\n%@,%@,%@\n",name,action,age);
}

/*
 RACSequence:用于代替NSArray,NSDictionary,可以使用快速的遍历
 */

//! 数组解析
- (void)subArray {
  
  NSArray *arr = @[@"我",@"真",@"的",@"才",@(12)];
  NSLog(@"数组遍历\n");
  
  /*
   RACSequence * requence = [arr rac_sequence];
   RACSignal * signal = [requence signal];
   [signal subscribeNext:^(id  _Nullable x) {
     NSLog(@"%@",x);
   }];
   */
  
  [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@",x);
  }];
  
  
}

//! 字典解析
- (void)subDictionnary {
  NSDictionary *dic = @{
                        @"name":@"段",
                        @"age":@(12)
                        };
  
  NSLog(@"字典解析\n");
  [dic.rac_sequence.signal subscribeNext:^(RACTwoTuple *x) {
    RACTupleUnpack(NSString *key,NSString *value) = x;
    NSLog(@"%@=%@",key,value);
  }];
}

//! 复合数据解析
- (void)mapPlist {
  
  NSString * filePath = [[NSBundle mainBundle] pathForResource:@"kfc.plist" ofType:nil];
  NSArray * dictArr = [NSArray arrayWithContentsOfFile:filePath];
  NSLog(@"复杂数据解析\n");
  /*
   NSMutableArray * modelArr = [NSMutableArray array];
   [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary * x) {
     KFCModel * kfc = [KFC mj_keywithVaule:x];
     [modelArr addObject:kfc];
   }];
   */
  
  NSArray *modelArr = [[dictArr.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
    NSLog(@"value");
    return [KFCModel mj_keywithVaule:value];
    
  }] toArray];

  NSLog(@"%@",modelArr);
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  static int i = 0;
  i++;

  switch (i%4) {
    case 0: {
      [self tuple];
    }
      break;
    case 1: {
      [self subArray];
    }
      break;
    case 2: {
      [self subDictionnary];
    }
      break;
    case 3: {
      [self mapPlist];
    }
      break;
    default:
      break;
  }
  
}


@end
