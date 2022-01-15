//
//  ViewController.m
//  Dye-iOS
//

#import <Dye/Dye.h>

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// Create a simple text style in code
- (void)createTextStyle {
    DYEStyle *h1Style = [[DYEStyle alloc] initWithName:@"h1"];
    h1Style.fontSize = 18.0;
    h1Style.fontName = @"Courier New";
    h1Style.primaryColor = [UIColor blackColor];
    
    // Add to the global cache
    [DYEStyle addStyle:h1Style withName:h1Style.dyeStyleName];
}

/// Create a style in code that inherits from an existing style
- (void)createInheritingStyle {
    DYEStyle *h1UnderlineStyle = [[DYEStyle alloc] initWithName:@"h1_underlined" parentStyleName:@"h1"];
    h1UnderlineStyle.textUnderline = YES;
    
    // Add to the global cache
    [DYEStyle addStyle:h1UnderlineStyle withName:h1UnderlineStyle.dyeStyleName];
}

/// Create a style in code with a background gradient
- (void)createGradientStyle {
    DYEStyle *gradientStyle = [[DYEStyle alloc] initWithName:@"gradient"];
    gradientStyle.backgroundGradientColors = @[
        [DYEColors colorNamed:@"jonquil"],
        [DYEColors colorNamed:@"pumpkin"],
        [DYEColors colorNamed:@"spanish_carmine"]
    ];
    
    // Diagonal gradient, top left to bottom right
    gradientStyle.backgroundGradientStartPoint = CGPointMake(0, 0);
    gradientStyle.backgroundGradientStartPoint = CGPointMake(1, 1);
    
    // Add to the global cache
    [DYEStyle addStyle:gradientStyle withName:gradientStyle.dyeStyleName];
}

/// Load  colors from a JSON file in the bundle
- (void)loadLocalColorsFile {
    NSURL *colorsURL = [[NSBundle mainBundle] URLForResource:@"colors" withExtension:@"json"];
    [DYEColors importColorsFromURL:colorsURL fileFormat:DYEFileFormatJSON completionHandler:nil];
}

/// Load styles from a JSON file in the bundle
- (void)loadLocalStylesFile {
    NSURL *stylesURL = [[NSBundle mainBundle] URLForResource:@"styles" withExtension:@"json"];
    [DYEStyle importStylesFromURL:stylesURL fileFormat:DYEFileFormatJSON completionHandler:nil];
}

/// Load styles from an online url
- (void)loadOnlineStylesFile {
    NSURL *stylesURL = [NSURL URLWithString:@"https://mydomain.com/styles.json"];
    [DYEStyle importStylesFromURL:stylesURL fileFormat:DYEFileFormatJSON completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            // Do something
        }
    }];
}

/// Add a style to a label
- (void)applySingleStyle {
    UILabel *label = [[UILabel alloc] init];
    label.dyeStyleName = @"h1";
}

/// Add styles to a button for multiple control states
- (void)applyMultipleStyles {
    UIButton *button = [[UIButton alloc] init];
    button.dyeStyleName = @"button";
    [button setDyeStyleName:@"button_highlighted" forState:UIControlStateHighlighted];
}

@end
