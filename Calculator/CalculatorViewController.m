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
    
    //NSLog(@"user touched %@", digit);
}

- (IBAction)clearPressed:(id)sender {
    
    //clear history display
    self.history.text = @"";
    
    //clear operand stack
    [self.brain clearStack];
    
    //reset isDotAlready and is
    self.isDotAlready = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    //clear the display
    self.display.text = @"";
}


- (IBAction)justPress:(id)sender
{
//    NSString* history_text = self.history.text;
    
    self.history.text = [self.history.text stringByAppendingFormat:@" %@", [sender currentTitle]];
    
//    self.history.text = history_text;
}

- (IBAction)enterPressed {
    
    NSString* text = self.display.text;
    
    //check if the user type like ".25" the operand is "0.25"
    if([text hasPrefix:@"."])
        text = [NSString stringWithFormat:@"0%@", text];
    
    //check if the user type like "2." the operand is "2.0"
    if([text hasSuffix:@"."])
        text = [NSString stringWithFormat:@"%@0", text];
    
    //check if there is only 1 character and it must be PI
    if([text hasPrefix:@"π"])
    {
        //put PI into stack
        [self.brain pushOperand:M_PI];
    }        
    else
    {
        //put to stack of operand
        [self.brain pushOperand:[text doubleValue]];
    }
    
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
    
    if (result == M_PI)
    {
        self.display.text = [NSString stringWithFormat:@"π"];
    }
    else
    {
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    
}

@end
