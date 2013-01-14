//
//  CalculatorBrain.h
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;

- (void)pushVariable:(NSString*)variable;

- (double)performOperation:(NSString *)operation;
- (void)clearStack;

@property (nonatomic, readonly) id program;

+(NSString *)descriptionOfProgram:(id)program;
+(double)runProgram:(id)program;
+(double)runProgram:(id)program withVariableValues:(NSDictionary*)variableValues;
+(NSSet*)variablesUsedInProgram:(id)program;

@end

