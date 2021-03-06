//
//  Constants.swift
//  SporthEditor
//
//  Created by Kanstantsin Linou on 7/12/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import Foundation

struct Constants {
    struct Code {
        static let title = "Code Editor is Empty"
        static let message = "Put some code into and try again"
    }
    
    struct Name {
        static let title = "Name is Empty"
        static let message = "Type any name you want to save it with and try again"
    }
    
    struct File {
        static let chat = "chat"
        static let drone = "drone"
    }
    
    struct Path {
        static var chat: String {
            return NSBundle.mainBundle().pathForResource(Constants.File.chat, ofType: FileUtilities.fileExtension)!
        }
        static var drone: String {
            return NSBundle.mainBundle().pathForResource(Constants.File.drone, ofType: FileUtilities.fileExtension)!
        }
    }
    
    struct Error {
        static let Creation = "SporthEditor: Error while creating a local storage directory at path:"
        static let Loading = "SporthEditor: Error while loading presaved files: chat.sp or drone.sp"
        static let Saving = "SporthEditor: Saving was completed successfully"
    }
    
    struct Success {
        static let Saving = "SporthEditor: Saving was completed successfully"
    }
}