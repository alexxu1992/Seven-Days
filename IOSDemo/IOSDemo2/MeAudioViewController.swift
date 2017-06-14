//
//  MeAudioViewController.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MeAudioViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,AVAudioPlayerDelegate, AVAudioRecorderDelegate, MPMediaPickerControllerDelegate, MeDataSourceDelegate {
	var collectionView: UICollectionView!
	var backToMeButton: BackButton!
	var playButton: PlayButton!
	var recordButton: PlayButton!
	var chooseFromLibraryButton: GeneralTextButton!
	var uploadButton: UploadButton!
	
	var addUrlButton: AddNewButton!
	var addUrlView: AddUrlView!
	
	var selectedAudioItem: AudioItem?
	var audioRecorder: AVAudioRecorder!
	var audioPlayer: AVAudioPlayer!
	var recordFileName: String = ""
	var audioItems: [AudioItem] = []
	
	let mediaPicker = MPMediaPickerController(mediaTypes: .music)
	let cellIdentifier = "AudioFragment"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let buttonWidth = CGFloat(80)
		let buttonHeight = CGFloat(40)
		// Buttons
		backToMeButton = BackButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "back", target: self, action: #selector(didTapBackToMeButton))
		playButton = PlayButton(frame: CGRect(x: buttonWidth * 1.1, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), currentState: .play, target: self, action: #selector(didTapPlayButton))
		recordButton = PlayButton(frame: CGRect(x: buttonWidth * 2.2, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), currentState: .record, target: self, action: #selector(didTapRecordButton))
		chooseFromLibraryButton = GeneralTextButton(frame: CGRect(x: buttonWidth * 3.3, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "Choose" , target: self, action: #selector(didTapChooseMusicFromLibraryButton))
		uploadButton = UploadButton(frame: CGRect(x: buttonWidth * 1.1, y: SCREEN_HEIGHT - 2.1 * buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "Upload" , target: self, action: #selector(didTapUploadButton));
		
		addUrlButton = AddNewButton(frame: CGRect(x: buttonWidth * 2.2, y: SCREEN_HEIGHT - 2.1 * buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "AddUrl", target: self, action: #selector(didTapAddUrlButton))
		addUrlView = AddUrlView(frame: self.view.frame, targetForBack: self, targetForConfirm: self, actionForBack: #selector(didTapBackButtonInAddUrlView), actionForConfirm: #selector(didTapConfirmButtonInAddUrlView))
		
		// Main Table
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.2)
		collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - buttonHeight) , collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(AudioFragment.self, forCellWithReuseIdentifier: cellIdentifier)
		collectionView.backgroundColor = UIColor.clear
		// Add views
		self.view.addSubview(collectionView)
		self.view.addSubview(backToMeButton)
		self.view.addSubview(playButton)
		self.view.addSubview(recordButton)
		self.view.addSubview(chooseFromLibraryButton)
		self.view.addSubview(uploadButton)
		self.view.addSubview(addUrlButton)
		// Init data
		setupMediaPicker()
		audioItems += loadAudioItems()
		createFileIfAbsent(LOCAL_PATHS.AUDIO, isDir: true, contents: nil, attributes: nil)
		createFileIfAbsent(LOCAL_PATHS.CACHE, isDir: true, contents: nil, attributes: nil)
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return audioItems.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AudioFragment
		// Render data for this cell
		let audioItem = audioItems[indexPath.row]
		if let item = selectedAudioItem, audioItem == item {
			cell.backgroundColor = UIColor.blue
		} else {
			cell.backgroundColor = UIColor.white
		}
		cell.audioTitleLabel.text = audioItem.audioTitle
		cell.deleteButton.addTarget(self, action: #selector(deleteAudioItem), for: .touchUpInside)
		cell.index = indexPath.row
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedAudioItem = audioItems[indexPath.row]
		let selectedCell = collectionView.cellForItem(at: indexPath) as! AudioFragment
		if let ap = audioPlayer, ap.isPlaying {
			self.stopAudio()
		}
		self.playAudio()
		for cell in collectionView.visibleCells {
			cell.backgroundColor = UIColor.white
		}
		selectedCell.backgroundColor = UIColor.blue
	}
	
	// MARK: - NSCoding
	func saveAudioItems() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(audioItems, toFile: AudioItem.CACHE_URL.path)
		if !isSuccessfulSave {
			print("Failed to save audio items")
		}
	}
	
	func loadAudioItems() -> [AudioItem] {
		var items: [AudioItem] = []
		var ids = Set<String>()
		if let savedItems = NSKeyedUnarchiver.unarchiveObject(withFile: AudioItem.CACHE_URL.path) as?[AudioItem] {
			for item in savedItems {
				if item.id != "" {
					ids.insert(item.id)
				}
			}
			items = savedItems
		}
		let uploadedItems = DataSourceStore.meDataSource.nameCards[NameCardInfo.multimedias] as! [[String : AnyObject]]
		for audio in uploadedItems {
			if audio[MultimediaInfo.mediaType] as! String == MultimediaInfo.audioType
			&& !ids.contains(audio[MultimediaInfo.id] as! String) {
				let item = AudioItem(audioAssetString: audio[MultimediaInfo.url] as! String, audioTitle: audio[MultimediaInfo.title] as! String, isLocalFile: false, id: audio[MultimediaInfo.id] as! String)
				items.append(item!)
			}
		}
		return items
	}

    // MARK: - Button Callbacks
	func didTapAddUrlButton(_ sender: UIButton){
		self.addUrlView.addUrlTextField.text = ""
		self.view.addSubview(addUrlView)
	}
	func didTapBackButtonInAddUrlView(_ sender: UIButton){
		sender.superview!.removeFromSuperview()
	}
	func didTapConfirmButtonInAddUrlView(_ sender: UIButton){
		if self.addUrlView.addUrlTextField.text != nil{
			let newAudioCard = AudioItem(audioAssetString: self.addUrlView.addUrlTextField.text!, audioTitle: "webMusic", isLocalFile: false)
			audioItems.append(newAudioCard!)
			saveAudioItems()
			self.collectionView.reloadData()
		}
		sender.superview!.removeFromSuperview()
	}
	
	
	func didTapUploadButton(_ sender: UIButton) {
		if zipDirAtPath(LOCAL_PATHS.AUDIO, destinationPath: getLocalDirURLWithPath(CACHE_FILE_NAME.AUDIO_ZIP, baseURL: LOCAL_PATHS.CACHE).absoluteString) {
			print(LOCAL_PATHS.AUDIO.stringByAppendingPathComponent(CACHE_FILE_NAME.AUDIO_ZIP))
			print(LOCAL_DOC_PATH)
			print("Zip file success")
		} else {
			print(LOCAL_PATHS.AUDIO.stringByAppendingPathComponent(CACHE_FILE_NAME.AUDIO_ZIP))
			print(LOCAL_DOC_PATH)
			print("Zip file fail")
		}
	}
	
	func didTapBackToMeButton(_ sender: UIButton) {
		dismiss(animated: false, completion: nil)
	}
	
	func didTapChooseMusicFromLibraryButton(_ sender: AnyObject) {
		present(mediaPicker, animated: false, completion: { })
	}
	
	func didTapRecordButton(_ sender: AnyObject) {
		let target = sender as! PlayButton
		switch target.currentState! {
		case PlayButton.PlayState.record:
			setupRecorder()
			audioRecorder.record()
			target.changeState(.stop)
			playButton.isEnabled = false
		case PlayButton.PlayState.stop:
			audioRecorder.stop()
			let session = AVAudioSession.sharedInstance()
			do {
				try session.setCategory(AVAudioSessionCategoryPlayback)
				try session.setActive(false, with: .notifyOthersOnDeactivation)
			} catch {
				print("Error at stop recording")
			}
			recordButton.changeState(.record)
			playButton.isEnabled = true
			if let item = AudioItem(audioAssetString: recordFileName, audioTitle: recordFileName, isLocalFile: true) {
				addNewAudioItem(item)
			}
		default:
			return
		}
	}
	
	func didTapPlayButton(_ sender: AnyObject) {
		let target = sender as! PlayButton
		switch target.currentState! {
		case PlayButton.PlayState.play:
			self.playAudio()
		case PlayButton.PlayState.pause:
			self.pauseAudio()
		default:
			return
		}
		
	}
	
	// MARK: - Helper Functions
	func playAudio() {
		if let item = selectedAudioItem {
			if let url = selectedAudioItem?.audioAssetURL() {
				if url.absoluteString.hasPrefix("http") {
					UIApplication.shared.openURL(url)
				} else {
					if !preparePlayer(item) && !audioPlayer.prepareToPlay(){
						return
					}
					recordButton.isEnabled = false
					playButton.changeState(.pause)
					audioPlayer.play()
				}
			}
		}
	}
	
	func pauseAudio() {
		playButton.changeState(.play)
		recordButton.isEnabled = true
		audioPlayer.pause()
	}
	
	func stopAudio() {
		self.pauseAudio()
		audioPlayer.stop()
	}
	
	func preparePlayer(_ item : AudioItem) -> Bool {
		// NSBundle.mainBundle().pathForResource("0", ofType: "mp3")
		do {
			if let url = item.audioAssetURL() {
				audioPlayer = try AVAudioPlayer(contentsOf: url)
				audioPlayer.delegate = self
				return true
			} else {
				return false
			}
		} catch {
			print("Error at start playing audio")
			return false
		}
	}
	
	func addNewAudioItem (_ item: AudioItem) {
		audioItems.append(item)
		self.reloadData()
		saveAudioItems()
	}
	
	func deleteAudioItem (_ sender: AnyObject) {
		let alertController = UIAlertController(title: "Sure to delete?", message: "The file will be deleted yo!", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "YES!", style: .default, handler: {(action: UIAlertAction) in
			let button = sender as! DeleteButton
			let cell = button.superview?.superview as! AudioFragment
			cell.backgroundColor = UIColor.white
			if let item = self.selectedAudioItem, item == self.audioItems[cell.index] {
				if self.audioPlayer.isPlaying {
					self.stopAudio()
				}
			}
			self.audioItems[cell.index].recycle()
			self.audioItems.remove(at: cell.index)
			self.saveAudioItems()
			self.reloadData()
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) in
			alertController.dismiss(animated: false, completion: nil)
			
		}))
		present(alertController, animated:true, completion: nil)
	}
	
	// MARK: Setup Functions
	func setupRecorder () {
		let session = AVAudioSession.sharedInstance()
		do {
			try session.setCategory(AVAudioSessionCategoryRecord)
			try session.setActive(true)
		} catch {
			print("Error at start recording")
		}
		let recordSetting: [String: AnyObject] = [
			AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
			AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as NSNumber,
			AVEncoderBitRateKey: 320000 as NSNumber,
			AVNumberOfChannelsKey: 2 as AnyObject, AVSampleRateKey: 44100.0 as NSNumber]
		do {
			let now: Date = Date()
			let dateFormatter: DateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyyMMddHHmmss"
			recordFileName = dateFormatter.string(from: now) + ".m4a"
			audioRecorder = try AVAudioRecorder(url: getLocalFileURLWithPath(recordFileName, baseURL: LOCAL_PATHS.AUDIO), settings: recordSetting)
			audioRecorder.delegate = self
			audioRecorder.prepareToRecord()
		} catch {
			// TODO : Give proper error handler
			print("Error at recorder setting")
		}
		
	}
	
	func setupMediaPicker ()
	{
		let session = AVAudioSession.sharedInstance()
		do {
			try session.setCategory(AVAudioSessionCategoryPlayback)
			try session.setActive(false, with: .notifyOthersOnDeactivation)
		} catch {
			print("Error at switching audio session")
		}
		mediaPicker.delegate = self
		mediaPicker.showsCloudItems = false
		mediaPicker.allowsPickingMultipleItems = false
	}
	
	// MARK: MPMediaPickerControllerDelegate
	func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
		mediaPicker.dismiss(animated: false, completion: { })
		
		if (mediaItemCollection.count < 1) {
			return
		}
		if let mediaItemPicked: MPMediaItem = mediaItemCollection.items[0] {
			if let item = AudioItem(item: mediaItemPicked) {
				addNewAudioItem(item)
			}
		}
	}
	
	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
		mediaPicker.dismiss(animated: false, completion: { })
	}
	
	// MARK: - AVAudioPlayerDelegate, AVAudioRecorderDelegate
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		playButton.isEnabled = true
	}
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		recordButton.isEnabled = true
		playButton.changeState(.play)
	}
	
	// MARK: - Image Picker Controller Delegate Methods
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: false, completion: nil)
	}
	
	// MARK: - UIViewController
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: Data Source Delegate Methods
	func reloadData() {
		self.collectionView.reloadData()
	}
}
