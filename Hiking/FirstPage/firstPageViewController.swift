


import UIKit
import Alamofire
import Kanna
import Kingfisher

class firstPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var firsttbv: UITableView!
    
    var xmlURL: String!
    var session:URLSession?
    var myTitle :[String] = []
    var mySubtitle :[String] = []
    var myImage :[String] = []
    var myUrl : [String] = []
    lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(requestData),for: .valueChanged)
        return refreshControl
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.firsttbv.rowHeight = 70
        firsttbv.refreshControl = refresher
        firsttbv.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "更新加載中.....")
        self.firsttbv.backgroundView = UIImageView(image: UIImage(named: "20181123173316_692480.jpg"))
        self.firsttbv.backgroundView?.alpha = 0.2
        self.firsttbv.backgroundView?.contentMode = .scaleAspectFill
        
    }
    
    @objc func requestData(){
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTitle.count
        
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.view.endEditing(true)
        return indexPath
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = firsttbv.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath)
        cell.textLabel?.text = self.myTitle[indexPath.row]
        cell.detailTextLabel?.text = self.mySubtitle[indexPath.row]
        let note2 = self.myImage[indexPath.row]
        let placeholderImage = UIImage(named: "depositphotos.jpg")
        let url = URL(string: note2)
        cell.imageView?.frame.size = CGSize(width: 108, height: 80)
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 108, height: 80))
        cell.imageView?.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
        return cell
    }
    
    @objc func loadData(){
        let xmlURL = "https://www.travelking.com.tw/news/list.asp"
        Alamofire.request(xmlURL).responseData{(response) in
            if let data = response.data {
                for i in 1...10 {
                    if let doc = try? Kanna.XML(xml:data,encoding:.utf8){
                        for node in doc.xpath("//*[@id=\"content\"]/div[1]/div[2]/div[1]/div[3]/div[1]/section[" +  "\(i)" + "]/div[1]/h3"){
                            print(node.text ?? "")
                            self.myTitle.append(node.text!)
                        }
                        for node in doc.xpath("//*[@id=\"content\"]/div[1]/div[2]/div[1]/div[3]/div[1]/section[" +  "\(i)" + "]/div[1]/p"){
                            print(node.text ?? "")
                            self.mySubtitle.append(node.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                        for node in doc.xpath("//*[@id=\"content\"]/div[1]/div[2]/div[1]/div[3]/div[1]/section[" +  "\(i)" + "]/figure"){
                            print(node["data-src"] ?? "")
                            self.myImage.append(node["data-src"]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                        }
                        for node in doc.xpath("//*[@id=\"content\"]/div[1]/div[2]/div[1]/div[3]/div[1]/section[" +  "\(i)" + "]/a"){
                            print(node["href"] ?? "")
                            self.myUrl.append( "https://www.travelking.com.tw" + (node["href"] ?? "") )
                        }
                        DispatchQueue.main.async{
                            self.firsttbv.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSugue" {
            guard let webVC = segue.destination as? WebViewController,
                  let row = self.firsttbv.indexPathForSelectedRow?.row
            else { return }
            let note1 = self.myUrl[row]
            webVC.xmlURL = note1
        }
    }
}

