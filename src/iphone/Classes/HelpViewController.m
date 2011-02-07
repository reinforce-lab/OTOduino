//
//  HelpViewController.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/22.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController(Private)
-(void)loadHelpPage;
@end

@implementation HelpViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
	[self loadHelpPage];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)loadHelpPage
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
	NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
	NSString *htmlString = [[NSString alloc] initWithData: 
							[readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	
	webView_.backgroundColor = [UIColor whiteColor];
	[webView_ loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:path]];
		
	[htmlString release];
}
/* http://iphone-dev.g.hatena.ne.jp/Miyakey/20091017/1255760274
 
 NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
 NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
 
 NSString *htmlString = [[NSString alloc] initWithData: 
 [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
 
 webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0f, 10.0f, 320.0f, 380.0f)];
 webView.backgroundColor = [UIColor whiteColor];
 [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:path]];
 
 [window addSubview:webView];
 
 [htmlString release]; */
@end
