//
//  ChartDetailViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/27/15.
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
            if let components = self.generateRandomData(chartStyle) {
                let data = chartStyle.rawValue.init(components: components)
                self.chartData = data
            }
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
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollViewBoundsDidChange:", name: .None, object: scrollView)
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

extension ChartDetailViewController {
    private func generateRandomData(style: Chart.Style?) -> [ChartDataComponentType]? {
        guard let style = style else { return .None }
        let componentType = style.rawValue.componentType
        if let _ = style.rawValue as? ChartSumDataType.Type {
            let chartMaxValue = UInt(style.rawValue.max ?? 10)
            var componentCount = UInt(0)
            let lower : UInt32 = 1
            let upper : UInt32 = 30
            
            var components: [ChartDataComponentType] = []
            for _ in 0 ..< 100 {
                let value = UInt(arc4random_uniform(upper - lower) + lower)
                if (componentCount + value) <= chartMaxValue {
                    let color = NSColor.randomColor
                    let newComponent = componentType.init(value: value, color: color.CGColor)
                    components.append(newComponent)
                    componentCount += value
                } else {
                    break
                }
            }
            return components
        } else {
            let componentMaxValue = UInt32(componentType.max ?? 100)
            let chartMaxNumberComponents = Int(style.rawValue.max ?? 10)
            let lower : UInt32 = 0
            let upper : UInt32 = componentMaxValue
            
            var components: [ChartDataComponentType] = []
            for _ in 0 ..< Int(chartMaxNumberComponents) {
                let value = UInt(arc4random_uniform(upper - lower) + lower)
                let color = NSColor.randomColor
                let newComponent = componentType.init(value: value, color: color.CGColor)
                components.append(newComponent)
            }
            return components
        }
    }
}

extension NSColor {
    static var randomColor: NSColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
