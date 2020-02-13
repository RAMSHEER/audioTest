//
//  StryModel.swift
//  audiotest
//
//  Created by Purpose Code on 12/02/20.
//  Copyright © 2020 EmojiView. All rights reserved.
//

import Foundation


struct StoryDetailsModel: Decodable {
    var status: Int?
    var message: String?
    var data: StoryDetail?
}

struct StoryDetail: Decodable{
    var _id: String?
    var name: String?
    var voice_read: String?
    var status: String?
    var kind_name: String?
    var description: String?
    var avg_rating: Float?
    var total_rating: Int?
    var total_listen: Int?
    var img_src: String?
    var img_src_thumb: String?
    var create_time_mi: Int
    var update_time_mi: Int?
    var list_author: [Author]?
    var list_category: [Author]?
    var is_rating: Int?
    var record_item: [RecordItem]
}

struct RecordItem: Decodable {
    var _id: String?
    var name: String?
    var url_src: String?
    
}
struct Author: Decodable {
    var _id: String?
    var name: String?
}
