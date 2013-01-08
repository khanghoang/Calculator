//
//  CalculatorViewController.m
//  Calculator
//
//  Created by viet on 1/7/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;


//decalre the property that just have 1 dot
@property (nonatomic) BOOL isDotAlready;

@end

@implementation CalculatorViewController

@synthesize display;

@synthesize userIsInTheMiddleOfEnteringANumber;

@synthesize isDotAlready;

@synthesize brain = _brain;

-(CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    //if user press "." button
    if([digit isEqualToString:@"."])
    {
        //if it exist "."
        if(isDotAlready)
        {
            //set digit to "", so they cant effect to the operand
            digit = @"";
        }
        else
        {
            //set the isDotAlready to YES
            isDotAlready = YES;
        }
    }
    
    //do normal calculator
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit]; //     [self.display setText:newDisplayText];
    }else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    

    NSLog(@"user touched %@", digit);
}

- (IBAction)enterPressed {
    
    NSString* text = self.display.text;
    
    //check if the user type like ".25" the operand is "0.25"
    if([text hasPrefix:@"."])
        text = [NSString stringWithFormat:@"0%@", text];
    
    //check if the user type like "2." the operand is "2.0"
    if([text hasSuffix:@"."])
        text = [NSString stringWithFormat:@"%@0", text];
    
    [self.brain pushOperand:[text doubleValue]];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    //set the isDotAlready to NO for orther use
    self.isDotAlready = NO;

}


- (IBAction)operationPressed:(id)sender {
    
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    
    double result = [self.brain performOperation:operation];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
}

@end
