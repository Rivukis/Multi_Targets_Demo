//
//  IQViewController.m
//  InterviewQuestions
//
//  Created by Dani Arnaout on 2/22/14.
//  Copyright (c) 2014 Dani Arnaout. All rights reserved.
//

#import "IQViewController.h"
#import <iAd/iAd.h>

@interface IQViewController () <ADBannerViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) UIButton *skipQuestionButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) NSArray *questions;
@property (assign, nonatomic) NSInteger currentQuestionIndex;
@property (assign, nonatomic) NSInteger maxAllowedQuestions;
@property (assign, nonatomic) NSInteger score;
@end

@implementation IQViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupQuiz];
}

#pragma mark - IBActions

- (IBAction)answerButtonPressed:(UIButton *)sender {
  int correctAnswer = [(NSNumber *)self.questions[self.currentQuestionIndex][@"correctAnswer"] intValue];
  if (sender.tag == correctAnswer) {
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.score];
  }
  
  self.currentQuestionIndex++;
  [self showNextQuestion];
}

#pragma mark - Private

- (void)setupQuiz {
  self.navigationItem.title = @"Free Version";
  self.maxAllowedQuestions = 5;
  [self setupAds];
  
  NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
  self.questions = [NSArray arrayWithContentsOfFile:plistPath];
  self.currentQuestionIndex = 0;
  [self showNextQuestion];
}

- (void)setupAds {
  ADBannerView *bannerView = [[ADBannerView alloc]initWithFrame:
                              CGRectMake(0, CGRectGetHeight(self.view.frame) -50, 320, 50)];
  bannerView.delegate = self;
  [self.view addSubview: bannerView];
}

- (void)showNextQuestion {
  //1 - handle last question
  if (self.currentQuestionIndex + 1 > self.maxAllowedQuestions) {
    [[[UIAlertView alloc] initWithTitle:@"Game Over"
                                message:[NSString stringWithFormat:@"Your score is %ld",(long)self.score]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    return;
  }
  
  //2 - update view for next question
  NSDictionary *questionDetail = self.questions[self.currentQuestionIndex];
  self.questionLabel.text = questionDetail[@"question"];
  
  for (int buttonCount = 1; buttonCount <= 4; buttonCount++) {
    UIButton *answerButton = (UIButton *)[self.view viewWithTag:buttonCount];
    [answerButton setTitle:questionDetail[[NSString stringWithFormat:@"answer%d",buttonCount]]
                  forState:UIControlStateNormal];
  }
}

- (void)skipButtonPressed {
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - AdViewDelegate

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"Error Loading: %@", error.localizedDescription);
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
  NSLog(@"Ad Loaded");
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
  NSLog(@"Ad Will Load");
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
  NSLog(@"Ad Did Finish");
}

@end
