//
//  PhotoCell.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 10/30/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit
import AVKit

class PhotoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    var photo: Photo!
    
    var cellImageView:UIImageView!
    var deleteButton: UIButton!
    var videoPlayerLayer:AVPlayerLayer?
    
    var delegate: PhotoCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photo = nil
        videoPlayerLayer = nil
        
        cellImageView = UIImageView(frame: CGRect(x: frame.size.width * 0.1, y: 0, width: frame.size.width * 0.9, height: frame.size.height))
        cellImageView.image = UIImage(named:"default")
        cellImageView.contentMode = UIViewContentMode.scaleAspectFit
        cellImageView.backgroundColor = UIColor.clear
        deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.1, height: frame.size.width * 0.1))
        deleteButton.setBackgroundImage(UIImage(named: "delete"), for: UIControlState())
        deleteButton.isHidden = true
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(cellImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoCell.didTapPhotoCell(_:)))
        addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(PhotoCell.didLongPressPhotoCell(_:)))
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure Photo
    func configPhotoInput(_ photoInput: Photo) {
        photo = photoInput
        
        cellImageView.image = loadImageFromCache(photoInput)
        
        if photoInput.type == .localVideo {
            configureVideoPlayer(photoInput)
        }
    }
    
    func loadImageFromCache(_ photoInput: Photo) -> UIImage {
        if photoInput.type == .localPhoto {
            let path = LOCAL_PATHS.PHOTO.stringByAppendingPathComponent(photoInput.photoUUID)
            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                return UIImage(data: imageData)!
            }
        }
        if photoInput.type == .localVideo {
            let urlAsset = AVURLAsset(url: photoInput.localUrl!)
            return self.firstFrameOfVideo(urlAsset)
        }
        return UIImage(named:"default")!
    }
    
    func configureVideoPlayer(_ photoInput: Photo) {
        videoPlayerLayer = AVPlayerLayer(player: AVPlayer(url: photoInput.localUrl!))
        videoPlayerLayer!.frame = cellImageView.bounds
        cellImageView.layer.addSublayer(videoPlayerLayer!)
        videoPlayerLayer?.player!.play()
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayerLayer!.player!.currentItem)
    }
    
    func videoPlayerDidFinishPlaying(_ note: Notification) {
        videoPlayerLayer?.removeFromSuperlayer()
    }
    
    func firstFrameOfVideo(_ asset: AVURLAsset) -> UIImage {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        if let cgImage = try? imageGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
            return UIImage(cgImage: cgImage)
        }
        return UIImage(named: "default")!
    }
    
    //MARK: Gesture Method
    func didTapPhotoCell(_ sender: UITapGestureRecognizer) {
        delegate?.photoCellDelegateDidTapPhotoCell(self)
    }
    
    func didLongPressPhotoCell(_ sender: UITapGestureRecognizer) {
        delegate?.photoCellDelegateDidLongPressPhotoCell(self)
    }
}

protocol PhotoCellDelegate {
    func photoCellDelegateDidTapPhotoCell(_ photoCell: PhotoCell)
    func photoCellDelegateDidLongPressPhotoCell(_ photoCell: PhotoCell)
}
