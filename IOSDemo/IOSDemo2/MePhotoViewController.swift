//
//  MePhotoViewController.swift
//  IOSDemo2
//
//  Created by 陈科宇 on 16/10/19.
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit
import AVKit
import MobileCoreServices

class MePhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoCellDelegate {
	
	var collectionView: UICollectionView!
	var addButton: AddButton!
	var backButton: BackButton!
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addButton = AddButton(frame: CGRect(x: SCREEN_WIDTH * 0.4, y: SCREEN_HEIGHT * 0.9, width: SCREEN_WIDTH * 0.2, height: SCREEN_WIDTH * 0.2), buttonTitle: "", target: self, action: #selector(didTapAddPhotoButton))
		addButton.setBackgroundImage(UIImage(named: "add"), for: UIControlState())
		backButton = BackButton(frame: CGRect(x: 10, y: SCREEN_HEIGHT * 0.025, width: SCREEN_WIDTH * 0.3, height: SCREEN_HEIGHT * 0.1 - SCREEN_HEIGHT * 0.025), buttonTitle: "Back", target: self, action: #selector(didTapBackToMeButton))
		
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: SCREEN_WIDTH * 0.9, height: SCREEN_HEIGHT * 0.25)
		
		collectionView = UICollectionView(frame: CGRect(x: 0, y: SCREEN_HEIGHT * 0.1, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.75) , collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.backgroundColor = UIColor.clear
		
		self.view.addSubview(backButton)
		self.view.addSubview(addButton)
		self.view.addSubview(collectionView)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photoInfo.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
		cell.backgroundColor = UIColor.clear
		cell.deleteButton.isHidden = true
		cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
		cell.deleteButton.addTarget(self, action: #selector(didTapDeletePhotoButton), for: UIControlEvents.touchUpInside)
		
		cell.configPhotoInput(photoInfo[indexPath.row])
		
		cell.delegate = self
		
		return cell
	}
	
	//MARK: PhotoCellDelegate Method
	func photoCellDelegateDidTapPhotoCell(_ photoCell: PhotoCell) {
		if photoCell.photo.type == .localPhoto {
			let fullImageView = UIImageView(image: photoCell.cellImageView.image)
			fullImageView.frame = self.view.frame
			fullImageView.backgroundColor = .black
			fullImageView.contentMode = .scaleAspectFit
			fullImageView.isUserInteractionEnabled = true
			let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFullScreenPhoto(_:)))
			fullImageView.addGestureRecognizer(tap)
			self.view.addSubview(fullImageView)
		} else if photoCell.photo.type == .localVideo {
			let player = AVPlayer(url: photoCell.photo.localUrl!)
			let playerViewController = AVPlayerViewController()
			playerViewController.view.frame = self.view.frame
			playerViewController.player = player
			
			self.present(playerViewController, animated: true, completion: {
				playerViewController.player?.play()
			})
			
			let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFullScreenVideo(_:)))
			playerViewController.view.addGestureRecognizer(tap)
		}
		//TODO: use custom viewController to load fullScreen photo/video view
	}
	
	func photoCellDelegateDidLongPressPhotoCell(_ photoCell: PhotoCell) {
		photoCell.deleteButton.isHidden = !photoCell.deleteButton.isHidden
	}
	
	func didTapFullScreenPhoto(_ gestureRecognizer: UITapGestureRecognizer){
		gestureRecognizer.view!.removeFromSuperview()
	}
	
	func didTapFullScreenVideo(_ viewController: UIViewController){
		dismiss(animated: true, completion: nil)
	}
	
	func didTapDeletePhotoButton(_ sender: UIButton){
		let index = sender.layer.value(forKey: "index") as! Int
		photoInfo.remove(at: index)
		collectionView.reloadData()
	}
	
	func didTapAddPhotoButton(_ sender: UIButton){
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
		imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
		
		self.present(imagePicker, animated: false, completion: nil)
	}
	
	func didTapBackToMeButton(_ sender: UIButton){
		dismiss(animated: false, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
		dismiss(animated: true, completion: nil)
	}
	
	//MARK: select photo/video
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
		let url = info[UIImagePickerControllerReferenceURL] as! URL
		let type = info[UIImagePickerControllerMediaType] as! String
		let id = UUIDfromURL(url)
		
		if type == kUTTypeImage as String {
			photoInfo.append(Photo(url: url, objectType: .localPhoto))
			let image = info[UIImagePickerControllerOriginalImage] as! UIImage
			if let data = UIImagePNGRepresentation(image) {
				writeImageDataToFile(data, localIdentifier: id)
			}
		} else {
			photoInfo.append(Photo(url: url, objectType: .localVideo))
		}
		
		//TODO: upload photo info
		dismiss(animated: true, completion: {() -> Void in
			self.collectionView.reloadData()
		})
	}
	
	func writeImageDataToFile(_ data: Data, localIdentifier: String) {
		let localPath = LOCAL_PATHS.PHOTO.stringByAppendingPathComponent(localIdentifier)
		do {
			try data.write(to: URL(fileURLWithPath: localPath), options: NSData.WritingOptions.noFileProtection)
		} catch let error as NSError {
			NSLog("\(error.localizedDescription)")
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
