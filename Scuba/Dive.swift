//
//  Dive.swift
//  Scuba
//
//  Created by Hubert Ka on 2018-01-07.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit
import os.log

class Dive: NSObject, NSCoding {
    
    //MARK: Properties
    var diveNumber: String
    var activity: String?
    var date: String?
    var location: String?
    var photo: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dives")
    
    //MARK: Types
    struct PropertyKey {
        // PropertyKey is created to limit mistakes when accessing keys, as programmer will have to use PropertyKey.key (i.e. PropertyKey.diveNumber) to indicate they were accessing a key, rather than simply designating a key (i.e. diveNumberKey) which can be easily mistyped. XCode will also help when accessing keys, as PropertyKey.diveNumber is now recognized and can be autotyped, whereas diveNumberKey can autotype to various other properties (i.e. diveNumber, diveNumberTextField, etc...)
        
        static let diveNumber = "diveNumber"
        static let activity = "activity"
        static let date = "date"
        static let location = "location"
        static let photo = "photo"
    }
    
    //MARK: Initialization
    init?(diveNumber: String, activity: String?, date: String?, location: String?, photo: UIImage?) {
        // The dive number must not be empty.
        guard !diveNumber.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.diveNumber = diveNumber
        self.activity = activity
        self.date = date
        self.location = location
        self.photo = photo
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(diveNumber, forKey: PropertyKey.diveNumber)
        aCoder.encode(activity, forKey: PropertyKey.activity)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The dive number is required. If we cannot decode a dive number string, the initializer should fail.
        guard let diveNumber = aDecoder.decodeObject(forKey: PropertyKey.diveNumber) as? String else {
            os_log("Unable to decode the dive number for a Dive object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because activity, date, location, and photo are optional properties of Dive, just use a conditional cast.
        let activity = aDecoder.decodeObject(forKey: PropertyKey.activity) as? String
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer.
        self.init(diveNumber: diveNumber, activity: activity, date: date, location: location, photo: photo)
    }
}
