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

-(void)pushVariable:(NSString*)variable
{
    [self.programStack addObject:variable];
    
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
    
    //check if
    //if (![self.programStack containsObject:@"a"])
    if(![[self class ] variablesUsedInProgram:self.program])
    {
        return [[self class] runProgram:self.program];
    }
    else return 0;
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
    //return @"Implement this in Homework #2";
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack=[program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];
}

//check if an nsstring is an operation
+ (BOOL)isOperation:(NSString *)operation{
    BOOL result=0;
    NSSet *operationSet=[NSSet setWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt", nil];
    if ([operationSet containsObject:operation] ) result= 1;
    return result;
}
//compare two operations' priority
+ (BOOL) compareOperationPriority:(NSString *)firstOperation vs:(NSString *)secondOperation{
    BOOL result=0;
    NSDictionary *operationPriority= [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"+",@"1",@"-",@"2",@"*",@"2",@"/",@"3",@"sin",@"3",@"cos",@"3",@"sqrt", nil];
    int firstOperationLevel=[[operationPriority objectForKey:firstOperation] intValue];
    int secondOperationLevel;
    if (secondOperation) {
        secondOperationLevel=[[operationPriority objectForKey:secondOperation] intValue];
        if (firstOperationLevel>secondOperationLevel)  result=1;
    }
    return result;
}
//get rid of unnecessary parienthese by comparing the last and the secondlast operation
+(NSString *) surpressParienthese:(NSString *)description{
    NSMutableArray *descriptionArray=[[description componentsSeparatedByString:@" "] mutableCopy];
    
    NSString *lastOperation,*secondLastOperation;
    for (int i=[descriptionArray count]-1; i>0 && !lastOperation; i--) {
        if([CalculatorBrain isOperation:[descriptionArray objectAtIndex:i]]){
            lastOperation=[descriptionArray objectAtIndex:i];//last operation found
            
            for (int j=i-1; j>0 && !secondLastOperation; j--) {
                if ([CalculatorBrain isOperation:[descriptionArray objectAtIndex:j]]) {
                    secondLastOperation=[descriptionArray objectAtIndex:j];
                    
                }
            }
            if (![CalculatorBrain compareOperationPriority:lastOperation vs:secondLastOperation]) {
                [descriptionArray removeObjectAtIndex:i-1];
                [descriptionArray removeObjectAtIndex:0];
            }
            
        }
    }
    
    description=[[descriptionArray valueForKey:@"description"] componentsJoinedByString:@" "];
    return description;
}

+ (NSString *) typeOfString:(NSString *)string{
    NSSet *twoOperandOperation=[NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    NSSet *singleOperandOperation=[NSSet setWithObjects:@"sqrt",@"sin",@"cos", nil];
    NSSet *noOperandOperation=[NSSet setWithObjects:@"π", nil];
    NSSet *variable=[NSSet setWithObjects:@"a",@"b",@"x", nil];
    
    if ([twoOperandOperation containsObject:string])return @"twoOperandOperation";
    else if ([singleOperandOperation containsObject:string])return @"singleOperandOperation";
    else if ([noOperandOperation containsObject:string])return @"noOperandOperation";
    else if ([variable containsObject:string]) return @"variable";
    else return nil;
}

+ (NSString *) descriptionOfTopOfStack: (NSMutableArray *)stack
{
    NSString *description;
    
    id topOfStack=[stack lastObject];
    [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) description=[topOfStack stringValue];
    
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"twoOperandOperation"])
        {
            NSString *second=[CalculatorBrain descriptionOfTopOfStack:stack];
            NSString *first=[CalculatorBrain descriptionOfTopOfStack:stack];
            description=[NSString stringWithFormat:@"( %@ ) %@ %@",first,topOfStack,second];
            description=[CalculatorBrain surpressParienthese: description];  //only two operand operation needs to surpress
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"singleOperandOperation"]) {
            description=[NSString stringWithFormat:@"%@ ( %@ )",topOfStack,[CalculatorBrain descriptionOfTopOfStack:stack]];
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"noOperandOperation"]) {
            description=[NSString stringWithFormat:@"%@",topOfStack];
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"variable"]) {
            description=topOfStack;
        }
    }
    //check if description has "null" in the case of user pressed operation withoud operand before
    NSRange nsrange=[description rangeOfString:@"null"];
    if (nsrange.location!=NSNotFound) {
        description=@"Operand is not entered";
    }
    return description;
}

//when wanna run program with the Variable value
+(double)runProgram:(id)program withVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) stack = [program mutableCopy];
    //loop to replace variables with conrisponding values in dictionary
    for (int i=0; i<[stack count]; i++) {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"a"]){
            //convert NSString object to NSNumber object
            NSString *myString=[variableValues valueForKey:@"a"];
            NSNumber *myNumber=[NSNumber numberWithDouble:[myString doubleValue]];
            //replace "a" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"b"]){
            //convert NSString object to NSNumber object
            NSString *myString=[variableValues valueForKey:@"b"];
            NSNumber *myNumber=[NSNumber numberWithDouble:[myString doubleValue]];
            //replace "b" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"x"]){
            //convert NSString object to NSNumber object
            NSString *myString=[variableValues valueForKey:@"x"];
            NSNumber *myNumber=[NSNumber numberWithDouble:[myString doubleValue]];
            //replace "x" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    //check if program contains variables
    NSSet *variablesSetUsedInProgram;
    if (!variablesSetUsedInProgram) variablesSetUsedInProgram =[[NSSet alloc]init];
    if ([program containsObject:@"a"]) variablesSetUsedInProgram=[variablesSetUsedInProgram setByAddingObject:@"a"];
    if ([program containsObject:@"b"]) variablesSetUsedInProgram=[variablesSetUsedInProgram setByAddingObject:@"b"];
    if ([program containsObject:@"x"]) variablesSetUsedInProgram=[variablesSetUsedInProgram setByAddingObject:@"x"];
    if ([variablesSetUsedInProgram count] ==0) variablesSetUsedInProgram =nil;
    return variablesSetUsedInProgram;
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
            result = cos ([self popOperandOffProgramStack:stack] * M_PI / 180);
        }else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"π"]){
            result = M_PI;
        }
    }
    return result;
}

@end
