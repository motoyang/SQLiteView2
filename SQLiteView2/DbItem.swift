//
//  DbItem.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Foundation
import SQLite

func toString<T>(value: T?) -> String {
    var s = ""
    if let v = value {
        s = String(v)
    }
    return s
}

func errorToRecordset(error: NSError) -> [[String]] {

    var o = String()
    if let options = error.localizedRecoveryOptions {
        for s in options {
            o += "\(s);"
        }
    }

    let r: [[String]] = [
        ["error name", "error description"],
        ["localizedDescription", error.localizedDescription],
        ["localizedRecoveryOptions", o],
        ["localizedRecoverySuggestion", toString(error.localizedRecoverySuggestion)],
        ["localizedFailureReason", toString(error.localizedFailureReason)]
    ]

    return r
}

extension Statement {
    func output() -> [[String]] {
        
        var result = [[String]]()
        result.append(columnNames)
        
        for row in self {
            var r = [String]()
            for (i, _) in columnNames.enumerate() {
                r.append(toString(row[i]))
            }
            result.append(r)
        }
        
        return result
    }
}

enum DbCatalog {
    case none
    case group
    case table
    case view
    case column
    case primarykey
}

struct SqlDefine {
    let name: String
    let sql: String
}

class DbItem : CustomStringConvertible{
    var name = String()
    var catalog = DbCatalog.none
    var sql = [SqlDefine]()
    var children = [DbItem]()
    
    init(n: String, cat: DbCatalog) {
        name = n
        catalog = cat
    }
    
    var description: String {
        return "{name: \(name), catalog: \(catalog), sql: \(sql), childrenCount: \(children)}"
    }
}

extension Connection {
    func tablesAndViews() -> [DbItem]? {
        var tables = [DbItem]()
        
        // 读出所有的table信息，包括table的index和trigger
        // 将所有的table放入一个group中
        tables.append(DbItem(n: "Tables", cat: .group))
        var sql = "select * from sqlite_master where type != \"view\" order by tbl_name;"
        var stmt = try! prepare(sql)
        for r in stmt {
            if (toString(r[0]) == "table") {
                tables.append(DbItem(n: toString(r[1]), cat: .table))
            }
            tables.last?.sql.append(SqlDefine(name: toString(r[1]), sql: toString(r[4])))
        }
        
        // 读出所有的view信息
        // 将所有的view放入一个group中
        tables.append(DbItem(n: "Views", cat: .group))
        sql = "select * from sqlite_master where type == \"view\" order by tbl_name;"
        stmt = try! prepare(sql)
        for r in stmt {
            tables.append(DbItem(n: toString(r[1]), cat: .view))
            tables.last?.sql.append(SqlDefine(name: toString(r[1]), sql: toString(r[4])))
        }
        
        // 用pragma table_info(table)读出所有table和view的column信息
        for tv in tables where tv.catalog != .group {
            sql = "pragma table_info(\(tv.name))"
            stmt = try! prepare(sql)
            for r in stmt {
                var cat = DbCatalog.column
                if toString(r[5]) == "1" {
                    cat = .primarykey
                }
                tv.children.append(DbItem(n: toString(r[1]), cat: cat))
            }
        }
        
        return tables
    }
}
