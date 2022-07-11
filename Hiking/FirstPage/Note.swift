//
//  Note.swift
//  Hiking
//
//  Created by OscarYen on 2018/12/22.
//  Copyright © 2018 OscarYen. All rights reserved.
//

import Foundation
import UIKit
import CoreData


struct Demo : Codable {
    
    var myTitle :String
    var mySubtitle :String
    var myImage :String?
    var myUrl : String
 
    
func image() -> UIImage? {
    if let name  = self.myImage {
        let home = URL(fileURLWithPath: NSHomeDirectory())
        let doc = home.appendingPathComponent("Documents")
        let file = doc.appendingPathComponent(name)
        return UIImage(contentsOfFile: file.path)
    }
    return nil
    
}
func thumbnailImage() -> UIImage?{
    if let  image = self.image() {
        let thumbnaiSize = CGSize(width: 50, height: 50)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(thumbnaiSize, false, scale)
        let widthretio = thumbnaiSize.width/image.size.width
        let hightretio = thumbnaiSize.height / image.size.height
        let retio = max(widthretio,hightretio)
        let imageSize = CGSize(width: image.size.width*retio, height: image.size.height*retio)
        image.draw(in: CGRect(x: -(imageSize.width-thumbnaiSize.width)/2, y: -(imageSize.height-thumbnaiSize.height)/2, width: imageSize.width, height: imageSize.height))
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return smallImage
    }else{
        return nil
    }
}
}


class Note : NSManagedObject{
//    static func == (lhs: Note, rhs: Note) -> Bool {
//        return lhs.nameID == rhs.nameID
//    }
    
    @NSManaged var nameID : String
    @NSManaged var text : String?
    @NSManaged var text2 : String?
    @NSManaged var imageName : String?
    
    override func awakeFromInsert() {
        self.nameID = UUID().uuidString
    }
    func image() -> UIImage? {
        if let name  = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory())
            let doc = home.appendingPathComponent("Documents")
            let file = doc.appendingPathComponent(name)
            return UIImage(contentsOfFile: file.path)
        }
        return nil
            
        }
    func thumbnailImage() -> UIImage?{
        if let  image = self.image() {
            let thumbnaiSize = CGSize(width: 50, height: 50)
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(thumbnaiSize, false, scale)
            let widthretio = thumbnaiSize.width/image.size.width
            let hightretio = thumbnaiSize.height / image.size.height
            let retio = max(widthretio,hightretio)
            let imageSize = CGSize(width: image.size.width*retio, height: image.size.height*retio)
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: thumbnaiSize.width, height: thumbnaiSize.height))
            circlePath.addClip()
            image.draw(in: CGRect(x: -(imageSize.width-thumbnaiSize.width)/2, y: -(imageSize.height-thumbnaiSize.height)/2, width: imageSize.width, height: imageSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return smallImage
        }else{
            return nil
        }
    }
    
    
    
    
}

