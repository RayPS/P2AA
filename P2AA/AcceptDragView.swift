//
//  AcceptDragView.swift
//  P2AA
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
            if contains(pboard.types as! [NSString],NSFilenamesPboardType) {
                var files:[String] = pboard.propertyListForType(NSFilenamesPboardType) as! [String]
                
                
                for file in files{
                    var fileLocation   = file.stringByDeletingLastPathComponent //path/to/the/file
                    var fileName       = file.lastPathComponent                 //filename.ext
                    var filePrefix     = fileName.stringByDeletingPathExtension //filename
                    var fileExtension  = fileName.pathExtension                 //ext
                    
                    
                    if (fileExtension == "pdf")
                    {
                        
                        for (dpi_name: String, dpi_size: JSON) in Resolutions {

                            var drawableFolder = "\(fileLocation)/drawable-\(dpi_name)"
                            
                            mkdir(drawableFolder)
                            
                            pdf2png("--dpi",
                                    dpi_size.string!,
                                    "--transparent",
                                    file,
                                    "--output",
                                    "\(drawableFolder)/\(filePrefix).png")
                        }
                    }
                    else
                    {
                        NSApp.abortModal()
                        let alert:NSAlert = NSAlert()
                        alert.alertStyle = .WarningAlertStyle
                        alert.messageText = "Not a PDF file"
                        alert.informativeText = "\(file)"
                        alert.addButtonWithTitle("Dismiss")
                        //alert.delegate = self
                        alert.beginSheetModalForWindow(window!) { responseCode in
                            if NSAlertSecondButtonReturn == responseCode {
                                //println("SecondButton")
                            }
                        }
                        
                            
                    }
                    
                }
                
                
            }
            return true
        }
        return false
    }
    
    
    
    func mkdir(args: String...) -> Int32 {
        // I don't know how to create a folder with Swift :(
        let task = NSTask()
        task.launchPath = "/bin/mkdir"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    func pdf2png(args: String...) -> Int32 {
        // github.com/kaorukobo/pdf2png-mac
        let task = NSTask()
        task.launchPath = NSBundle.mainBundle().pathForResource("pdf2png", ofType: nil) as String!
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
}
