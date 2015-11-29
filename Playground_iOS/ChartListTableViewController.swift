//
//  ChartListTableViewController.swift
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

class ChartListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC = segue.destinationViewController as? UINavigationController,
            let detailVC = navVC.viewControllers.first as? ChartDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    detailVC.chartStyle = .BarsVertical
                case 1:
                    detailVC.chartStyle = .Bars
                case 2:
                    detailVC.chartStyle = .Lines
                default:
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    detailVC.chartStyle = .Rings
                case 1:
                    detailVC.chartStyle = .Pies
                case 2:
                    detailVC.chartStyle = .Radar
                case 3:
                    detailVC.chartStyle = .Rose
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Vertical Bars"
            case 1:
                cell.textLabel?.text = "Horizontal Bars"
            case 2:
                cell.textLabel?.text = "Lines"
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Rings"
            case 1:
                cell.textLabel?.text = "Pies"
            case 2:
                cell.textLabel?.text = "Radar"
            case 3:
                cell.textLabel?.text = "Rose"
            default:
                break
            }
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Horizontal Charts"
        case 1:
            return "Circular Charts"
        default:
            return .None
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath)
    }
    
    private enum StoryBoardSegues: String {
        case BarsVerticalSegue, LinesSegue, BarsHorizontalSegue, RingsSegue, PiesSegue, RadarSegue, RoseSegue
    }
}

extension ChartListTableViewController: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        if let secNavController = secondaryViewController as? UINavigationController,
            let detailVC = secNavController.viewControllers.last as? ChartDetailViewController
            where detailVC.chartStyle == nil
        {
            return true
        }
        
        return false
    }
}


