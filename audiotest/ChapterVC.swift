//
//  ChapterVC.swift
//  audiotest
//
//  Created by Purpose Code on 12/02/20.
//  Copyright © 2020 EmojiView. All rights reserved.
//

import UIKit
import SwiftAudio
import AVFoundation
import MediaPlayer


class ChapterVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var storeDetailsModel: StoryDetailsModel?
    
    private var isScrubbing: Bool = false
    private let controller = AudioController.shared
    private var lastLoadFailed: Bool = false
    
    
    

    @IBOutlet weak var collectionViewChapter: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("huuuuuuu")
        
        
         self.controller.sources = [DefaultAudioItem]()
        getStoryDetails()
    }

    
    func getStoryDetails(){
    
        let devicId = UIDevice.current.identifierForVendor?.uuidString
        struct StoryEncode: Encodable{
            let record_id: String?
            let device_id: String?
        }
        
        let parms = StoryEncode(record_id: "53", device_id: devicId)
        let url = URL(string: "https://www.hautruongsao365.com/_api/record/store_detail")!
        let request = NSMutableURLRequest(url: url)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parms)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("ERROR")
        }
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                return
            }
            guard let data = data else {
                return
                
            }
            guard let strList = try? JSONDecoder().decode(StoryDetailsModel.self, from: data) else {
                print("Error: Couldn't decode data into storeDetailsModel array")
                return
            }
            self.storeDetailsModel = strList
            if let storeData = self.storeDetailsModel?.data{
                
                
            
                
                
                for music in storeData.record_item
                {
                    if let musicUrl = music.url_src{
                        
                        let musicLink = "https://www.hautruongsao365.com/" + musicUrl
                        
                       
                        self.controller.sources?.append(DefaultAudioItem(audioUrl: musicLink, artist: music.name, title: music.name, albumTitle: music.name, sourceType: .stream, artwork: nil))

                        print(music)
                   //     self.musicArr.append("https://www.hautruongsao365.com/" + musicUrl)
                    }
                }
                try? self.controller.audioSessionController.set(category: .playback)
                try? self.controller.player.add(items: self.controller.sources ?? [], playWhenReady: false)
                
                print(self.controller.sources?.count)
                DispatchQueue.main.async {
                    self.collectionViewChapter.reloadData()
                }
            }
          
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeDetailsModel?.data?.record_item.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    let cell: chapterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! chapterCell
        if let dict = storeDetailsModel?.data?.record_item[indexPath.row]{
                        cell.chapter.text = dict.name
                    }
        
                    return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
    
                let width:CGFloat =  100
    
                return CGSize(width: width, height: width)
          
    
        }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    

        print("am pressed")
    
                UserDefaults.standard.set(true, forKey: "isPlaying")
        
        
        print(controller.sources?.count)
        if let audioItem = controller.sources?[indexPath.row]{
            print("am inside")
        //    try? controller.player.load(item: audioItem, playWhenReady: true)
            
            try? controller.player.jumpToItem(atIndex: indexPath.row)
            print(controller.player.currentItem)
            print(controller.player.currentIndex)
        }
                  
        
//        if let data = self.storeDetailsModel?.data{
//
//
//
//
//            if let musicUrl = data.record_item[indexPath.row].url_src{
//
////
////                let audioItem = DefaultAudioItem(audioUrl: "https://www.hautruongsao365.com/" + musicUrl, sourceType: .stream)
//
//
//
//
//
//            }
//        }
//
                    
        }
                    
       
}



//
//class StoryDetailsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GADInterstitialDelegate {
//
//
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var chapterHeight: NSLayoutConstraint!
//    @IBOutlet weak var ratingView: CosmosView!
//
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var ratingCountLabel: UILabel!
//    @IBOutlet weak var totalListen: UILabel!
//    @IBOutlet weak var kindLabel: UILabel!
//    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var storyImage: UIImageView!
//    @IBOutlet weak var titlelabel: UILabel!
//    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet weak var authorLabel: UILabel!
//    @IBOutlet weak var voiceRead: UILabel!
//    @IBOutlet weak var detailViewConstant: NSLayoutConstraint!
//
//    @IBOutlet weak var collectionViewMore: UICollectionView!
//    @IBOutlet weak var collectionViewChapters: UICollectionView!
//    var selectedIndex = 0
//    var storyId: String?
//    var imageString: String?
//    var storyTitle: String?
//    var storeList: [Store]?
//
//
//    var storeDetailsModel = StoryDetailsModel()
//    var musicArr: [String] = []
//    var isRefreshing = false
//    var timer = Timer()
//    var interstitial: GADInterstitial!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//        setUpLabels()
//        interstitial = createAndLoadInterstitial()
//
//        ratingView.settings.fillMode = .precise
//        if let url = imageString{
//
//        let string = Constants.addToImage + url
//              let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            let imageUrl = URL(string: urlString)
//            self.storyImage.kf.setImage(with: imageUrl)
//        }
//        if let stTitle = storyTitle{
//            self.titlelabel.text = stTitle
//        }
//        getStoryDetails()
//
//    }
//
//    func setUpLabels(){
//
//        self.title = "Thông Tin Truyện"
//
//        self.authorLabel.text = "Tác giả: "
//        self.voiceRead.text = "Giọng đọc: "
//        self.statusLabel.text = "Trạng thái: "
//        self.categoryLabel.text = "Chủ đề: "
//        self.kindLabel.text = "Thể loại: "
//        self.totalListen.text = "Số lượt nghe: "
//        self.ratingCountLabel.text = "(" + " lượt đánh giá" + ")"
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        self.scrollView.refreshControl = UIRefreshControl()
//        self.scrollView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
//
//    }
//    @objc func refresh(sender:AnyObject) {
//        isRefreshing = true
//        getStoryDetails()
//
//    }
//
//    //google adsense
//    func createAndLoadInterstitial() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        interstitial.delegate = self
//        interstitial.load(GADRequest())
//        return interstitial
//    }
//
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        interstitial = createAndLoadInterstitial()
//    }
//
//    func getStoryDetails(){
//        if !isRefreshing{
//            SVProgressHUD.show(withStatus: "Please wait...")
//            SVProgressHUD.setDefaultMaskType(.clear)
//        }
//        let devicId = UIDevice.current.identifierForVendor?.uuidString
//        struct StoryEncode: Encodable{
//            let record_id: String?
//            let device_id: String?
//        }
//
//        let parms = StoryEncode(record_id: storyId, device_id: devicId)
//        let url = URL(string: "https://www.hautruongsao365.com/_api/record/store_detail")!
//        let request = NSMutableURLRequest(url: url)
//        let encoder = JSONEncoder()
//        do {
//            let jsonData = try encoder.encode(parms)
//            request.httpBody = jsonData
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        } catch {
//            print("ERROR")
//        }
//        request.httpMethod = "POST"
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//            if error != nil {
//                self.stopSpinner()
//                return
//            }
//            guard let data = data else {
//                self.stopSpinner()
//                return
//
//            }
//            guard let strList = try? JSONDecoder().decode(StoryDetailsModel.self, from: data) else {
//                self.stopSpinner()
//                print("Error: Couldn't decode data into storeDetailsModel array")
//                return
//            }
//            self.storeDetailsModel = strList
//            self.getStorieList()
//            if let storeData = self.storeDetailsModel.data{
//                for music in storeData.record_item
//                {
//                    if let musicUrl = music.url_src{
//                        self.musicArr.append(Constants.addToImage + musicUrl)
//                    }
//                }
//            }
//            DispatchQueue.main.async {
//                self.setUpUI()
//                self.setChapterCollectionViewHeight()
//            }
//        }
//        task.resume()
//    }
//
//
//    func getStorieList(){
//        if !isRefreshing{
//            SVProgressHUD.show(withStatus: "Please wait...")
//            SVProgressHUD.setDefaultMaskType(.clear)
//        }
//
//        let parms = StoreEncode(offset: 0, limit: 11, type: "listen_most")
//        ApiService.callStories(addOnUrl: "record/list_story", params: parms) { (value) in
//
//            let data = value.data
//
//            do
//            {
//                if let jsonData = data
//                {
//                    let parsedData = try JSONDecoder().decode(StoreListModel.self, from: jsonData)
//
//                    if parsedData.status == 200{
//                        self.storeList?.removeAll()
//                        self.storeList = parsedData.data
//
//                        DispatchQueue.main.async{
//                            if self.scrollView.refreshControl?.isRefreshing ?? false
//                            {
//                                self.scrollView.refreshControl?.endRefreshing()
//                            }
//                            self.collectionViewMore.reloadData()
//                            SVProgressHUD.dismiss()
//                            self.isRefreshing = false
//                        }
//                    }
//                }
//            }
//            catch
//            {
//                self.stopSpinner()
//                print("Parse Error: \(error)")
//            }
//        }
//    }
//
//    func stopSpinner(){
//        DispatchQueue.main.async{
//            SVProgressHUD.dismiss()
//        }
//    }
//
//    func setChapterCollectionViewHeight(){
//        if let count = storeDetailsModel.data?.record_item.count{
//            let rowCount =  getRowCount(count: count)
//            self.chapterHeight.constant = CGFloat(rowCount * 60)
//
//        }
//    }
//    func getRowCount(count: Int)-> Int{
//        let rowCount = count / 7
//
//        if (count % 7 == 0){
//            return rowCount
//        }else{
//            return rowCount + 1
//        }
//
//    }
//    func setUpUI(){
//        if let detail = self.storeDetailsModel.data{
//            if let url = detail.img_src{
//
//
//                 let string = Constants.addToImage + url
//                       let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                     let imageUrl = URL(string: urlString)
//                     self.storyImage.kf.setImage(with: imageUrl)
//
//            }
//            self.titlelabel.text = detail.name
//            self.authorLabel.text = "Tác giả: " + getAuthorNames(details: detail)
//
//            if let voic = detail.voice_read{
//                self.voiceRead.text = "Giọng đọc: " + voic
//            }else{
//                self.voiceRead.text = "Giọng đọc: "
//            }
//            if let kind =  detail.kind_name{
//                self.statusLabel.text = "Trạng thái: " + kind
//            }else{
//                self.statusLabel.text = "Trạng thái: "
//            }
//
//
//
//            self.categoryLabel.text = "Chủ đề: " + getCatogoryNames(details: detail)
//            self.kindLabel.text = "Thể loại: " + (detail.kind_name)!
//
//            if let rating = detail.avg_rating{
//                self.ratingView.rating = Double(rating)
//            }
//
//            if let listen = detail.total_listen{
//                self.totalListen.text = "Số lượt nghe: " + String(listen)
//            }
//
//            if let totalCount = detail.total_rating{
//                self.ratingCountLabel.text = ("(" + String(totalCount) + " lượt đánh giá" + ")")
//            }else{
//                self.ratingCountLabel.text = "(" + " lượt đánh giá" + ")"
//            }
//            self.descriptionLabel.text = detail.description
//
//            if self.scrollView.refreshControl?.isRefreshing ?? false
//            {
//                self.scrollView.refreshControl?.endRefreshing()
//            }
//            self.collectionViewChapters.reloadData()
//
//        }
//
//    }
//    func setUpConstants(detail: StoryDetail){
//        Constants.songImage = (detail.img_src)!
//        Constants.songTitile = (detail.name)!
//        Constants.authorName = getAuthorNames(details: detail)
//    }
//
//
//    func getAuthorNames(details: StoryDetail)-> String{
//        var authorNames = ""
//        if let authorList = details.list_author{
//            if authorList.count > 1{
//                for nameDict in authorList{
//                    if let name = nameDict.name{
//                        authorNames = authorNames + "," + name
//                    }
//                }
//            }else{
//                if let auth = authorList[0].name{
//                    authorNames = auth
//                }
//            }
//        }
//        return authorNames
//    }
//    func getCatogoryNames(details: StoryDetail)-> String{
//        var catogry = ""
//        if let catLlist = details.list_category{
//            if catLlist.count > 1{
//                print(catLlist.count)
//                for nameDict in catLlist{
//                    if let name = nameDict.name{
//                        catogry = catogry + "," + name
//                    }
//                }
//            }else{
//                if let auth = catLlist[0].name{
//                    catogry = auth
//                }
//            }
//        }
//        return catogry
//    }
//
//
//
//
//    //MARK: COLLECTION VIEW
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == collectionViewChapters{
//            guard let itemCount = storeDetailsModel.data?.record_item.count else{
//                return 0
//            }
//            return itemCount
//        }else{
//            return storeList?.count ?? 0
//        }
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == collectionViewChapters{
//            let cell: ChapterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterCell", for: indexPath) as! ChapterCell
//            if let dict = storeDetailsModel.data?.record_item[indexPath.row]{
//                cell.chapterTitle.text = dict.name
//            }
//
//            return cell
//        }
//        let cell: MoreStoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreStoriesCell", for: indexPath) as! MoreStoriesCell
//        if let dict = storeList?[indexPath.row]{
//
//
//
//            if let img = dict.img_src{
//
//                        let imagURL = Constants.addToImage + img
//              let urlString = imagURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//
//
//                        let url = URL(string: urlString)
//
//                        cell.storyImage.kf.indicatorType = .activity
//                        cell.storyImage.kf.setImage(
//                            with: url,
//                            placeholder: UIImage(named: "placeholderImage"),
//                            options: [
//                                .transition(.fade(1)),
//                                .cacheOriginalImage
//                            ])
//                    }
//
//
//
//            cell.storyTitle?.text = dict.name
//
//            var authersName = ""
//            if let authors = dict.list_author{
//                for author in authors{
//                    if let authrName = author.name{
//                        authersName = authersName + authrName
//                    }
//                }
//                cell.storyAuthor.text = authersName
//            }
//        }
//
//
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collectionViewChapters{
//
//            let width:CGFloat =  (UIScreen.main.bounds.size.width - 45)  / 7
//
//            return CGSize(width: width, height: width)
//        }
//
//        let width:CGFloat =  (UIScreen.main.bounds.size.width - 30)  / 3
//        return CGSize(width: width, height: width * 1.4
//        )
//
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        } else {
//            print("Ad wasn't ready")
//        }
//
//        if collectionView == collectionViewChapters{
//            UserDefaults.standard.set(true, forKey: "isPlaying")
//            if let data = self.storeDetailsModel.data{
//                setUpConstants(detail: data)
//            }
//            selectedIndex = indexPath.row
//            AudioPlayerManager.shared.play(urlStrings: self.musicArr, at: indexPath.row)
//        }
//    }
//
//
//    @IBAction func xemThemPressed(_ sender: Any) {
//
//        self.descriptionLabel.numberOfLines = 0
//        descriptionLabel.sizeToFit()
//           let ht = descriptionLabel.frame.height
//        detailViewConstant.constant = 303 + ht - 36
//
////              let descriptVC = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionVC") as!  DescriptionVC
////            descriptVC.store = storeDetailsModel.data
////        self.navigationController?.pushViewController(descriptVC, animated: true)
//
//    }
//
//}
