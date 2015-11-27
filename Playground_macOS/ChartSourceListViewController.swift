//
//  ChartSourceListViewController.swift
//  SSChartwellPlayground
//
//  Created by Jeffrey Bergier on 11/27/15.
//
//

import Cocoa

class ChartSourceListViewController: NSViewController {
    
    @IBOutlet private weak var tableView: NSOutlineView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.tableView?.expandItem(.None, expandChildren: true)
        }
    }
    
}

extension ChartSourceListViewController: NSOutlineViewDataSource {
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item  {
            if let header = (item as? NSDictionary)?["Header"] as? String {
                if header == "Circular Charts" {
                    return 4
                } else if header == "Horizontal Charts" {
                    return 3
                }
            }
        } else {
            return 2
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
                if header == "Circular Charts" {
                    switch index {
                    case 0:
                        return ["Item" : "Rings"]
                    case 1:
                        return ["Item" : "Pies"]
                    case 2:
                        return ["Item" : "Radar"]
                    case 3:
                        return ["Item" : "Rose"]
                    default:
                        fatalError()
                    }
                } else if header == "Horizontal Charts" {
                    switch index {
                    case 0:
                        return ["Item" : "Vertical Bars"]
                    case 1:
                        return ["Item" : "Horizontal Bars"]
                    case 2:
                        return ["Item" : "Lines"]
                    default:
                        fatalError()
                    }
                }
            }
        } else {
            switch index {
            case 0:
                return ["Header" : "Horizontal Charts"]
            case 1:
                return ["Header" : "Circular Charts"]
            default:
                fatalError()
            }
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