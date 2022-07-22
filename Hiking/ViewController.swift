//
//  ViewController.swift
//  Hiking
//
//  Created by OscarYen on 2018/12/14.
//  Copyright © 2018 OscarYen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts
import CoreData
import StoreKit
import GoogleMobileAds

let PRODUCT_ID = "com.oscaryen.Hiking_VIP"

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,annalViewControllerDelegate,SKPaymentTransactionObserver, SKProductsRequestDelegate, SubscriptionInfoDelegate,GADBannerViewDelegate{
 
    @IBOutlet weak var Firsttbv: UIView!
    @IBOutlet weak var Secondtbv: UITableView!
    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var btnSubscription: UIButton!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblSubscription: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @Published private(set) var purchasedIdentifiers = Set<String>()
    
    public enum StoreError: Error {
        case failedVerification
    }
    var data2 : [Note] = []
    var vip: Bool = false
    var receipt: String = ""
    //21008表示生产换使用  21007表示测试环境使用
    var state = 21008
    var expires_date = ""
    var m_oSubscriptionInfo: SubscriptionInfoView?
    let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixNavigationBar()
        m_oSubscriptionInfo = SubscriptionInfoView(nibName: "SubscriptionInfoView", bundle: nil)
        lblSubscription.text =
        "iTunes每週訂閱方案: [HikingVIP]\n\n訂閱解鎖看新聞資訊\n\n$10TWD/每週 "
        self.Secondtbv.backgroundView = UIImageView(image: UIImage(named: "depositphotos.jpg"))
        self.Secondtbv.backgroundView?.alpha = 0.2
        self.Secondtbv.backgroundView?.contentMode = .scaleAspectFit
        Thread.sleep(forTimeInterval: 0.5)
        
        btnCheck.setImage(UIImage(named: "check"), for: .selected)
        btnCheck.setImage(UIImage(named: "uncheck"), for: .normal)
        btnCheck.setTitle("", for: .selected)
        btnCheck.setTitle("", for: .normal)
        
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-8113349784134636/9986765456"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.paymentTransactionPurchased()
        if #available(iOS 15.0, *) {
        var updateListenerTask: Task<Void, Error>? = nil
            updateListenerTask = listenForTransactions()
        }
        btnSubscription.isEnabled = false
        btnCheck.isSelected = false
        
        Segment.selectedSegmentIndex = 0
        Firsttbv.isHidden = Segment.selectedSegmentIndex == 0 ? false : true
        Secondtbv.isHidden =  Segment.selectedSegmentIndex == 1 ? false : true
        subscriptionView.isHidden = Segment.selectedSegmentIndex == 0 ? checkVip() : true
        self.navigationItem.rightBarButtonItem?.isEnabled =  false
        self.navigationItem.rightBarButtonItem?.tintColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setLoading(false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.Secondtbv.setEditing(editing, animated: true)
        saveCoreDate()
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contacts = UIContextualAction(style: .normal, title: "分享") { (action, sourceView, completionHandler) in
            let defautText = "我選的這條" + self.data2[indexPath.row].text! + "只是其中一條而已唷！！"
            let activityController = UIActivityViewController(activityItems: [defautText], applicationActivities: nil)
            self.present(activityController, animated:true ,completion: nil)
            completionHandler(true)
            
        }
        
        contacts.backgroundColor = UIColor.orange
        //contacts.image = UIImage(named: "Download")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [contacts])
        return swipeConfiguration
        
    }
    
    func didfinishUpdate(note: Note) {
        if let index = self.data2.firstIndex(of: note){
            let indexPath = IndexPath(row: index, section: 0)
            self.Secondtbv.reloadRows(at: [indexPath], with: .automatic)
            saveCoreDate()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
//        loadCoreDate()
    }
    
    @IBAction func ADD(_ sender: Any) {
        switch Segment.selectedSegmentIndex {
        case 0:
            let controller = UIAlertController(title: "新增項目", message: "請點選上方的：紀錄與規劃\n 方便使用者新增項目", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            break
        case 1:
            let moc = CoreDataHelper.shared.managedObjectContext()
            let name = Note  (context: moc)
            name.text = "NEW"
            let indexPath = IndexPath(row: 0, section: 0)
            self.data2.insert(name, at: 0)
            self.Secondtbv.insertRows(at: [indexPath], with: .automatic)
            print("新增")
            saveCoreDate()
        default:
            break
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data2.count
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let data = self.data2.remove(at: indexPath.row)
            CoreDataHelper.shared.managedObjectContext().delete(data)
            self.Secondtbv.deleteRows(at: [indexPath], with: .automatic)
            saveCoreDate()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Secondtbv.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath)
        let note2 = self.data2[indexPath.row]
        cell.textLabel?.text = note2.text
        cell.detailTextLabel?.text = note2.text2
        cell.imageView?.image = note2.thumbnailImage()
        cell.showsReorderControl = true
        return cell
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch Segment.selectedSegmentIndex {
        case 0 :
           
            self.navigationItem.rightBarButtonItem?.isEnabled =  false
            self.navigationItem.rightBarButtonItem?.tintColor = .clear
            
            print("第一格")
            setLoading(false)
        case 1 :
            
            self.navigationItem.rightBarButtonItem?.isEnabled =  true
            self.navigationItem.rightBarButtonItem?.tintColor = .blue
            
            print("第二格")
            setLoading(false)
        default:
            break
        }
        
        Firsttbv.isHidden = Segment.selectedSegmentIndex == 0 ? false : true
        Secondtbv.isHidden =  Segment.selectedSegmentIndex == 1 ? false : true
        subscriptionView.isHidden = Segment.selectedSegmentIndex == 0 ? checkVip() : true
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row=\(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DataSegue"{
            let noteVC = segue.destination as! annalViewController
            if let indexPath = self.Secondtbv.indexPathForSelectedRow{
                noteVC.currentNote = self.data2[indexPath.row]
                noteVC.delegate = self
            }
        }
        
    }
    func saveCoreDate(){
        CoreDataHelper.shared.saveContext()
    }
    
    func loadCoreDate(){
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<Note>(entityName:"Note")
        moc.performAndWait {
            do{
                let result = try moc.fetch(fetchRequest)
                self.data2 = result
            }catch{
                self.data2 = []
            }
        }
        DispatchQueue.main.async {
            self.Firsttbv.isHidden = self.Segment.selectedSegmentIndex == 0 ? false : true
            self.Secondtbv.isHidden =  self.Segment.selectedSegmentIndex == 1 ? false : true
            self.subscriptionView.isHidden = self.Segment.selectedSegmentIndex == 0 ? self.checkVip() : true
        }
       
    }
    
    func checkVip() -> Bool {
        return vip
        
    }
    
    @IBAction func SubscriptionClick(_ sender: UIButton) {
       self.setLoading(true)
        subscripClick()
    }
    
//MARK: IAP
    
    //MARK:发起购买请求
        func startPay(proId:String,resultBlock:@escaping ((_ result:String)->Void))  {
            if !SKPaymentQueue.canMakePayments() {
                print("不可使用苹果支付")
                return
            }
            //监听购买结果
            
            let set = Set.init([PRODUCT_ID])
            let requst = SKProductsRequest.init(productIdentifiers: set)
            
            requst.delegate = self
            requst.start()
            SKPaymentQueue.default().add(self)
        }
    
    
     //MARK:发起购买请求回调代理方法
         func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
             let productArray = response.products
             if productArray.count == 0 {
                 self.view.showToast(toastMessage: "此商品id没有对应的商品", duration: 3)
                 return
             }
             var product:SKProduct!
             for pro in productArray {
                 if pro.productIdentifier == PRODUCT_ID {
                     product = pro
                     break
                 }
             }
             print(product.description)
             print(product.localizedTitle)
             print(product.localizedDescription)
             print(product.price)
             print(product.priceLocale)
             
             let payment = SKMutablePayment.init(product: product)
             payment.quantity = 1
//             var uuid: String = ""
//             if AccountManager.shared.isLogin() {
//                 uuid = AccountManager.shared.getUserId()
//             }
             
            SKPaymentQueue.default().add(payment)
             
            
         }
    
    //MARK:购买结果 监听回调
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for tran in transactions {
                switch tran.transactionState {
                case .purchased://购买完成
                    completePay(transaction: tran)
//                    self.refreshToken()
                    break
                case.purchasing: //商品添加进列表
                    self.view.showToast(toastMessage: "交易推遲, 等待外部操作", duration: 3)
                   
                    break
                case.restored://已经购买过该商品
                    self.view.showToast(toastMessage: "買過了，但不跳Alert", duration: 3)
                    
                    completePay(transaction: tran)
//                    SKPaymentQueue.default().finishTransaction(tran)
                    break
                case.failed://购买失败
                    self.view.showToast(toastMessage: "购买失败", duration: 3)
//                    completePay(transaction: tran)
                    failedTransaction(transaction: tran)
                    break
                case.deferred: //延期？
                    self.view.showToast(toastMessage: "延期", duration: 3)
                    print("deferred 延期 deferred")
                    break
                default:
                    
                    break
                }
            }

        }
    
    //MARK:购买成功验证凭证
        func completePay(transaction:SKPaymentTransaction) {
            //获取交易凭证
            let recepitUrl = Bundle.main.appStoreReceiptURL
            let data = try! Data.init(contentsOf: recepitUrl!)
            if recepitUrl == nil {
                print("交易凭证为空")
                return
            }
            
//            if verify_type == 0 {//客户端验证
//                verify(data: data,transaction: transaction)
//            } else {
//                //服务器端校验
//            }
            
            verify(data: data,transaction: transaction)
            
            if (transaction.transactionState != .purchasing)
            {
                //记得关闭交易事件
                // Unrelated code removed
//                SKPaymentQueue.default().remove(self)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    
    //沙盒验证地址
    let url_receipt_sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
//    let url_receipt_sandbox = "https://api.storekit-sandbox.itunes.apple.com/inApps/v1/history/5"
    //生产环境验证地址
    let url_receipt_itunes = "https://buy.itunes.apple.com/verifyReceipt"
    
    //MARK:客户端验证
        func verify(data:Data,transaction:SKPaymentTransaction)  {
            let base64Str = data.base64EncodedString(options: [])
            self.receipt = "\(base64Str)"
            let params = NSMutableDictionary()
            UserDefaults.myToken = self.receipt
            params["receipt-data"] = base64Str
            params["password"] = "7304b3ac9f01484892ed5a729700d937"
            params["exclude-old-transactions"] = true
            let body = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            var request = URLRequest.init(url: URL.init(string: state == 21008 ? url_receipt_itunes : url_receipt_sandbox)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
            request.httpMethod = "POST"
            request.httpBody = body
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if data != nil {
                    let dict = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    
                    if dict["pending_renewal_info"] != nil {
                        let renewalInfo = dict["pending_renewal_info"] as! [AnyObject]
                        var renewData: [String:String] = [:]
                        for i in renewalInfo {
                            if i["product_id"] as! String == PRODUCT_ID {
                                renewData = i as! [String : String]
                            }
                        }
                        
                        let receiptInfo = dict["latest_receipt_info"] as! [AnyObject]
                        let receiptInfoData = receiptInfo[0] as! [String:String]
                        self.expires_date = receiptInfoData["expires_date_ms"] ?? ""
                    }
                    
                    let status = dict["status"] as! Int
                    switch(status){
                    case 0:
                        let expires = (self.expires_date as NSString).integerValue
                        if (expires / 1000) > Int(Date().timeIntervalSince1970) {
                            self.view.showToast(toastMessage: "購賣成功", duration: 3)
                            self.vip = true
                        }
                        self.setLoading(false)
                        self.loadCoreDate()
                        break
                    case 21007:
                        print("此收據來自測試環境，但發送到生產環境進行驗證，應將其發送到測試環境")
                        self.state = 21007
                        self.verify(data: data!, transaction: transaction)
                        break
                    case 21000 :
                        print("App Store 無法讀取你提供的JSON對象")
                        break
                    case 21002 :
                        print("receipt-data 屬性中的數據格式錯誤或丟失")
                        break
                    case 21003 :
                        print("無法認證收據")
                        break
                    case  21004 :
                        print("你提供的共享密碼與你帳戶存檔的共想密鑰不批配")
                        break
                    case  21005 :
                        print("收據服務器當前不可用")
                        break
                    case  21006 :
                        print("此收據有效。但是訂閱過期")
                        break
                    case   21008 :
                        print("此收據來自生產環境，但發送到測試環境進行驗證，應將其發送到生產環境")
                        self.state = 21008
                        self.verify(data: data!, transaction: transaction)
                        break
                    case   21010 :
                        print("此收據無法獲得授權，對待此收據的方式與從未進行過的任何交易時的處理方式相同")
                        break
                   
                    default:
                        print("內部數據錯誤")
                        break
                    }
                    //移除监听
                    self.setLoading(false)
                    SKPaymentQueue.default().remove(self)
                }
            }
            
            task.resume()

        }
    
    func checkPriceProcess() {
        self.startPay(proId: PRODUCT_ID) { result in
            print("CheckPriceProcess End")
            
        }
    }
    
    @objc func subscripClick() {
        self.startPay(proId: "com.oscaryen.Hiking_VIP") { result in
            print("購買程序結束")
        }
       }
       
    
    func mengersubscrip() {
       //確認狀態，如果有，就跳重複消費
        //沒有就跳一個空的頁面
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
        UIApplication.shared.open(url)
    
    }
    
    //恢復購買
    func restore() {
        let refresh = SKReceiptRefreshRequest()
        refresh.delegate = self
        refresh.start()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // 復原購買失敗
     func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
         print("復原購買失敗...")
         print(error.localizedDescription)
     }

     // 回復購買成功(若沒實作該 delegate 會有問題產生)
     func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
         print("復原購買成功...")
     }
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

        print("identifier: \(productIdentifier)")
        SKPaymentQueue.default().restoreCompletedTransactions()
//        SKPaymentQueue.default().finishTransaction(transaction)
    }

    
    //发起内购请求失败
        func request(_ request: SKRequest, didFailWithError error: Error) {
            print("发起内购失败，失败原因：\(error.localizedDescription)")
            
            let tem_error = error as NSError
            
            #if DEBUG
            print("2.发起内购失败，失败Domain：\(tem_error.domain),失败code: \(tem_error.code),失败描述：\(tem_error.localizedDescription),失败信息: \(tem_error.userInfo)")
           
            #endif
            let parameter: [String:String] = [
                "state":"failed",
                "msg":"2.发起内购失败，失败Domain：\(tem_error.domain),失败code: \(tem_error.code),失败描述：\(tem_error.localizedDescription),失败信息: \(tem_error.userInfo)","isShowAlert":"1","isShowDialog":"1"]

            print("\(parameter)")
            
        }
    
    //交易失败
        func failedTransaction(transaction: SKPaymentTransaction) {
            self.setLoading(false)
            let error = transaction.error as? SKError
            
            var message :String?
            var isShowAlert = "0"//是否显示toast
            var isShowDialog = "1"//是否显示Dialog
            
            if let code = error?.code {
                switch code {
                case .unknown:
                    message = "未知错误"
                case .clientInvalid:
                    message = "Client is not allowed to issue the request, etc"
                case .paymentCancelled:
                    //取消
                    message = "User cancelled the request, etc"
                    isShowAlert = "1"
                    isShowDialog = "0"
                case .paymentInvalid:
                    message = "Purchase identifier was invalid, etc"
                case .paymentNotAllowed:
                    //设备不支持支付
                    message = "This device is not allowed to make the payment"
                    isShowAlert = "1"
                    isShowDialog = "0"
                case .storeProductNotAvailable:
                    message = "Product is not available in the current storefront"
                case .cloudServicePermissionDenied:
                    message = "User has not allowed access to cloud service information"
                case .cloudServiceNetworkConnectionFailed:
                    message = "The device could not connect to the nework"
                case .cloudServiceRevoked:
                    message = "User has revoked permission to use this cloud service"
                case .privacyAcknowledgementRequired:
                    message = "The user needs to acknowledge Apple's privacy policy"
                case .unauthorizedRequestData:
                    message = "The app is attempting to use SKPayment's requestData property, but does not have the appropriate entitlement"
                case .invalidOfferIdentifier:
                    message = "The specified subscription offer identifier is not valid"
                case .invalidSignature:
                    message = "The cryptographic signature provided is not valid"
                case .missingOfferParams:
                    message = "One or more parameters from SKPaymentDiscount is missing"
                case .invalidOfferPrice:
                    message = "The price of the selected offer is not valid (e.g. lower than the current base subscription price)"
                case .overlayCancelled:
                    message = "OverlayCancelled"
                case .overlayInvalidConfiguration:
                    message = "OverlayInvalidConfiguration"
                case .overlayTimeout:
                    message = "OverlayTimeout"
                case .ineligibleForOffer:
                    message = "User is not eligible for the subscription offer"
                case .unsupportedPlatform:
                    //平台不支持支付
                    message = "UnsupportedPlatform"
                    isShowAlert = "1"
                    isShowDialog = "0"
                default:
                    message = "Default"
                }
            }
            
            #if DEBUG
            print( "4.交易失败，失败原因：*****\(String(describing: message))******")
            #endif
            print("transaction_failed")
                if message != nil {
                    let parameter: [String:String] = [
                                             "state":"failed",
                        "msg": message ?? "","isShowAlert":isShowAlert,"isShowDialog":isShowDialog]
                    print("\(parameter)")
                }else{
                    let description = transaction.error?.localizedDescription
                    let parameter: [String:String] = [
                                             "state":"failed",
                                             "msg": description ?? "","isShowAlert":"0","isShowDialog":"1"]
                    print("\(parameter)")
                }
            
            
//            SKPaymentQueue.default().finishTransaction(transaction)
        }
    
    
    @available(iOS 15.0, *)
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)

                    //Deliver content to the user.
                    await self.updatePurchasedIdentifiers(transaction)

                    //Always finish a transaction.
                    print("\(transaction)")
                    
                    await transaction.finish()
                } catch {
                    //StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @available(iOS 15.0, *)
    func purchase(_ product: Product) async throws -> Transaction? {
        //Begin a purchase.
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            //Deliver content to the user.
            await updatePurchasedIdentifiers(transaction)

            //Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    @available(iOS 15.0.0, *)
    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        //Get the most recent transaction receipt for this `productIdentifier`.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            //If there is no latest transaction, the product has not been purchased.
            return false
        }

        let transaction = try checkVerified(result)

        //Ignore revoked transactions, they're no longer purchased.

        //For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        //tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        //tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }

    @available(iOS 15.0, *)
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            //If the transaction is verified, unwrap and return it.
            print("\(result)")
            return safe
        }
    }
    
    @available(iOS 15.0, *)
    @MainActor
    func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            //If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            purchasedIdentifiers.insert(transaction.productID)
            
        } else {
            //If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
            purchasedIdentifiers.remove(transaction.productID)
            print("\(transaction.productID)")
        }
    }
    
    func paymentTransactionPurchased() {
        print("paymentTransactionPurchased")
//            验证购买，避免越狱软件模拟苹果请求达到非法购买问题
//           guard let receiptUrl = Bundle.main.appStoreReceiptURL,let receiptData = try? Data(contentsOf: receiptUrl) else {
//
//              return
//           }
        setLoading(true)
        let receiptUrl = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptUrl ?? URL(fileURLWithPath: ""))
        let receiptStr = receiptData?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
        self.receipt = receiptStr ?? ""
        self.verifyByMyself()
       }
        
    
    //主動確認
     func verifyByMyself() {
        expires_date = ""
        let params = NSMutableDictionary()
        UserDefaults.myToken = self.receipt
        params["receipt-data"] = self.receipt
        params["password"] = "7304b3ac9f01484892ed5a729700d937"
        params["exclude-old-transactions"] = true
        let body = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = URLRequest.init(url: URL.init(string: state == 21008 ? url_receipt_itunes : url_receipt_sandbox)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.httpBody = body
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if data != nil {
                let dict = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary

                if dict["pending_renewal_info"] != nil {
                    let renewalInfo = dict["pending_renewal_info"] as! [AnyObject]
                    var renewData: [String:String] = [:]
                    for i in renewalInfo {
                        if i["product_id"] as! String == PRODUCT_ID {
                            renewData = i as! [String : String]
                        }
                    }
                    
                    let receiptInfo = dict["latest_receipt_info"] as! [AnyObject]
                    let receiptInfoData = receiptInfo[0] as! [String:String]
                    self.expires_date = receiptInfoData["expires_date_ms"] ?? ""
                }
                
                let status = dict["status"] as! Int
                switch(status){
                case 0:
                    let expires = (self.expires_date as NSString).integerValue
                    if (expires / 1000) > Int(Date().timeIntervalSince1970) {
                        self.view.showToast(toastMessage: "购买成功", duration: 3)
                        self.vip = true
                    } else {
                        self.view.showToast(toastMessage: "過期", duration: 3)
                        self.vip = false
                    }
                    self.loadCoreDate()
                    self.setLoading(false)
                    break
                case 21007:
                    print("此收據來自測試環境，但發送到生產環境進行驗證，應將其發送到測試環境")
                    self.state = 21007
                    break
                case 21000 :
                    print("App Store 無法讀取你提供的JSON對象")
                    
                    break
                case 21002 :
                    print("receipt-data 屬性中的數據格式錯誤或丟失")
                    
                    break
                case 21003 :
                    print("無法認證收據")
                   
                    break
                case  21004 :
                    print("你提供的共享密碼與你帳戶存檔的共想密鑰不批配")
                  
                    break
                case  21005 :
                    print("收據服務器當前不可用")
                  
                    break
                case  21006 :
                    print("此收據有效。但是訂閱過期")
                   
                    break
                case   21008 :
                    print("此收據來自生產環境，但發送到測試環境進行驗證，應將其發送到生產環境")
                    self.state = 21008
                    break
                case   21010 :
                    print("此收據無法獲得授權，對待此收據的方式與從未進行過的任何交易時的處理方式相同")
                   
                    break

                case 21105:
                    
                    print("沒有可用於應用內購買的信息。稍後再試。")
                    
                default:
                    print("內部數據錯誤")
                    
                    break
                }
                //移除监听
                self.setLoading(false)
                SKPaymentQueue.default().remove(self)
            }
            
        }
           
        task.resume()
    }
    
    func setLoading(_ show : Bool) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = !show
            if show {
                self.activity.startAnimating()
            } else {
                self.activity.stopAnimating()
            }
        }
        
    }
    
    func UIShowSubscriptionInfo(_ bShow: Bool) {
        if let oView = m_oSubscriptionInfo {
            oView._delegate = self
            Segment.isHidden = bShow
            DialogShow(oView, bShow)
        }
    }
    
    func SubscriptionInfoOk() {
        UIShowSubscriptionInfo(false)
    }
    
    @IBAction func openSubscriptionInfo(_ sender: Any) {
        UIShowSubscriptionInfo(true)
    }
    
    private func DialogShow(_ oView: UIViewController , _ bShow:Bool) {
        if(bShow) {
            self.view.addSubview(oView.view)
            oView.view.center = self.view.center
            oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            oView.view.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                
                oView.view.alpha = 1
                oView.view.transform = CGAffineTransform.identity
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                oView.view.alpha = 0
                
            }) { (success:Bool) in
                oView.view.removeFromSuperview()
            }
        }
    }
    
    func fixNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.darkGray
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
        }
    }
    
    @IBAction func checkClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnSubscription.isEnabled = sender.isSelected ? true : false
    }
    @IBAction func toWeb(_ sender: Any) {
        btnSubscription.isEnabled = true
        btnCheck.isSelected = true
        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
            UIApplication.shared.open(url)
        }
    }
    
  
    // MARK: - GADBannerViewDelegate
     // Called when an ad request loaded an ad.
     func adViewDidReceiveAd(_ bannerView: GADBannerView) {
       print(#function)
     }

     // Called when an ad request failed.
     func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: NSError) {
       print("\(#function): \(error.localizedDescription)")
     }

     // Called just before presenting the user a full screen view, such as a browser, in response to
     // clicking on an ad.
     func adViewWillPresentScreen(_ bannerView: GADBannerView) {
       print(#function)
     }

     // Called just before dismissing a full screen view.
     func adViewWillDismissScreen(_ bannerView: GADBannerView) {
       print(#function)
     }

     // Called just after dismissing a full screen view.
     func adViewDidDismissScreen(_ bannerView: GADBannerView) {
       print(#function)
     }

     // Called just before the application will background or exit because the user clicked on an
     // ad that will launch another application (such as the App Store).
     func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
       print(#function)
     }
   
}
