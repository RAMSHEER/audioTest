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

                    
        }
                    
       
}

