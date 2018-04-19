//
//  ViewController.m
//  IcyInstaller3
//
//  Created by ArtikusHG on 2/8/18.
//  Copyright © 2018 ArtikusHG. All rights reserved.
//
#include <spawn.h>
#include <signal.h>
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSMutableData *downloadedMutableData;
@property (strong, nonatomic) NSURLResponse *urlResponse;

@end
#define coolerBlueColor [UIColor colorWithRed:0.00 green:0.52 blue:1.00 alpha:1.0];
@implementation ViewController
UIButton *aboutButton;
UILabel *nameLabel;
UILabel *descLabel;
UIWebView *welcomeWebView;
UIWebView *depictionWebView;
UIView *navigationView;
UIView *homeView;
UIView *sourcesView;
UIView *manageView;
UILabel *homeLabel;
UILabel *sourcesLabel;
UILabel *manageLabel;
UITextField *searchField;
UITableView *tableView;
UITableView *tableView2;
UITableView *tableView3;
UIView *loadingView;
UITextView *loadingArea;
UIProgressView *progressView;
NSMutableArray *fileLines;
NSMutableArray *fileLines2;
//NSMutableArray *packages;
NSMutableArray *repos;
NSMutableArray *bigbossData;
NSMutableArray *searchNames;
NSMutableArray *searchFiles;
NSMutableArray *searchDescs;
NSMutableArray *searchIDs;
NSMutableArray *searchRepos;
NSString *filename;
BOOL darkMode = NO;
int packageIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Get value of darkMode
    darkMode = [[NSUserDefaults standardUserDefaults] valueForKey:@"darkMode"];
    // Stuff for downloading with progress
    self.downloadedMutableData = [[NSMutableData alloc] init];
    // The button at the right
    aboutButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 120,33,75,30)];
    aboutButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    if(darkMode) {
        [aboutButton setTitle:@"Dark" forState:UIControlStateNormal];
    } else {
        [aboutButton setTitle:@"L" forState:UIControlStateNormal];
    }
    aboutButton.titleLabel.textColor = coolerBlueColor;
    [aboutButton addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    [self makeViewRound:aboutButton withRadius:5];
    [self.view addSubview:aboutButton];
    // The top label
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(26,26,[UIScreen mainScreen].bounds.size.width,40)];
    nameLabel.text = @"Icy Installer";
    [nameLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [self.view addSubview:nameLabel];
    // The less top but still top label
    descLabel = [[UILabel alloc]initWithFrame:CGRectMake(26,76,[UIScreen mainScreen].bounds.size.width,20)];
    descLabel.text = @"Where the possibilities are endless";
    [descLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:descLabel];
    // The homepage website
    welcomeWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,120,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200)];
    [welcomeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://artikus.pe.hu/Icy.html"]]];
    [self.view addSubview:welcomeWebView];
    // The depiction webview
    depictionWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,120,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200)];
    [self.view addSubview:depictionWebView];
    // Change the user agent to a desktop one, so when we view depictions "Open in Cydia" doesn't appear
    NSDictionary *dictionary = @{@"UserAgent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1 Safari/605.1.15"};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    depictionWebView.hidden = YES;
    // Navigation, I guess
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 75, [UIScreen mainScreen].bounds.size.width, 75)];
    UIView *border = [[UIView alloc]initWithFrame:CGRectMake(0, 0, navigationView.frame.size.width, 1)];
    border.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [navigationView addSubview:border];
    [self.view addSubview:navigationView];
    // The homeView
    homeView = [[UIView alloc]initWithFrame:CGRectMake(30,10,32,32)];
    homeView.backgroundColor = coolerBlueColor;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: homeView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){1000, 1000}].CGPath;
    [self makeViewRound:homeView withRadius:5];
    homeView.layer.mask = maskLayer;
    [navigationView addSubview:homeView];
    // The home label
    homeLabel = [[UILabel alloc]initWithFrame:CGRectMake(27,45,40,10)];
    homeLabel.textAlignment = NSTextAlignmentCenter;
    homeLabel.textColor = coolerBlueColor;
    homeLabel.text = @"Home";
    [homeLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [navigationView addSubview:homeLabel];
    // The sourcesView
    sourcesView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 16, 10, 32, 32)];
    sourcesView.backgroundColor = [UIColor grayColor];
    [self makeViewRound:sourcesView withRadius:15];
    [navigationView addSubview:sourcesView];
    // The sources label
    sourcesLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 25,45,50,10)];
    sourcesLabel.textColor = [UIColor grayColor];
    sourcesLabel.textAlignment = NSTextAlignmentCenter;
    sourcesLabel.text = @"Sources";
    [sourcesLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [navigationView addSubview:sourcesLabel];
    // The manageView
    manageView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 62,10,32,32)];
    manageView.backgroundColor = [UIColor grayColor];
    [self makeViewRound:manageView withRadius:10];
    [navigationView addSubview:manageView];
    // The manage label
    manageLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70,40,50,20)];
    manageLabel.textColor = [UIColor grayColor];
    manageLabel.textAlignment = NSTextAlignmentCenter;
    manageLabel.text = @"Manage";
    [manageLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [navigationView addSubview:manageLabel];
    // Gesture recognizers
    UITapGestureRecognizer *homeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(homeAction)];
    [homeView addGestureRecognizer:homeGesture];
    UITapGestureRecognizer *sourcesGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sourcesAction)];
    [sourcesView addGestureRecognizer:sourcesGesture];
    UITapGestureRecognizer *manageGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(manageAction)];
    [manageView addGestureRecognizer:manageGesture];
    // Table views
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(13,100,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(13,140,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 220) style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.backgroundColor = [UIColor whiteColor];
    
    /*tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(13,140,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 220) style:UITableViewStylePlain];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView3.backgroundColor = [UIColor whiteColor];*/
    
    [self.view addSubview:tableView];
    [self.view addSubview:tableView2];
    //[self.view addSubview:tableView3];
    tableView.hidden = YES;
    tableView2.hidden = YES;
    //tableView3.hidden = YES;
    // Search texfield
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(20,120,[UIScreen mainScreen].bounds.size.width - 40,30)];
    searchField.placeholder = @"Search";
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.textAlignment = NSTextAlignmentCenter;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.delegate = self;
    searchField.hidden = YES;
    [self makeViewRound:searchField withRadius:5];
    [self.view addSubview:searchField];
    // Loading view
    loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if(darkMode) {
        loadingView.backgroundColor = [UIColor blackColor];
    } else {
        loadingView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:loadingView];
    // Gradient
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(30,[UIScreen mainScreen].bounds.size.height / 2 - 160,[UIScreen mainScreen].bounds.size.width - 60,360)];
    [self makeViewRound:gradientView withRadius:10];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)[UIColor colorWithRed:0.16 green:0.81 blue:0.93 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.15 green:0.48 blue:0.78 alpha:1.0].CGColor];
    gradient.frame = gradientView.bounds;
    if(!darkMode) {
        [gradientView.layer insertSublayer:gradient atIndex:0];
    }
    [loadingView addSubview:gradientView];
    // Top label
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 50)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Icy Installer";
    [loadingLabel setFont:[UIFont boldSystemFontOfSize:30]];
    if(darkMode) {
        loadingLabel.textColor = [UIColor whiteColor];
    } else {
        loadingLabel.textColor = [UIColor blackColor];
    }
    [loadingView addSubview:loadingLabel];
    // Loading textarea
    loadingArea = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, gradientView.bounds.size.width, 330)];
    loadingArea.scrollEnabled = NO;
    loadingArea.textColor = [UIColor whiteColor];
    loadingArea.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    loadingArea.textAlignment = NSTextAlignmentCenter;
    [loadingArea setFont:[UIFont boldSystemFontOfSize:15]];
    loadingArea.text = @"Welcome to Icy Installer 3.1!\nMade by ArtikusHG.\nLoading packages....";
    [gradientView addSubview:loadingArea];
    // Progress spinwheel
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake(gradientView.bounds.size.width / 2 - 10,20,20,20);
    [gradientView addSubview:spinner];
    [spinner startAnimating];
    // Progress View
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,10);
    progressView.progress = 0;
    [self.view addSubview:progressView];
    if(darkMode) {
        [self switchToDarkMode];
    }
    // Stuff
    repos = [NSMutableArray arrayWithObjects:@"BigBoss", @"ModMyi", @"Zodttd and MacCiti", @"Cydia/Telesphoreo", nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadStuff];
        [self redirectLogToDocuments];
        //NSLog(@"Just testing");
    });
}

- (void)redirectLogToDocuments {
    NSString *pathForLog = @"/var/mobile/Media/log.txt";
    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (void)addLoadingText:(NSString *)text {
    loadingArea.text = [NSString stringWithFormat:@"%@\n%@",loadingArea.text,text];
}

- (void)loadStuff {
    BOOL isDirectory;
    // Check for needed directory
    if(![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Media/Icy" isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/Media/Icy" withIntermediateDirectories:NO attributes:nil error:nil];
    }
    // Get package list and put to table view
    pid_t pid;
    int status;
    const char *argv[] = {"bash", "-c", "dpkg --get-selections | tr -s [:space:] '\n' | grep -v install | grep -v hold > /var/mobile/Media/Icy/Packages.txt && while read p; do string=$(dpkg -s $p | grep Name) && echo ${string:6:999} | grep -v dpkg; if [[ $string != *'Name'* ]]; then str=$(dpkg -s $p | grep 'Package:') && echo ${str:9:999}; fi; done </var/mobile/Media/Icy/Packages.txt > /var/mobile/Media/Icy/PackageNames.txt", NULL};
    posix_spawn(&pid, "/bin/bash", NULL, NULL, (char* const*)argv, NULL);
    waitpid(pid, &status, 0);
    NSString *fileContents = [NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/PackageNames.txt" encoding:NSUTF8StringEncoding error:nil];
    fileLines = [[NSMutableArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"] copyItems:YES];
    NSString *fileContents2 = [NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/Packages.txt" encoding:NSUTF8StringEncoding error:nil];
    fileLines2 = [[NSMutableArray alloc] initWithArray:[fileContents2 componentsSeparatedByString:@"\n"] copyItems:YES];
    [self addLoadingText:@"Finished loading packages.\nCleaning up..."];
    [tableView reloadData];
    /*
    // Repository data
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // Cleanup stuff so we have no "file already exists" errors
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/BigBoss" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/ModMyi" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/Zodttd" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/Saurik" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/BigBoss.bz2" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/ModMyi.bz2" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/Zodttd.bz2" error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Media/Icy/Saurik.bz2" error:nil];
        [self addLoadingText:@"Finished cleaning up.\nStarting to load sources..."];
        // BigBoss
        NSString *bigboss = @"http://apt.thebigboss.org/repofiles/cydia/dists/stable/main/binary-iphoneos-arm/Packages.bz2";
        NSURL *bigbossURL = [NSURL URLWithString:bigboss];
        NSData *bigbossURLData = [NSData dataWithContentsOfURL:bigbossURL];
        if (bigbossURLData) {
            [bigbossURLData writeToFile:@"/var/mobile/Media/Icy/BigBoss.bz2" atomically:YES];
        }
        // ModMyi
        NSString *modmyi = @"http://apt.modmyi.com/dists/stable/main/binary-iphoneos-arm/Packages.bz2";
        NSURL *modmyiURL = [NSURL URLWithString:modmyi];
        NSData *modmyiURLData = [NSData dataWithContentsOfURL:modmyiURL];
        if (modmyiURLData) {
            [modmyiURLData writeToFile:@"/var/mobile/Media/Icy/ModMyi.bz2" atomically:YES];
        }
        // Zodttd and MacCiti
        NSString *zodttd = @"http://zodttd.saurik.com/repo/cydia/dists/stable/main/binary-iphoneos-arm/Packages.bz2";
        NSURL *zodttdURL = [NSURL URLWithString:zodttd];
        NSData *zodttdURLData = [NSData dataWithContentsOfURL:zodttdURL];
        if (zodttdURLData) {
            [zodttdURLData writeToFile:@"/var/mobile/Media/Icy/Zodttd.bz2" atomically:YES];
        }
        // Saurik's repo
        NSString *saurik = @"http://apt.saurik.com/cydia/Packages.bz2";
        NSURL *saurikURL = [NSURL URLWithString:saurik];
        NSData *saurikURLData = [NSData dataWithContentsOfURL:saurikURL];
        if (saurikURLData) {
            [saurikURLData writeToFile:@"/var/mobile/Media/Icy/Saurik.bz2" atomically:YES];
        }
        [self addLoadingText:@"Done loading all sources.\nUncompressing data..."];
        // Unpack
        pid_t pid1;
        int status1;
        const char *argv1[] = {"bash", "-c", "bzip2 -dc /var/mobile/Media/Icy/BigBoss.bz2 > /var/mobile/Media/Icy/BigBoss && bzip2 -dc /var/mobile/Media/Icy/ModMyi.bz2 > /var/mobile/Media/Icy/ModMyi && bzip2 -dc /var/mobile/Media/Icy/Zodttd.bz2 > /var/mobile/Media/Icy/Zodttd && bzip2 -dc /var/mobile/Media/Icy/Saurik.bz2 > /var/mobile/Media/Icy/Saurik", NULL};
        posix_spawn(&pid1, "/bin/bash", NULL, NULL, (char**)argv1, NULL);
        waitpid(pid, &status1, 0);*/
        [self addLoadingText:@"Everything loaded. Launching Icy Installer..."];
        [UIView animateWithDuration:.3 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            loadingView.frame  = CGRectMake(0,-[UIScreen mainScreen].bounds.size.height - 20,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            if(darkMode) {
                [welcomeWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.background = 'black'; var p = document.getElementsByTagName('p'); for (var i = 0; i < p.length; i++) { p[i].style.color = 'white'; }"];
            }
        }];
    //});
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if(theTableView == tableView) {
        return fileLines.count;
    } else if(theTableView == tableView2) {
        return searchNames.count;
    } else if(theTableView == tableView3) {
        return repos.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    if(theTableView == tableView) {
        cell.textLabel.text = [fileLines objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [fileLines2 objectAtIndex:indexPath.row];
    } else if(theTableView == tableView2) {
        cell.textLabel.text = [searchNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [searchDescs objectAtIndex:indexPath.row];
    } else if(theTableView == tableView3) {
        cell.textLabel.text = [repos objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = @"Some stupid error happened";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
NSString *packageName;
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(theTableView == tableView) {
        [self packageInfoWithIndexPath:indexPath];
    } else if(theTableView == tableView2) {
        [self installPackageWithIndexPath:indexPath];
    } else if(theTableView == tableView3) {
        [self searchPackagesInRepoWithIndexPath:indexPath];
    } else {
        [self messageWithTitle:@"Error" message:@"Literally an error. Go report this to me."];
    }
}
UIView *infoView;
UITextView *infoText;
- (void)packageInfoWithIndexPath:(NSIndexPath *)indexPath {
    NSString *descCommand = [NSString stringWithFormat:@"dpkg -s %@ | grep -v 'Depiction:' | grep -v 'Replaces:' | grep -v 'Provides:' | grep -v 'Status:' | grep -v 'Architecture:' | grep -v 'Section:' | grep -v 'Priority:' | grep -v 'Depends:' | grep -v 'Conflicts:' | grep -v 'Installed-Size:' | grep -v 'Homepage:' | grep -v 'Maintainer:' | grep -v 'Icon:' | grep -v 'Tag:' | grep -v 'Sponsor:' > /var/mobile/Media/Icy/PackageInfo.txt",[fileLines2 objectAtIndex:indexPath.row]];
    pid_t pid;
    int status;
    const char *argv[] = {"bash", "-c", [descCommand UTF8String], NULL};
    const char *path[] = {"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games", NULL};
    posix_spawn(&pid, "/bin/bash", NULL, NULL, (char**)argv, (char**)path);
    waitpid(pid, &status, 0);
    NSString *info = [NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/PackageInfo.txt" encoding:NSUTF8StringEncoding error:nil];
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0,100,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200)];
    [self.view addSubview:infoView];
    infoText = [[UITextView alloc]initWithFrame:CGRectMake(20,10,[UIScreen mainScreen].bounds.size.width - 40,[UIScreen mainScreen].bounds.size.height / 2 - 20)];
    infoText.editable = NO;
    infoText.scrollEnabled = YES;
    infoText.text = info;
    infoText.textColor = [UIColor whiteColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)[UIColor colorWithRed:0.16 green:0.81 blue:0.93 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.15 green:0.48 blue:0.78 alpha:1.0].CGColor];
    gradient.frame = CGRectMake(0,-20,infoText.bounds.size.width,[UIScreen mainScreen].bounds.size.height / 1.5);
    if(darkMode) {
        infoView.backgroundColor = [UIColor blackColor];
        infoText.backgroundColor = [UIColor blackColor];
    } else {
        infoView.backgroundColor = [UIColor whiteColor];
        [infoText.layer insertSublayer:gradient atIndex:0];
    }
    [infoText setFont:[UIFont boldSystemFontOfSize:15]];
    [self makeViewRound:infoText withRadius:10];
    [infoView addSubview:infoText];
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(20,infoView.bounds.size.height - 30,[UIScreen mainScreen].bounds.size.width - 40,40)];
    dismiss.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    [dismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
    dismiss.layer.masksToBounds = YES;
    dismiss.layer.cornerRadius = 10;
    [dismiss.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    dismiss.titleLabel.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    [dismiss addTarget:self action:@selector(dismissInfo) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:dismiss];
    UIButton *remove = [[UIButton alloc] initWithFrame:CGRectMake(20,infoView.bounds.size.height - 80,[UIScreen mainScreen].bounds.size.width - 40,40)];
    remove.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.1];
    [remove setTitle:@"Remove" forState:UIControlStateNormal];
    remove.layer.masksToBounds = YES;
    remove.layer.cornerRadius = 10;
    [remove.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    remove.titleLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [remove addTarget:self action:@selector(removePackage) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:remove];
    nameLabel.text = @"Info";
    descLabel.text = [NSString stringWithFormat:@"%@",[fileLines2 objectAtIndex:indexPath.row]];
}

- (void)dismissInfo {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        infoView.frame  = CGRectMake(0,-[UIScreen mainScreen].bounds.size.width - 100,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200);
    } completion:^(BOOL finished) {
    }];
    [self manageAction];
}

- (void)removePackage {
    NSString *exec = [NSString stringWithFormat:@"freeze -r %@ > /var/mobile/Media/Icy/RemoveLog.txt",descLabel.text];
    pid_t pid;
    int status;
    const char *argv[] = {"bash", "-c", [exec UTF8String], NULL};
    const char *path[] = {"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games", NULL};
    posix_spawn(&pid, "/bin/bash", NULL, NULL, (char**)argv, (char**)path);
    waitpid(pid, &status, 0);
    NSString *removeLog = [NSString stringWithFormat:@"Package removed with log:\n%@",[NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/RemoveLog.txt" encoding:NSUTF8StringEncoding error:nil]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self reloadWithMessage:removeLog];
    });
}

- (void)installDeb {
    // Direct deb install
    UIAlertView *input = [[UIAlertView alloc] initWithTitle:@"Enter file URL" message:@"Please enter the .deb file direct link in the field below" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Install", nil];
    input.alertViewStyle = UIAlertViewStylePlainTextInput;
    [input show];
    [input release];
}

UIView *reloadView;
UIView *messageView;
UIView *darkenView;
- (void)reloadWithMessage:(NSString *)message {
    darkenView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    darkenView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:darkenView];
    reloadView = [[UIView alloc] initWithFrame:CGRectMake(30,-230,[UIScreen mainScreen].bounds.size.width - 60,230)];
    if(darkMode) {
        reloadView.backgroundColor = [UIColor blackColor];
    } else {
        reloadView.backgroundColor = [UIColor whiteColor];
    }
    [self makeViewRound:reloadView withRadius:10];
    [self.view addSubview:reloadView];
    UIButton *respring = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, reloadView.bounds.size.width - 40, 50)];
    [self makeViewRound:respring withRadius:10];
    respring.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
    [respring setTitle:@"Respring" forState:UIControlStateNormal];
    [respring setTitleColor:[[UIColor greenColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [respring.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [respring addTarget:self action:@selector(respring) forControlEvents:UIControlEventTouchUpInside];
    [reloadView addSubview:respring];
    UIButton *uicache = [[UIButton alloc] initWithFrame:CGRectMake(20, 90, reloadView.bounds.size.width - 40, 50)];
    [self makeViewRound:uicache withRadius:10];
    uicache.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    [uicache setTitle:@"Reload cache" forState:UIControlStateNormal];
    [uicache setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [uicache.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [uicache addTarget:self action:@selector(uicache) forControlEvents:UIControlEventTouchUpInside];
    [reloadView addSubview:uicache];
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(20, 160, reloadView.bounds.size.width - 40, 50)];
    [self makeViewRound:dismiss withRadius:10];
    dismiss.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [dismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismiss setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [dismiss.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [dismiss addTarget:self action:@selector(dismissReload) forControlEvents:UIControlEventTouchUpInside];
    [reloadView addSubview:dismiss];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        reloadView.frame = CGRectMake(30,[UIScreen mainScreen].bounds.size.height - 260,[UIScreen mainScreen].bounds.size.width - 60,230);
    } completion:^(BOOL finished) {
    }];
    messageView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width,30,[UIScreen mainScreen].bounds.size.width - 60,230)];
    [self makeViewRound:messageView withRadius:10];
    [self.view addSubview:messageView];
    UITextView *messageTextView = [[UITextView alloc] initWithFrame:messageView.bounds];
    [messageView addSubview:messageTextView];
    messageTextView.text = message;
    messageTextView.font = [UIFont boldSystemFontOfSize:15];
    if(darkMode) {
        messageView.backgroundColor = [UIColor blackColor];
        messageTextView.textColor = [UIColor whiteColor];
    } else {
        messageView.backgroundColor = [UIColor whiteColor];
    }
    [UIView animateWithDuration:.3 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        messageView.frame = CGRectMake(30,30,[UIScreen mainScreen].bounds.size.width - 60,230);
    } completion:^(BOOL finished) {
    }];
}

- (void)uicache {
    pid_t pid;
    int status;
    const char *argv[] = {"uicache", NULL};
    posix_spawn(&pid, "/usr/bin/uicache", NULL, NULL, (char* const*)argv, NULL);
    waitpid(pid, &status, 0);
}

- (void)respring {
    pid_t pid;
    int status;
    const char *argv[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
    waitpid(pid, &status, 0);
}

- (void)dismissReload {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        reloadView.frame = CGRectMake(30,-230,[UIScreen mainScreen].bounds.size.width - 60,230);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
            messageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width,30,[UIScreen mainScreen].bounds.size.width - 60,230);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^ {
               [darkenView setAlpha:0];
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)about {
    if([aboutButton.currentTitle isEqualToString:@"Dark"]) {
        [aboutButton setTitle:@"Light" forState:UIControlStateNormal];
        [self switchToDarkMode];
    } else if([aboutButton.currentTitle isEqualToString:@"Light"]) {
        [aboutButton setTitle:@"Dark" forState:UIControlStateNormal];
        [self switchToLightMode];
    } else if([aboutButton.currentTitle isEqualToString:@"Install"] && depictionWebView.hidden) {
        [self messageWithTitle:@"Error" message:@"You need to search for a package first."];
    } else if([aboutButton.currentTitle isEqualToString:@"Install"] && !depictionWebView.hidden) {
        [self installPackageWithProgressAndURLString:[searchFiles objectAtIndex:packageIndex] saveFilename:@"downloaded.deb"];
        nameLabel.text = @"Getting...";
        descLabel.text = @"Downloading and installing...";
    } else {
        pid_t pid;
        int status;
        const char *argv[] = {"bash", "-c", "dpkg -l > /var/mobile/IcyBackup.txt", NULL};
        posix_spawn(&pid, "/bin/bash", NULL, NULL, (char* const*)argv, NULL);
        waitpid(pid, &status, 0);
        [self messageWithTitle:@"Done" message:@"The package backup was saved to /var/mobile/IcyBackup.txt"];
    }
}

// Dark mode

- (void)switchToDarkMode {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"darkMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    darkMode = YES;
    navigationView.backgroundColor = [UIColor blackColor];
    nameLabel.textColor = [UIColor whiteColor];
    descLabel.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    tableView.backgroundColor = [UIColor blackColor];
    tableView2.backgroundColor = [UIColor blackColor];
    tableView3.backgroundColor = [UIColor blackColor];
    searchField.backgroundColor = [UIColor grayColor];
    searchField.textColor = [UIColor whiteColor];
    infoView.backgroundColor = [UIColor blackColor];
    [welcomeWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.background = 'black'; var p = document.getElementsByTagName('p'); for (var i = 0; i < p.length; i++) { p[i].style.color = 'white'; }"];
    searchField.keyboardAppearance = UIKeyboardAppearanceDark;
}

// Back to light mode

- (void)switchToLightMode {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"darkMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    darkMode = NO;
    navigationView.backgroundColor = [UIColor whiteColor];
    nameLabel.textColor = [UIColor blackColor];
    descLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView2.backgroundColor = [UIColor whiteColor];
    tableView3.backgroundColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.textColor = [UIColor blackColor];
    infoView.backgroundColor = [UIColor whiteColor];
    [welcomeWebView reload];
    searchField.keyboardAppearance = UIKeyboardAppearanceLight;
}

- (void)homeAction {
    nameLabel.text = @"Icy Installer";
    descLabel.text = @"Where the possibilities are endless";
    [UIView performWithoutAnimation:^{
        if(darkMode) {
            [aboutButton setTitle:@"Dark" forState:UIControlStateNormal];
        } else {
            [aboutButton setTitle:@"Light" forState:UIControlStateNormal];
        }
        [aboutButton layoutIfNeeded];
    }];
    aboutButton.titleLabel.textColor = coolerBlueColor;
    welcomeWebView.hidden = NO;
    depictionWebView.hidden = YES;
    homeView.backgroundColor = coolerBlueColor;
    homeLabel.textColor = coolerBlueColor;
    sourcesView.backgroundColor = [UIColor grayColor];
    sourcesLabel.textColor = [UIColor grayColor];
    manageView.backgroundColor = [UIColor grayColor];
    manageLabel.textColor = [UIColor grayColor];
    tableView.hidden = YES;
    tableView2.hidden = YES;
    searchField.hidden = YES;
}
- (void)sourcesAction {
    nameLabel.text = @"Sources";
    descLabel.text = @"Search Cydia package sources";
    [UIView performWithoutAnimation:^{
        [aboutButton setTitle:@"Install" forState:UIControlStateNormal];
        [aboutButton layoutIfNeeded];
    }];
    aboutButton.titleLabel.textColor = coolerBlueColor;
    welcomeWebView.hidden = YES;
    depictionWebView.hidden = YES;
    homeView.backgroundColor = [UIColor grayColor];
    homeLabel.textColor = [UIColor grayColor];
    sourcesView.backgroundColor = coolerBlueColor;
    sourcesLabel.textColor = coolerBlueColor;
    manageView.backgroundColor = [UIColor grayColor];
    manageLabel.textColor = [UIColor grayColor];
    tableView.hidden = YES;
    tableView2.hidden = NO;
    searchField.hidden = NO;
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
}
- (void)manageAction {
    nameLabel.text = @"Manage";
    descLabel.text = @"Manage already installed packages";
    [UIView performWithoutAnimation:^{
        [aboutButton setTitle:@"Backup" forState:UIControlStateNormal];
        [aboutButton layoutIfNeeded];
    }];
    aboutButton.titleLabel.textColor = coolerBlueColor;
    welcomeWebView.hidden = YES;
    depictionWebView.hidden = YES;
    homeView.backgroundColor = [UIColor grayColor];
    homeLabel.textColor = [UIColor grayColor];
    sourcesView.backgroundColor = [UIColor grayColor];
    sourcesLabel.textColor = [UIColor grayColor];
    manageView.backgroundColor = coolerBlueColor;
    manageLabel.textColor = coolerBlueColor;
    tableView.hidden = NO;
    tableView2.hidden = YES;
    searchField.hidden = YES;
}

- (void)messageWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [alert release];
    aboutButton.titleLabel.textColor = coolerBlueColor;
}

- (void)dealloc {
    [manageView release];
    [manageView release];
    [super dealloc];
}

- (void)makeViewRound:(UIView *)view withRadius:(int)radius {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //tableView3.hidden = NO;
    //nameLabel.text = @"Choose";
    //descLabel.text = @"Please choose a repo";
    [self searchPackages];
    return YES;
}

- (void)searchPackages {
    NSData *postData = [[NSString stringWithFormat:@"q=%@",[searchField.text stringByReplacingOccurrencesOfString:@" " withString:@""]] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://server.s0n1c.org/cydia/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSData *searchData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSMutableDictionary *array = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:nil];
    searchNames = [[NSMutableArray alloc] init];
    int a = 0;
    while (a < [[array allKeys] count]) {
        NSArray *keys = [array allKeys];
        NSString *thing = [keys objectAtIndex:a];
        NSArray *stuff = array[thing];
        [searchNames addObject:[stuff valueForKey:@"name"]];
        a++;
    }
    searchDescs = [[NSMutableArray alloc] init];
    a = 0;
    while (a < [[array allKeys] count]) {
        NSArray *keys = [array allKeys];
        NSString *thing = [keys objectAtIndex:a];
        NSArray *stuff = array[thing];
        [searchDescs addObject:[stuff valueForKey:@"desc"]];
        a++;
    }
    [tableView2 reloadData];
    searchFiles = [[NSMutableArray alloc] init];
    a = 0;
    while (a < [[array allKeys] count]) {
        NSArray *keys = [array allKeys];
        NSString *thing = [keys objectAtIndex:a];
        NSArray *stuff = array[thing];
        [searchFiles addObject:[stuff valueForKey:@"file"]];
        a++;
    }
    searchIDs = [[NSMutableArray alloc] init];
    a = 0;
    while (a < [[array allKeys] count]) {
        NSArray *keys = [array allKeys];
        NSString *thing = [keys objectAtIndex:a];
        NSArray *stuff = array[thing];
        [searchIDs addObject:[stuff valueForKey:@"id"]];
        a++;
    }
    searchRepos = [[NSMutableArray alloc] init];
    a = 0;
    while (a < [[array allKeys] count]) {
        NSArray *keys = [array allKeys];
        NSString *thing = [keys objectAtIndex:a];
        NSArray *stuff = array[thing];
        [searchRepos addObject:[stuff valueForKey:@"repo"]];
        a++;
    }
    [self.view endEditing:YES];
}

// OLD THING
NSString *repoName = nil;
- (void)searchPackagesInRepoWithIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        repoName = @"BigBoss";
    }
    if(indexPath.row == 1) {
        repoName = @"ModMyi";
    }
    if(indexPath.row == 2) {
        repoName = @"Zodttd";
    }
    if(indexPath.row == 3) {
        repoName = @"Saurik";
    }
    pid_t pid;
    int status;
    const char *argv[] = {"bash", "-c", [[NSString stringWithFormat:@"cat /var/mobile/Media/Icy/%@ | grep -i \"Name: %@\" > /var/mobile/Media/Icy/SearchNames.txt", repoName, searchField.text] UTF8String], NULL};
    posix_spawn(&pid, "/bin/bash", NULL, NULL, (char**)argv, NULL);
    waitpid(pid, &status, 0);
    tableView3.hidden = YES;
    NSString *searchResults = [NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/SearchNames.txt" encoding:NSUTF8StringEncoding error:nil];
    searchResults = [searchResults stringByReplacingOccurrencesOfString:@"Name: " withString:@""];
    //packages = [[NSMutableArray alloc] initWithArray:[searchResults componentsSeparatedByString:@"\n"] copyItems:YES];
    [tableView2 reloadData];
}

- (void)installPackageWithIndexPath:(NSIndexPath *)indexPath {
    NSString *repoName = [searchRepos objectAtIndex:indexPath.row];
    if([repoName isEqualToString:@"bigboss"] || [repoName isEqualToString:@"modmyi"] || [repoName isEqualToString:@"zodttd"]) {
        [depictionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cydia.saurik.com/package/%@",[searchIDs objectAtIndex:indexPath.row]]]]];
        depictionWebView.hidden = NO;
        [self.view bringSubviewToFront:depictionWebView];
        packageIndex = (int) indexPath.row;
    } else {
        [self installPackageWithProgressAndURLString:[searchFiles objectAtIndex:indexPath.row] saveFilename:@"downloaded.deb"];
        nameLabel.text = @"Getting...";
        descLabel.text = @"Downloading and installing...";
    }
    /*NSString *searchCommand = [NSString stringWithFormat:@"packageName=\"%@\" && repoName=\"%@\" && direction=\"down\" && cat /var/mobile/Media/Icy/$repoName | grep -i -a \"Name: $packageName\" > /var/mobile/Media/Icy/SearchNames.txt && line=$(cat /var/mobile/Media/Icy/$repoName | grep -i -n -a -w -Fx \"Name: $packageName\" | cut -d : -f 1) && filename=$(sed \"${line}q;d\" /var/mobile/Media/Icy/$repoName) && while [[ $filename != *\"Filename:\"* ]]; do filename=$(sed \"${line}q;d\" /var/mobile/Media/Icy/$repoName) && if [[ $filename = *\"Filename:\"* ]]; then echo -n $filename > /var/mobile/Media/Icy/PackageLink.txt; fi; if [[ ${#filename} -lt 2 ]]; then direction=\"up\"; fi && if [[ $direction = \"down\" ]]; then line=$((line+1)); elif [[ $direction = \"up\" ]]; then line=$((line-1)); fi; done", [tableView2 cellForRowAtIndexPath:indexPath].textLabel.text, repoName];
    pid_t pid;
    int status;
    const char *argv[] = {"bash", "-c", [searchCommand UTF8String], NULL};
    posix_spawn(&pid, "/bin/bash", NULL, NULL, (char**)argv, NULL);
    waitpid(pid, &status, 0);
    nameLabel.text = @"Downloading...";
    NSString *packageLink = [NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/PackageLink.txt" encoding:NSUTF8StringEncoding error:nil];
    packageLink = [packageLink stringByReplacingOccurrencesOfString:@"Filename: " withString:@""];
    NSString *fullPackageLink = nil;
    if([repoName isEqualToString:@"BigBoss"]) {
        fullPackageLink = [NSString stringWithFormat:@"http://apt.thebigboss.org/repofiles/cydia/%@",packageLink];
    } else if([repoName isEqualToString:@"ModMyi"]) {
        fullPackageLink = [NSString stringWithFormat:@"http://apt.modmyi.com/%@",packageLink];
    } else if([repoName isEqualToString:@"Zodttd"]) {
        fullPackageLink = [NSString stringWithFormat:@"http://cydia.zodttd.com/repo/cydia/%@",packageLink];
    } else if([repoName isEqualToString:@"Saurik"]) {
        fullPackageLink = [NSString stringWithFormat:@"http://apt.saurik.com/%@",packageLink];
    } else {
        [self messageWithTitle:@"Error" message:@"Some random error happend randomly in this random application where you randomly pressed a random button with your random finger. Please randomly report this random error to the random creator of this random application. His random Twitter page is on the random \"Home\" page in this random application."];
    }
    [fullPackageLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [fullPackageLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    nameLabel.text = @"Getting...";
    descLabel.text = @"Downloading and installing...";
    [self installPackageWithProgressAndURLString:fullPackageLink saveFilename:@"downloaded.deb"];*/
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        NSLog(@"Portrait");
        [self changeToPortrait];
        
    }
    else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        [self changeToLandscape];
    }
}

- (void)changeToPortrait {
    aboutButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120,33,75,30);
    nameLabel.frame = CGRectMake(26,26,[UIScreen mainScreen].bounds.size.width,40);
    descLabel.frame = CGRectMake(26,76,[UIScreen mainScreen].bounds.size.width,20);
    welcomeWebView.frame = CGRectMake(0,120,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200);
    navigationView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 75, [UIScreen mainScreen].bounds.size.width, 75);
    homeView.frame = CGRectMake(30,10,32,32);
    homeLabel.frame = CGRectMake(27,45,40,10);
    sourcesView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 16, 10, 32, 32);
    sourcesLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 25,45,50,10);
    manageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 62,10,32,32);
    manageLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70,40,50,20);
    tableView.frame = CGRectMake(13,100,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 200);
    tableView2.frame = CGRectMake(13,140,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 220);
    searchField.frame = CGRectMake(20,120,[UIScreen mainScreen].bounds.size.width - 40,20);
}

- (void)changeToLandscape {
    aboutButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 120,33,75,30);
    nameLabel.frame = CGRectMake(26,26,[UIScreen mainScreen].bounds.size.height,40);
    descLabel.frame = CGRectMake(26,76,[UIScreen mainScreen].bounds.size.height,20);
    welcomeWebView.frame = CGRectMake(0,120,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width - 200);
    navigationView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width - 75, [UIScreen mainScreen].bounds.size.height, 75);
    homeView.frame = CGRectMake(30,10,32,32);
    homeLabel.frame = CGRectMake(27,45,40,10);
    sourcesView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height / 2 - 16, 10, 32, 32);
    sourcesLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.height / 2 - 25,45,50,10);
    manageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 62,10,32,32);
    manageLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 70,40,50,20);
    tableView.frame = CGRectMake(13,100,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width - 200);
    tableView2.frame = CGRectMake(13,140,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width - 220);
    searchField.frame = CGRectMake(20,120,[UIScreen mainScreen].bounds.size.height - 40,20);
}

#pragma mark - Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%lld", response.expectedContentLength);
    self.urlResponse = response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedMutableData appendData:data];
    progressView.progress = ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)/100;
    if (progressView.progress == 1) {
        progressView.hidden = YES;
    } else {
        progressView.hidden = NO;
    }
    NSLog(@"%.0f%%", ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length));
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished, installing...");
    [self.downloadedMutableData writeToFile:[NSString stringWithFormat:@"/var/mobile/Media/Icy/%@",filename] atomically:YES];
    // Depends
    /*pid_t pid;
    int status;
    const char *argv[] = {"bash", "-c", "dpkg -f /var/mobile/Media/Icy/downloaded.deb Depends > /var/mobile/Media/Icy/Depends.txt", NULL};
    posix_spawn(&pid, "/bin/bash", NULL, NULL, (char**)argv, NULL);
    waitpid(pid, &status, 0);*/
    // Install
    pid_t pid1;
    int status1;
    const char *argv1[] = {"bash", "-c", "freeze -i --force-depends /var/mobile/Media/Icy/downloaded.deb > /var/mobile/Media/Icy/InstallLog.txt", NULL};
    const char *path[] = {"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games", NULL};
    posix_spawn(&pid1, "/bin/bash", NULL, NULL, (char**)argv1, (char**)path);
    waitpid(pid1, &status1, 0);
    nameLabel.text = @"Done";
    descLabel.text = @"The package was installed";
    NSString *installLog = [NSString stringWithFormat:@"Package installed with log:\n%@",[NSString stringWithContentsOfFile:@"/var/mobile/Media/Icy/InstallLog.txt" encoding:NSUTF8StringEncoding error:nil]];
    [self reloadWithMessage:installLog];
}

- (void)installPackageWithProgressAndURLString:(NSString *)urlString saveFilename:(NSString *)filename1 {
    filename = filename1;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 60.0];
    self.connectionManager = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

@end
