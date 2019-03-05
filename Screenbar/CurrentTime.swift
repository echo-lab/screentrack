//
//  CurrentTime.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/4/19.
//

import Foundation

class Current : NSObject{
    
    func currentTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "M-d, HH:mm:ss"
        let temp = dateFormatter.string(from: NSDate() as Date)
        print(temp)
    }
    
}
