//
//  ServerAPIMapping.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 7/25/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

// MARK: Common

struct CommonInfo {
	static let data = "data"
	static let errorCode = "errorCode"
	static let success = "success"
}

// MARK: Login

// get token from login
struct LoginInfo {
	static let token = "token"
}

// MARK: Engage Direction

// Engages get mutual list
struct EngageDirectionInfo {
	static let engagesList = "engagesList"
}

struct EngageListInfo {
	static let millisecondsLeft = "millisecondsLeft"
	static let userCard = "user"
	static let lastMessage = "lastMsg"
	static let status = "status"
}

// MARK: Lasting Direction

// Lastings get mutual list
struct LastingDirectionInfo {
	static let LastingsList = "lastingsList"
}

struct LastingListInfo {
	static let userCard = "user"
	static let lastMessage = "lastMsg"
}

// MARK: UserCard Direction

struct UserCardInfo {
	static let id = "_id"
	static let username = "username"
	static let email = "email"
	static let gender = "gender"
	static let avatarURL = "avatarURL"
	static let tags = "tags"
	static let updatedTime = "updatedAt"
    static let occupations = "occupations"
    static let educations = "educations"
	static let namecard = "namecard"
}

// MARK: NameCard
struct NameCardInfo {
	static let articles = "articles"
	static let multimedias = "multimedias"
}

// MARK: Article
struct ArticleInfo {
	static let id = "_id"
    static let content = "content"
    static let title = "title";
}

struct MultimediaInfo {
	static let pictureType = "picture"
	static let videoType = "video"
	static let audioType = "audio"
	static let id = "_id"
    static let mediaType = "mediaType"
    static let tags = "tags";
	static let title = "title"
	static let url = "url"
}

// MARK: Match Direction

struct MatchTopicInfo {
	static let timestamp = "timestamp"
	static let topic_id = "_id"
	static let title = "title"
	static let subtitle = "subtitle"
	static let pictureURL = "pictureURL"
	static let story = "story"
	static let content = "content"
	static let answers = "answers"
	static let answers_id = "id"
	static let version = "__v"
}

struct MatchGoToMeetInfo {
	static let topic_id = "topic_id"
	static let answer_id = "answer_id"
	static let user = "user"
}
