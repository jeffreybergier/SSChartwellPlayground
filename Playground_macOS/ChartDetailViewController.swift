//
//  ChartDetailViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/27/15.
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

import Cocoa
import SSChartwell_macOS

class ChartDetailViewController: NSViewController {
    
    @IBOutlet private weak var animateButton: NSButton?
    @IBOutlet private weak var chartImageView: NSImageView?
    @IBOutlet private weak var generateButton: NSButton?
    @IBOutlet private weak var chartImageScrollView: NSScrollView?
    @IBOutlet private weak var zoomOutButton: NSButton?
    @IBOutlet private weak var zoomInButton: NSButton?
    
    var chartStyle: Chart.Style? {
        didSet {
            guard let chartStyle = self.chartStyle else { return }
            let components = chartStyle.rawValue.generateRandomData()
            let data = chartStyle.rawValue.init(components: components)
            self.chartData = data
        }
    }
    
    private var zoomState = ZoomState.CanZoomInAndOut {
        didSet {
            switch self.zoomState {
            case .CanZoomInAndOut:
                self.zoomInButton?.enabled = true
                self.zoomOutButton?.enabled = true
            case .CanZoomIn:
                self.zoomInButton?.enabled = true
                self.zoomOutButton?.enabled = false
            case .CanZoomOut:
                self.zoomInButton?.enabled = false
                self.zoomOutButton?.enabled = true
            }
        }
    }
    
    private enum ZoomState {
        case CanZoomIn, CanZoomOut, CanZoomInAndOut
    }
    
    private var chartData: ChartDataType? {
        didSet {
            self.chartStaticImage = .None
            
            if let chartData = self.chartData {
                let fontSize: CGFloat
                switch chartData.dynamicType.style {
                case .Bars:
                    fontSize = 200
                case .Lines:
                    fontSize = 200
                case .BarsVertical:
                    fontSize = 250
                default:
                    fontSize = 300
                }
                let renderer = Chart.Renderer(data: chartData, fontSize: fontSize)
                self.chartStaticImage = renderer?.PDFImage
                self.animateButton?.enabled = false
            }
        }
    }
    
    private var chartStaticImage: NSImage? {
        didSet {
            self.chartImageView?.image = self.chartStaticImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scrollView = self.chartImageScrollView {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollViewBoundsDidChange:", name: NSScrollViewDidEndLiveScrollNotification, object: scrollView)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollViewBoundsDidChange:", name: NSScrollViewDidEndLiveMagnifyNotification, object: scrollView)
            
        } else {
            fatalError()
        }
        
        self.animateButton?.title = "Animate!"
        self.generateButton?.title = "Generate Random Data"
    }
    
    @IBAction private func animateButtonClicked(sender: NSButton?) {
        print("animateButtonClicked: \(sender)")
    }
    
    @IBAction private func generateButtonClicked(sender: NSButton?) {
        let oldStyle = self.chartStyle
        self.chartStyle = oldStyle
    }
    
    @IBAction func magnifyingGlassButtonClicked(sender: NSButton?) {
        self.chartImageScrollView?.magnification = 1.0
        self.scrollViewDidChange()
    }
    
    @IBAction func zoomOutButtonClicked(sender: NSButton?) {
        guard let scrollView = self.chartImageScrollView else { return }
        let originalZoom = scrollView.magnification
        let newMagnification = originalZoom - (originalZoom * 0.5)
        scrollView.magnification = newMagnification
        self.scrollViewDidChange()
    }
    
    @IBAction func zoomInButtonClicked(sender: NSButton?) {
        guard let scrollView = self.chartImageScrollView else { return }
        let originalZoom = scrollView.magnification
        let newMagnification = originalZoom + (originalZoom * 0.5)
        scrollView.magnification = newMagnification
        self.scrollViewDidChange()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension ChartDetailViewController {
    private func scrollViewDidChange() {
        guard let scrollView = self.chartImageScrollView else { return }
        let min = scrollView.minMagnification
        let max = scrollView.maxMagnification
        let current = scrollView.magnification
        
        if min == current {
            self.zoomState = .CanZoomIn
        } else if max == current {
            self.zoomState = .CanZoomOut
        } else {
            self.zoomState = .CanZoomInAndOut
        }
    }
    
    @objc private func scrollViewBoundsDidChange(aNotification: NSNotification?) {
        self.scrollViewDidChange()
    }
}
