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

    //unfinish, need to code later
    //"/Users/donghanhu/Documents/Reflect/2019-2-14-3/test.json" and "Screenshot-1.27.25 PM.jpg"
    func BasedOnJsonPath(jsonpath : String, screenshot : String) -> Dictionary<String, Any>{
        //open this json path
        //use a string array to store information
        let informationarray = [String]()
        var returnDictionary = [String : Any]()
        let rawData : NSData = try! NSData(contentsOf: URL(fileURLWithPath: jsonpath))
        do{
            let jsonDataDictionary = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String: Any]]
            let length = jsonarray.count
            print(length)
            //the first is initial information, which should not be considered
            for i in 1..<length{
                
                //print(jsonarray[i])
                var photoname = jsonarray[i]["photo-name"] as! String
                print(photoname)
                photoname.remove(at: photoname.startIndex)
                print(photoname)
                if photoname == screenshot{
                    returnDictionary = jsonarray[i]
                    //print("dictionary")
                    //print(returnDictionary)
                    break
                    //return returnDictionary
                }
            }
            
        }catch{print(error)}
        //print(returnDictionary)
        return returnDictionary
    }
    
    
    //end of the class
}
