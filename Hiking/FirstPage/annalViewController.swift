

import UIKit
protocol annalViewControllerDelegate : AnyObject {
    func didfinishUpdate(note:Note)
}


class annalViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    var list1  = ["北投區","文山區","內湖區","信義區",
           "士林區","中山區","南港區"]
        var place1  = ["忠義山步道","下青礐步道","郵政訓練所步道","中正山親山步道","軍艦岩步道","水尾巴拉卡步道","泉源里紗帽步道"]
        var place2  = ["仙跡岩步道1號路線","仙跡岩步道2號路線" ,"仙跡岩步道試院支線","仙跡岩步道麥田支線","指南宮步道",
            "飛龍步道","樟樹步道","樟湖步道","猴山岳步道"]
        var place3  = ["大崙頭山步道","金面山步道","忠勇山步道","忠勇山越嶺步道","龍船岩步道","鯉魚山步道"
          , "圓覺寺步道","大溝溪畔步道", "碧湖步道","白鷺鷥山步道"]
       var place4  = ["拇指山步道","虎山奉天宮步道","虎山120高地步道","虎山吉福宮步道","虎山生態步道","虎山自然步道"
            ,"虎山山腰步道","虎山溪步道","象山永春崗步道","象山北星寶宮步道","象山一線天步道"]
        var place5 = ["水管路步道","下竹林步道","婆婆橋步道","大崙頭山森林步道","大崙頭山自然步道"]
       var place6  = ["劍潭山步道主線","劍潭山步道劍潭公園副線"]
        var place7  = ["示範茶廠環山步道","桂花吊橋步道","更寮步道","栳寮步道","中華技術學院步道","九五峰步道"]
    //init
    var region : String = "北投區"
    var mountain : String = "忠義山步道"
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var currentNote : Note!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalPlace.text = self.currentNote.text
        finalTime.text = self.currentNote.text2
        annalImage.image =  self.currentNote.image() == nil ? UIImage(named: "下載.png") :  self.currentNote.image()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "067a.jpg")!)
        annalImage.layer.borderWidth = 1
        annalImage.layer.borderColor = UIColor.black.cgColor
        
        
    }
    @IBOutlet weak var myImagee: UIImageView!
    @IBOutlet weak var finalTime: UITextField!
    @IBAction func selectTime(_ sender: Any) {
        print("挑戰時間")
        finalTime.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.date = NSDate() as Date
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneClick1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancelClick1))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        finalTime.inputAccessoryView = toolBar
    }
    @objc func doneClick1()  {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        finalTime.text = dateFormatter.string(from: datePicker.date)
        self.currentNote.text2 = self.finalTime.text
        self.delegate?.didfinishUpdate(note:self.currentNote)
        print("\(datePicker.date)")
        self.view.endEditing(true)
        toolBar.endEditing(true)
        print("時間確認")
    }
    @objc func cancelClick1() {
        self.view.endEditing(true)
        toolBar.endEditing(true)
        print("時間取消")
    }
    
    
    
    
    @IBOutlet weak var myLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(component){
        case 0:
            return list1.count
        case 1:
            switch region {
            case "北投區":
                return place1.count
            case "文山區":
                return place2.count
            case "內湖區":
                return place3.count
            case "信義區":
                return place4.count
            case "士林區":
                return place5.count
            case "中山區":
                return place6.count
            case "南港區":
                return place7.count
            default:
                return 0
        }
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(component){
        case 0:
            return list1[row]
        case 1:
            switch region {
            case "北投區":
                return place1[row]
            case "文山區":
                return place2[row]
            case "內湖區":
                return place3[row]
            case "信義區":
                return place4[row]
            case "士林區":
                return place5[row]
            case "中山區":
                return place6[row]
            case "南港區":
                return place7[row]
            default:
                return nil
            }
        default:
            return nil
            }
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            region = list1[row]
            updateMountain(0)
            print("\(region)  \(mountain)")
            pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 1, animated: true)
        case 1:
            updateMountain(row)
            print("\(region)  \(mountain)")
            pickerView.reloadAllComponents()
        default:
            print("無")
        }
    }
    func updateMountain(_ row: Int){
        switch region {
        case "北投區":
           mountain = place1[row]
        case "文山區":
             mountain = place2[row]
        case "內湖區":
             mountain = place3[row]
        case "信義區":
             mountain = place4[row]
        case "士林區":
             mountain = place5[row]
        case "中山區":
             mountain = place6[row]
        case "南港區":
             mountain = place7[row]
        default:
            print("無")
        }
        }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if component == 0 {
            label.textColor = .darkGray
            label.textAlignment = .center
            label.text = String(self.list1[row])
            label.font = UIFont(name:"Helvetica", size: 20)
        } else {
            label.textColor = .red
            label.textAlignment = .center
            label.font = UIFont(name:"Helvetica", size: 20)
            switch  region {
                case "北投區":
                label.text = place1[row]
                case "文山區":
                label.text = place2[row]
                case "內湖區":
                label.text = place3[row]
                case "信義區":
                label.text = place4[row]
                case "士林區":
                label.text = place5[row]
                case "中山區":
                label.text = place6[row]
                case "南港區":
                label.text = place7[row]
                default:
                print("無")
            }
        }
        return label
    }
    let toolBar = UIToolbar()
    var PickerView = UIPickerView()
    @IBOutlet weak var finalPlace: UITextField!
    @IBAction func selectPlace(_ sender: Any) {
        print("挑戰地點")
        self.PickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        self.PickerView.delegate = self
        self.PickerView.dataSource = self
        self.PickerView.backgroundColor = UIColor.white
        
        finalPlace.inputView = self.PickerView
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        finalPlace.inputView = PickerView
        finalPlace.inputAccessoryView = toolBar
        }
    func spaceTextFieldDidBeginEditing(_ textField: UITextField) {
        self.selectPlace(PickerView)
    }
    var delegate : annalViewControllerDelegate?
    @objc func doneClick()  {
        finalPlace.text = ("\(region)"+" "+"\(mountain)")
        self.currentNote.text = self.finalPlace.text
        self.delegate?.didfinishUpdate(note:self.currentNote)
        self.view.endEditing(true)
        toolBar.endEditing(true)
        print("地點確認")
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.endEditing(true)
        print("地點取消")
    }
    @IBOutlet weak var annalImage: UIImageView!
    var myImageView = UIImageView()
    var isNewPhoto = false
    @IBAction func camera(_ sender: Any) {
        let camera = UIImagePickerController()
        camera.sourceType = .savedPhotosAlbum
        camera.sourceType = .camera
        camera.delegate = self
        
        present(camera, animated: true, completion: nil)
        
        
    }
    @IBAction func album(_ sender: Any) {
        let album = UIImagePickerController()
        album.sourceType = .savedPhotosAlbum
        album.delegate = self
        
        present(album, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
                self.annalImage.image = image
            
            self.isNewPhoto = true
            
        }
        self.dismiss(animated: true, completion: nil)
        if  self.isNewPhoto {
            if let imageData = self.annalImage.image?.jpegData(compressionQuality: 1){
                do{
                    let home = URL(fileURLWithPath: NSHomeDirectory())
                    let documents = home.appendingPathComponent("Documents")
                    let fileName = "\(self.currentNote.nameID).jpg"
                    let fileURL = documents.appendingPathComponent(fileName)
                    self.currentNote.imageName = fileName
                    try imageData.write(to: fileURL, options: [.atomicWrite])
                     self.delegate?.didfinishUpdate(note: self.currentNote)
                }catch{
                    print("寫入圖檔有錯 \(error)")
                }
                
            }
        }
    }
    

}
