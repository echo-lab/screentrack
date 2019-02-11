//
//  GetRelatedInformation.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/11/19.
//

import Foundation

extension String {
        func indicesOf(string: String) -> [Int] {
            var indices = [Int]()
            var searchStartIndex = self.startIndex
            
            while searchStartIndex < self.endIndex,
                let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
                !range.isEmpty
            {
                let index = distance(from: self.startIndex, to: range.lowerBound)
                indices.append(index)
                searchStartIndex = range.upperBound
            }
            
            return indices
        }
}
class RelatedInformation{
    //return the json file path in the same folder of this image full path
    func BasedOnImagePathToFindJsonFile(photoname : String) -> String{
        //photoname is the path of this photo
        //for example /Users/donghanhu/Documents/Reflect/2019-2-11-4/Screenshot-1.22.11 PM.jpg
        let keyword = String("/")
        let array = photoname.indicesOf(string : keyword!)
        let length = array.count
        let endofstring = array[length - 1]
        let folderpath = photoname.prefix(endofstring)
        let jsonfilepath = folderpath + "/" + "test.json"
        //return value is string
        return jsonfilepath
        
    }
    //return image name based on the image full path
    func BasedOnImagePathToFindtheImageName(photoname : String) -> String{
        let keyword = String("/")
        let array = photoname.indicesOf(string : keyword!)
        let length = array.count
        let endofstring = array[length - 1]
        let pathlength = photoname.count
        let substringlength = pathlength - endofstring - 1
        let imagename = photoname.suffix(substringlength)
        //return value is string
        return String(imagename)
    }

    func BasedOnJsonPath(jsonpath : String){
        //open this json path
        

        
    }
    
    
    //end of the class
}
