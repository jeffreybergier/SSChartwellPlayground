//
//  ChartSourceListViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/27/15.
//
//

import Cocoa
import SSChartwell_macOS

class ChartSourceListViewController: NSViewController {
    
    @IBOutlet private weak var tableView: NSOutlineView?
    private weak var detailViewController: ChartDetailViewController?
    
    private let data: [[[String : String]]] = [
        [
            ["Header" : "Horizontal Charts"],
            ["Item" : "Vertical Bars"],
            ["Item" : "Horizontal Bars"],
            ["Item" : "Lines"]
        ],
        [
            ["Header" : "Circular Charts"],
            ["Item" : "Rings"],
            ["Item" : "Pies"],
            ["Item" : "Radar"],
            ["Item" : "Rose"]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentViewController?.childViewControllers.forEach() { vc in
            if let vc = vc as? ChartDetailViewController {
                self.detailViewController = vc
            }
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.tableView?.expandItem(.None, expandChildren: true)
            self.tableView?.selectRowIndexes(NSIndexSet(index: 1), byExtendingSelection: false)
        }
    }
    
}

extension ChartSourceListViewController: NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        if let selectedIndex = self.tableView?.selectedRowIndexes.firstIndex,
            let item = ((self.tableView?.itemAtRow(selectedIndex) as? NSDictionary)?["Item"] as? String) {
                switch item {
                case "Rings":
                    self.detailViewController?.chartStyle = .Rings
                case "Pies":
                    self.detailViewController?.chartStyle = .Pies
                case "Radar":
                    self.detailViewController?.chartStyle = .Radar
                case "Rose":
                    self.detailViewController?.chartStyle = .Rose
                case "Vertical Bars":
                    self.detailViewController?.chartStyle = .BarsVertical
                case "Horizontal Bars":
                    self.detailViewController?.chartStyle = .Bars
                case "Lines":
                    self.detailViewController?.chartStyle = .Lines
                default:
                    break
                }
        }
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        let dictionary = (item as? NSDictionary)
        if let _ = dictionary?["Header"] as? String {
            return false
        } else if let _ = dictionary?["Item"] as? String {
            return true
        }
        fatalError()
    }
}

extension ChartSourceListViewController: NSOutlineViewDataSource {
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item  {
            if let header = (item as? NSDictionary)?["Header"] as? String {
                if header == self.data[1][0]["Header"] {
                    return self.data[1].count - 1
                } else if header == self.data[0][0]["Header"] {
                    return self.data[0].count - 1
                }
            }
        } else {
            return self.data.count
        }
        fatalError()
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        let dictionary = (item as? NSDictionary)
        if let _ = dictionary?["Header"] as? String {
            return true
        } else if let _ = dictionary?["Item"] as? String {
            return false
        }
        fatalError()
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let item = item  {
            if let header = (item as? NSDictionary)?["Header"] as? String {
                if header == self.data[1][0]["Header"] {
                    return self.data[1][index + 1]
                } else if header == self.data[0][0]["Header"] {
                    return self.data[0][index + 1]
                }
            }
        } else {
            return self.data[index][0]
        }
        fatalError()
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let dictionary = item as? NSDictionary
        if let value = dictionary?["Header"] as? String {
            let cell = outlineView.makeViewWithIdentifier("HeaderCell", owner: outlineView) as? NSTableCellView
            cell?.textField?.stringValue = value
            return cell!
        } else if let value = dictionary?["Item"] as? String {
            let cell = outlineView.makeViewWithIdentifier("DataCell", owner: outlineView) as? NSTableCellView
            cell?.textField?.stringValue = value
            return cell!
        }
        fatalError()
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return item
    }
}