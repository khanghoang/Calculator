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

    //just add to the history
    self.history.text = [self.history.text stringByAppendingFormat:@"%@", [sender currentTitle]];

    
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
    
    //set the isDotAlready to NO for orther use
    self.isDotAlready = NO;
    
    //show the space " " at the last of history
    self.history.text = [self.history.text stringByAppendingFormat:@" "];

}


- (IBAction)backspacePressed:(id)sender
{
    if (self.display.text.length == 1)
    {
        self.display.text = @"0";
    }
    else
    {
        //set text with the text but lenght - 1
        self.display.text = [self.display.text substringWithRange:NSMakeRange(0, self.display.text.length - 1)];
    }
}


- (IBAction)operationPressed:(id)sender {
    
    NSString *operation = [sender currentTitle];
    
    if(self.userIsInTheMiddleOfEnteringANumber && ![operation isEqualToString:@"+/-"]){
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }

    [self enterPressed];

    
    double result = [self.brain performOperation:operation];
    
    if (result == M_PI)
    {
        self.display.text = [NSString stringWithFormat:@"π"];
    }
    else
    {
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    
    self.history.text = [self.history.text
                         stringByReplacingOccurrencesOfString:@"="
                         withString:@""];
    
    //show the "=" at the last of history
    self.history.text = [self.history.text stringByAppendingFormat:@"%@ = ", [sender currentTitle]];
    
}

@end
