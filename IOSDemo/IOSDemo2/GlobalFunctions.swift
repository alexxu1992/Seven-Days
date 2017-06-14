//
//  GlobalFunctions.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 7/9/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit
import SSZipArchive

// MARK: Util - File
func zipDirAtPath(_ zipPath: String, destinationPath: String) -> Bool {
	return SSZipArchive.createZipFile(atPath: destinationPath, withContentsOfDirectory: zipPath)
}

func unZipFileAtPath(_ unZipPath: String, destinationPath: String) -> Bool {
	return SSZipArchive.unzipFile(atPath: unZipPath, toDestination: destinationPath)
}

// Get uuid from url
func UUIDfromURL(_ url: URL) -> String {
    return "\(url)".substring(with: ("\(url)".range(of: "=")!.upperBound ..< "\(url)".range(of: "&")!.lowerBound))
}

// Get local file url like file:///baseURL/pathDir/pathFile.extension
func getLocalFileURLWithPath(_ path: String, baseURL: String?) -> URL {
	let url = (baseURL == nil) ? LOCAL_DOC_PATH : baseURL!
	let newPath: String = url.stringByAppendingPathComponent(path)
	return URL(fileURLWithPath: newPath)
}

// Get local dir url like /baseURL/path/
func getLocalDirURLWithPath(_ path: String, baseURL: String?) -> URL {
	let url = (baseURL == nil) ? LOCAL_DOC_PATH : baseURL!
	let newPath: String = url.stringByAppendingPathComponent(path)
	return URL(string: newPath)!
}

// Create file or directory -> Make sure you call this before saving any files to that directory
func createFileIfAbsent(_ path: String, isDir: Bool, contents: Data?, attributes: [String : AnyObject]?) -> Bool {
	let fm = FileManager.default
	var isDirObj: ObjCBool = ObjCBool(isDir)
	if !fm.fileExists(atPath: path, isDirectory: &isDirObj) {
		do {
			if (isDir) {
				try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attributes)
			} else {
				fm.createFile(atPath: path, contents: contents, attributes: attributes)
			}
			return true
		} catch {
			print("Error on creating path " + path)
			return false
		}
	}
	return true
}

// Delete file or directory
func deleteFileAtURL(_ url: URL) -> Bool {
	let fileManager = FileManager.default
	do {
		try fileManager.removeItem(at: url)
		return true
	} catch {
		print("Exception: Can not delete file at: " + url.absoluteString)
	}
	return false
}

func deleteDirectoryAtURL(_ url: URL) -> Bool {
	let fileManager = FileManager.default
	if let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil, options: [], errorHandler: nil) {
		while let file = enumerator.nextObject() {
			if let fileURL = file as? URL {
				do {
					try FileManager.default.removeItem(at: fileURL)
					return true
				}
				catch {
					print("Exception: Can not delete item within folder: " + url.absoluteString)
				}
			}
		}
	}
	return false
}

// MARK: Util - JSON
//Converted the JSON Object to JSON String
func JSONStringify(_ value: AnyObject, prettyPrinted: Bool = false) -> String { // used for converting to JSON
	let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
	
	if JSONSerialization.isValidJSONObject(value) {
		do {
			let data = try JSONSerialization.data(withJSONObject: value, options: options)
			
			if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
				return string as String
			}
		} catch {
			print("error")
		}
	}
	
	return ""
}

// MARK: Util - TIME
//Get time_t in millisecond
func getCurrentTimeStamp() -> String {
	let date = Int(Date().timeIntervalSince1970 * 1000)
	let dateString = String(date)
	return dateString
}
//Get current date data and distract them
func getCurrentDate() -> String {
	let date = Date()
	let Calendar = Foundation.Calendar.current
	let components = (Calendar as NSCalendar).components([.day, .month, .year], from: date)
	let dateString = String(describing: components.month) + "," + String(describing: components.day) + "," + String(describing: components.year)
	return dateString
}


class TimeDic {
	var day = 0
	var hour = 0
	var minute = 0
	var second = 0
}

//Convert milliseconds to hours/minutes/seconds
func convertMilliseconds(_ milliseconds: Int, day: Bool, hour: Bool, minute: Bool, second: Bool) -> TimeDic {
	var remainder = milliseconds / 1000
	let result = TimeDic()
	var quotient: Int
	
	if day {
		quotient = remainder / 86400
		remainder %= 86400
		result.day = quotient
	}
	
	if hour {
		quotient = remainder / 3600
		remainder %= 3600
		result.hour = quotient
	}
	
	if minute {
		quotient = remainder / 60
		remainder %= 60
		result.minute = quotient
	}
	
	if second {
		quotient = remainder
		result.second = quotient
	}
	
	return result
}

func convertTimeDic(_ timeDic: TimeDic, typeNumber: Int) -> String {
	if (typeNumber > 0 && typeNumber <= 4) {
		var count = typeNumber
		var timeLeftString = ""
		if (timeDic.day > 0) {
			count -= 1
			timeLeftString += (String(timeDic.day) + "天")
		}
		if (timeDic.hour > 0) {
			count -= 1
			timeLeftString += (String(timeDic.day) + "小时")
		}
		if (timeDic.minute > 0 && count != 0) {
			count -= 1
			timeLeftString += (String(timeDic.day) + "分")
		}
		if (timeDic.hour > 0 && count != 0) {
			count -= 1
			timeLeftString += (String(timeDic.day) + "秒")
		}
		return timeLeftString
	}
	else { return "" }
	
}
