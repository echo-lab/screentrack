//
//  FindTheLatestScreenShot.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/28/19.
//

import Foundation

@available(OSX 10.13, *)
class FindScreenShot : NSObject{
    

    func GetListOfFiles(){
        let fileManager = FileManager.default
        let Defaultpath = Settings.DefaultFolder
        //Defaultpaht is a URL
        do{
            let directoryContents = try FileManager.default.contentsOfDirectory(at: Defaultpath(), includingPropertiesForKeys: nil, options: [])
            let length = directoryContents.count
            print(length)
            print(directoryContents)
        }catch{
            print(error)
        }
    }
    
    
    
    //end of the class
}
