//
//  ChartDetailViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/23/15.
//
//

import UIKit
import SSChartwell_iOS

class ChartDetailViewController: UIViewController {
    
    @IBOutlet private weak var chartImageView: UIImageView?
    @IBOutlet private weak var animateButton: UIButton?
    @IBOutlet private weak var generateButton: UIButton?
    
    var chartStyle: Chart.Style?
    
    private var chartData: ChartDataType? {
        didSet {
            if let chartData = self.chartData {
                let renderer = Chart.Renderer(data: chartData, fontSize: 250)
                self.chartStaticImage = renderer?.image
                renderer?.generateAnimatedImagesWithFrameCount(30) { images in
                    self.chartAnimatedImages = images
                }
            } else {
                self.chartStaticImage = .None
                self.chartAnimatedImages = .None
            }
        }
    }
    private var chartStaticImage: UIImage? {
        didSet {
            self.chartImageView?.image = self.chartStaticImage
        }
    }
    private var chartAnimatedImages: [UIImage]? {
        didSet {
            self.animateButton?.enabled = (self.chartAnimatedImages != nil) ? true : false
            self.chartImageView?.animationImages = self.chartAnimatedImages
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let chartStyle = self.chartStyle else {
            self.animateButton?.hidden = true
            self.generateButton?.hidden = true
            return
        }
        
        self.title = "\(chartStyle.associatedType)"
        
        self.chartImageView?.animationDuration = 3
        self.chartImageView?.animationRepeatCount = 1
        
        self.animateButton?.enabled = false
        
        if let components = self.generateRandomData(chartStyle) {
            let data = chartStyle.associatedType.init(components: components)
            self.chartData = data
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.chartAnimatedImages = .None
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.chartData = .None
    }
    
    @IBAction private func animateButtonTapped(sender: UIButton) {
        if let _ = self.chartImageView?.animationImages {
            self.chartImageView?.startAnimating()
        }
    }
    
    @IBAction private func generateButtonTapped(sender: UIButton) {
        self.chartData = .None
        if let chartStyle = self.chartStyle, let components = self.generateRandomData(chartStyle) {
            let data = chartStyle.associatedType.init(components: components)
            self.chartData = data
        }
    }
    
    private func generateRandomData(style: Chart.Style?) -> [ChartDataComponentType]? {
        guard let style = style else { return .None }
        let componentType = style.associatedType.componentType
        
        let newComponents: [ChartDataComponentType] = [
            componentType.init(value: 10, color: UIColor.redColor().CGColor),
            componentType.init(value: 20, color: UIColor.blueColor().CGColor),
            componentType.init(value: 310, color: UIColor.yellowColor().CGColor),
            componentType.init(value: 40, color: UIColor.greenColor().CGColor),
            componentType.init(value: 50, color: UIColor.blackColor().CGColor),
            componentType.init(value: 60, color: UIColor.grayColor().CGColor),
            componentType.init(value: 70, color: UIColor.darkGrayColor().CGColor),
            componentType.init(value: 80, color: UIColor.lightGrayColor().CGColor),
            componentType.init(value: 90, color: UIColor.cyanColor().CGColor),
            componentType.init(value: 100, color: UIColor.magentaColor().CGColor),
            componentType.init(value: 55, color: UIColor.redColor().CGColor),
            componentType.init(value: 66, color: UIColor.blueColor().CGColor),
            componentType.init(value: 150, color: UIColor.blackColor().CGColor),
            componentType.init(value: 89, color: UIColor.grayColor().CGColor),
            componentType.init(value: 170, color: UIColor.darkGrayColor().CGColor),
            componentType.init(value: 22, color: UIColor.lightGrayColor().CGColor),
            componentType.init(value: 12, color: UIColor.cyanColor().CGColor),
            componentType.init(value: 45, color: UIColor.magentaColor().CGColor),
            componentType.init(value: 55, color: UIColor.redColor().CGColor),
            componentType.init(value: 66, color: UIColor.blueColor().CGColor)
        ]
        
        return newComponents
    }
    
    deinit {
        
    }
}
