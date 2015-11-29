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
            self.chartStaticImage = .None
            self.chartAnimatedImages = .None
            
            if let chartData = self.chartData {
                let fontSize: CGFloat
                switch chartData.dynamicType.style {
                case .Bars:
                    fontSize = 25
                case .Lines:
                    fontSize = 100
                case .BarsVertical:
                    fontSize = 100
                default:
                    fontSize = 250
                }
                let renderer = Chart.Renderer(data: chartData, fontSize: fontSize)
                self.chartStaticImage = renderer?.image
                self.generateButton?.enabled = false
                renderer?.generateAnimatedImagesWithFrameCount(50) { images in
                    self.generateButton?.enabled = true
                    self.chartAnimatedImages = images
                }
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
        
        self.title = "\(chartStyle.rawValue)"
        
        self.chartImageView?.animationDuration = 2
        self.chartImageView?.animationRepeatCount = 1
        
        self.animateButton?.enabled = false
        
        let components = chartStyle.rawValue.generateRandomData()
        let data = chartStyle.rawValue.init(components: components)
        self.chartData = data
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
    
    @IBAction private func generateButtonTapped(sender: UIButton?) {
        sender?.enabled = false
        
        self.chartData = .None
        if let chartStyle = self.chartStyle {
            let components = chartStyle.rawValue.generateRandomData()
            let data = chartStyle.rawValue.init(components: components)
            self.chartData = data
        }
    }
}
