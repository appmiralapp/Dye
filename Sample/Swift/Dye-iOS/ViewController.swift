//
//  ViewController.swift
//  Dye-iOS
//

import UIKit
import Dye

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// Create a simple text style in code
    func createTextStyle() {
        let h1Style = DYEStyle.init(name: "h1")
        h1Style.fontSize = 18.0
        h1Style.fontName = "Courier New"
        h1Style.primaryColor = .black
        
        // Add to the global cache
        DYEStyle.add(h1Style, withName: h1Style.dyeStyleName)
    }
    
    /// Create a style in code that inherits from an existing style
    func createInheritingStyle() {
        let h1UnderlineStyle = DYEStyle.init(name: "h1_underlined", parentStyleName: "h1")
        h1UnderlineStyle.textUnderline = true
        
        // Add to the global cache
        DYEStyle.add(h1UnderlineStyle, withName: h1UnderlineStyle.dyeStyleName)
    }
    
    /// Create a style in code with a background gradient
    func createGradientStyle() {
        let gradientStyle = DYEStyle.init(name: "gradient")
        gradientStyle.backgroundGradientColors = [
            DYEColors.colorNamed("jonquil")!,
            DYEColors.colorNamed("pumpkin")!,
            DYEColors.colorNamed("spanish_carmine")!
        ]
        
        // Diagonal gradient, top left to bottom right
        gradientStyle.backgroundGradientStartPoint = CGPoint.init(x: 0, y: 0)
        gradientStyle.backgroundGradientStartPoint = CGPoint.init(x: 1, y: 1)
        
        // Add to the global cache
        DYEStyle.add(gradientStyle, withName: gradientStyle.dyeStyleName)
    }
    
    /// Load  colors from a JSON file in the bundle
    func loadLocalColorsFile() {
        let colorsURL = Bundle.main.url(forResource: "colors", withExtension: "json")
        DYEColors.import(from: colorsURL!, fileFormat: .JSON, completionHandler: nil)
    }
    
    /// Load styles from a JSON file in the bundle
    func loadLocalStylesFile() {
        let stylesURL = Bundle.main.url(forResource: "styles", withExtension: "json")
        DYEStyle.importStyles(from: stylesURL!, fileFormat: .JSON, completionHandler: nil)
    }
    
    /// Load styles from an online url
    func loadOnlineStylesFile() {
        let stylesURL = URL.init(string: "https://mydomain.com/example/styles.json")
        DYEStyle.importStyles(from: stylesURL!, fileFormat: .JSON, completionHandler: nil)
    }
    
    /// Add a style to a label
    func applySingleStyle() {
        let label = UILabel.init()
        label.dyeStyleName = "h1"
    }
    
    /// Add styles to a button for multiple control states
    func applyMultipleStyles() {
        let button = UIButton.init()
        button.dyeStyleName = "button"
        button.setDyeStyleName("button_highlighted", for: .highlighted)
    }

}

