//
//  CalculatorBrain.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

- (NSMutableArray *)programStack{
    if(!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void)setOperandStack:(NSMutableArray *)anArray{
    _programStack = anArray;
}

-(void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    
    [self.programStack addObject:operandObject];
    
    [self printStack];
    
}

-(void) printStack
{
    //print it out
    NSLog(@"Stack: %@", [self.programStack componentsJoinedByString:@" "]);
}

-(void)clearStack
{
    [self.programStack removeAllObjects];
}

-(double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    
    [self printStack];
    
    return [[self class] runProgram:self.program];
}
+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

//when wanna run program with the Variable value
+(double)runProgram:(id)program
  withVariableValue:(NSDictionary*) dic;
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+(NSSet*)variableUsedInProgram:(id)program
{
    
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }else if([operation isEqualToString:@"sin"])
        {
            result = sin ([self popOperandOffProgramStack:stack] * M_PI / 180);
        }else if([operation isEqualToString:@"cos"]){
            result = cos ([self popOperandOffProgramStack:stack] * M_PI);
        }else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"π"]){
            result = M_PI;
        }
    }
    return result;
}

@end
