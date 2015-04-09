//
//  AcceptDragView.swift
//  SVGO
//
//  Created by Ray on 4/1/15.
//  Copyright (c) 2015 RayPS. All rights reserved.
//

import Cocoa

class AcceptDragView: NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.

//         NSColor.whiteColor().setFill()
//         NSRectFill(dirtyRect)
        
        NSImage(named: "background")?.drawInRect(dirtyRect, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForDraggedTypes([NSFilenamesPboardType]);
    }
    
    
    override func draggingEntered(sender:NSDraggingInfo)->NSDragOperation{
        
        return NSDragOperation.Copy;
        // return NSDragOperation.Generic;
        // return NSDragOperation.Link;
    }
    
    
    override func performDragOperation(sender:NSDraggingInfo)->Bool{
        var pboard:NSPasteboard! = sender.draggingPasteboard()
        if pboard != nil {
            pboard = sender.draggingPasteboard()
            if contains(pboard.types as [NSString],NSFilenamesPboardType) {
                var files:[String] = pboard.propertyListForType(NSFilenamesPboardType) as [String]
                println(files)
                
                
                pdf2png("--dpi", "48", "--transparent", files[0])
                pdf2png("--dpi", "72", "--transparent", files[0])
                
                
                
            }
            return true
        }
        return false
    }
    
    
    
    
    
    func pdf2png(args: String...) -> Int32 {
        let task = NSTask()
        task.launchPath = NSBundle.mainBundle().pathForResource("pdf2png", ofType: nil) as String!
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
