//
//  UIView+Extension.swift
//  Hiking
//
//  Created by Oscar Yen on 2022/7/22.
//  Copyright © 2022 OscarYen. All rights reserved.
//

import Foundation
import UIKit

//MARK: Add Toast method function in UIView Extension so can use in whole project.
extension UIView
{
    func showToast(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.0))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0.1, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                bgView.alpha = 0
            })
            bgView.removeFromSuperview()
        })
        

//        UIView.animate(withDuration: TimeInterval(duration), delay: 0.1, options: .curveEaseOut, animations: {
//            lblMessage.alpha = 0.0
//        }, completion: {(isCompleted) in
//            bgView.removeFromSuperview()
//        })
    }
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    func scrollYFrame(offset: CGFloat) {
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y: (self.frame.origin.y + offset), width: self.bounds.width, height: self.bounds.height)
        }, completion: nil)
    }
    
    
     func showToastLandscape(toastMessage:String,duration:CGFloat)
        {
            //View to blur bg and stopping user interaction
            let bgView = UIView(frame: self.frame)
            bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.0))
            bgView.tag = 555
            
            //Label For showing toast text
            let lblMessage = UILabel()
            lblMessage.numberOfLines = 0
            lblMessage.lineBreakMode = .byWordWrapping
            lblMessage.textColor = .white
            lblMessage.backgroundColor = .black
            lblMessage.textAlignment = .center
            lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
            lblMessage.text = toastMessage
            
            //calculating toast label frame as per message content
            let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.height, height: self.bounds.size.width)
            var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
            // UILabel can return a size larger than the max size when the number of lines is 1
            expectedSizeTitle = CGSize(width:maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height), height: maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width))
            lblMessage.frame = CGRect(x: self.bounds.size.width * 0.05 , y: self.bounds.size.height * 0.3, width:  self.bounds.size.width * 0.5 , height: self.bounds.size.width * 0.1)
            lblMessage.layer.cornerRadius = 8
            lblMessage.layer.masksToBounds = true
            lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            bgView.addSubview(lblMessage)
            self.addSubview(bgView)
            lblMessage.alpha = 0
            
            UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0.1, options: [] , animations: {
                lblMessage.alpha = 1
            }, completion: {
                sucess in
                UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                    bgView.alpha = 0
                })
                bgView.removeFromSuperview()
            })
        }
    
    func showToastStepView(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.0))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height * 0.9), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0.1, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                bgView.alpha = 0
            })
            bgView.removeFromSuperview()
        })
        
        
    }
    
    

    func takeLongshot(_ targetview: UIScrollView) -> UIImage {
        var image: UIImage? = nil
        
        let currentContentOffSet:CGPoint = targetview.contentOffset
        let currentFrame:CGRect = self.frame
        
        targetview.contentOffset = CGPoint.zero
        self.frame = CGRect.init(x: 0, y: 0, width: targetview.contentSize.width, height: targetview.contentSize.height * 1.2)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.frame.width, height: self.frame.height), true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        targetview.contentOffset = currentContentOffSet
        self.frame = currentFrame
        
        UIGraphicsEndImageContext()
        
        return image!

       
    }

}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }}}

extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}
