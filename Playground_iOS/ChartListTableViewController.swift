//
//  ChartListTableViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/23/15.
//
//

import UIKit
import SSChartwell_iOS

class ChartListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController!.delegate = self
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


