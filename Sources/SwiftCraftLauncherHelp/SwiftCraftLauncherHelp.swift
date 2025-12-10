//
//  SwiftCraftLauncherHelp.swift
//  SwiftCraftLauncherHelp
//
//  Created for SwiftCraftLauncher Help Book Package
//

import Foundation

/// SwiftCraftLauncherHelp 包
/// 
/// 这个包提供了 SwiftCraftLauncher 应用的帮助文档资源。
/// 帮助包资源位于 Resources/SwiftCraftLauncher.help 目录中。
public struct SwiftCraftLauncherHelp {
    /// 帮助包的 Bundle Identifier
    public static let bundleIdentifier = "com.su.code.SwiftCraftLauncher.help"
    
    /// 帮助包的文件夹名称
    public static let folderName = "SwiftCraftLauncher.help"
    
    /// 获取帮助包资源路径（如果可用）
    public static var resourcePath: String? {
        guard let resourceURL = Bundle.module.resourceURL else {
            return nil
        }
        let helpPath = resourceURL.appendingPathComponent("SwiftCraftLauncher.help").path
        return FileManager.default.fileExists(atPath: helpPath) ? helpPath : nil
    }
}

