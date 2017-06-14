//
//  DataSourceStore.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 9/22/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class DataSourceStore {
	static var onBoardDataSource: OnBoardDataSource = OnBoardDataSource()
    static var nameCardFragmentDataSource: NameCardFragmentDataSource!
	static var matchTopicFragmentDataSource: MatchTopicFragmentDataSource!
	static var meDataSource: MeDataSource!
	static var socketIODataSource: SocketIODataSource!
	
	static func initDataSourcesAfterLogin(_ completionHandler: ((Void) -> Void)) {
		DataSourceStore.meDataSource = MeDataSource()
		DataSourceStore.nameCardFragmentDataSource = NameCardFragmentDataSource()
		DataSourceStore.matchTopicFragmentDataSource = MatchTopicFragmentDataSource()
		DataSourceStore.socketIODataSource = SocketIODataSource()
		var afterLoginSteps: [AsyncInitStep] = []
		afterLoginSteps.append(DataSourceStore.meDataSource)
		afterLoginSteps.append(DataSourceStore.matchTopicFragmentDataSource)
		afterLoginSteps.append(DataSourceStore.nameCardFragmentDataSource)
		afterLoginSteps.append(DataSourceStore.socketIODataSource)
		var completeCount = 0
		for step in afterLoginSteps {
			step.asyncInit() { _ in
				completeCount += 1
				if (completeCount == afterLoginSteps.count) {
					completionHandler()
					return
				}
			}
		}
	}
}
