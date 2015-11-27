//
//  ChartDetailViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/27/15.
//
//

import Cocoa

class ChartDetailViewController: NSViewController {
    
    @IBOutlet private weak var animateButton: NSButton?
    @IBOutlet private weak var generateButtons: NSButton?
    @IBOutlet private weak var chartImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animateButton?.title = "Animate!"
        self.generateButtons?.title = "Generate Random Data"
    }
    
    @IBAction private func animateButtonClicked(sender: NSButton?) {
        print("animateButtonClicked: \(sender)")
    }
    
    @IBAction private func generateButtonClicked(sender: NSButton?) {
        print("generateButtonClicked: \(sender)")
    }
}
