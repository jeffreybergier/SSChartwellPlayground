//
//  ChartDetailViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/23/15.
//
//  Copyright © 2015 Jeffrey Bergier.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
