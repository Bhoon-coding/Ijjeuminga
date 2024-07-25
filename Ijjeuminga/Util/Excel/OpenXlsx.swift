//
//  OpenXlsx.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 7/23/24.
//

import Foundation
import CoreXLSX

class OpenXlsx {
    public var busList = [BusInfo]()
    public var fileName: String
    public var fileType: String
    public let filePath: String?
    
    init(fileName: String, fileType: String, filePath: String?) {
        self.fileName = fileName
        self.fileType = fileType
        self.filePath = filePath
    }
    
    convenience init() {
        self.init(fileName: "busList", fileType: "xlsx", filePath: Bundle.main.path(forResource: "busList", ofType: "xlsx"))
    }
    
    func openXlsx() -> [BusInfo]? {
        if let filePath = self.filePath {
            guard let file = XLSXFile(filepath: filePath) else {
                fatalError("file is not exist")
            }
            
            do {
                for workBook in try file.parseWorkbooks() {
                    for (name, path) in try file.parseWorksheetPathsAndNames(workbook: workBook) {
                        if let workSheetName = name {
                        }
                        
                        let workSheet = try file.parseWorksheet(at: path)
                        if let sharedStrings = try file.parseSharedStrings() {
                            let busNumList = workSheet.cells(atColumns: [ColumnReference("A")!]).compactMap { $0.stringValue(sharedStrings) }
                            let busRoutedIdList = workSheet.cells(atColumns: [ColumnReference("B")!]).compactMap { $0.stringValue(sharedStrings) }
                            let busTypeList = workSheet.cells(atColumns: [ColumnReference("C")!]).compactMap { $0.stringValue(sharedStrings) }
                            for index in 0..<busNumList.count {
                                self.busList.append(BusInfo(busNumber: busNumList[index], routeId: busRoutedIdList[index], type: Int(busTypeList[index]) ?? 0, lastDate: self.getCurrentDateString()))
                            }
                            return self.busList
                        }
                    }
                }
            }
            catch {}
        }
        return nil
    }
    
    func getCurrentDateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: date)
    }
}
