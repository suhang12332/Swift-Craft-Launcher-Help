# SwiftCraftLauncherHelp

SwiftCraftLauncher 的帮助文档包，作为 Swift Package Manager (SPM) 资源包提供。

## 说明

这个包包含了 SwiftCraftLauncher 应用的 macOS Help Book 资源文件，包括：

- 多语言帮助文档（英文、简体中文、繁体中文）
- 帮助文档的 HTML 文件
- CSS 样式文件
- Info.plist 配置文件

## 使用方法

### 1. 在 Xcode 项目中添加依赖

1. 打开你的 Xcode 项目
2. 选择项目文件，进入 "Package Dependencies" 标签
3. 点击 "+" 按钮添加包依赖
4. 输入 GitHub 仓库 URL：`https://github.com/你的用户名/SwiftCraftLauncherHelp.git`
5. 选择版本或分支
6. 点击 "Add Package"

### 2. 在项目中配置 Help Book

在你的应用的 `Info.plist` 中添加以下配置：

```xml
<key>CFBundleHelpBookFolder</key>
<string>SwiftCraftLauncher.help</string>
<key>CFBundleHelpBookName</key>
<string>com.su.code.SwiftCraftLauncher.help</string>
```

### 3. 在构建阶段复制帮助包

在你的 Xcode 项目的 Build Phases 中添加一个 "Copy Files" 阶段：

1. 选择你的 Target
2. 进入 "Build Phases"
3. 点击 "+" 添加 "New Copy Files Phase"
4. 设置 Destination 为 "Resources"
5. 添加 `$(SRCROOT)/.build/checkouts/SwiftCraftLauncherHelp-*/Sources/SwiftCraftLauncherHelp/Resources/SwiftCraftLauncher.help`

或者，你可以创建一个构建脚本来复制帮助包：

```bash
# 在 Build Phases 中添加 Run Script
HELP_PACKAGE_PATH=$(find "$(BUILD_DIR)/../../SourcePackages/checkouts" -name "SwiftCraftLauncher.help" -type d | head -1)
if [ -n "$HELP_PACKAGE_PATH" ]; then
    cp -R "$HELP_PACKAGE_PATH" "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/"
fi
```

### 4. 使用 Swift Package Manager 命令行

如果你使用命令行工具，可以在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/你的用户名/SwiftCraftLauncherHelp.git", from: "1.0.0")
]
```

## 目录结构

```
SwiftCraftLauncherHelp/
├── Package.swift
├── README.md
├── SETUP_GUIDE.md
└── Sources/
    └── SwiftCraftLauncherHelp/
        ├── SwiftCraftLauncherHelp.swift
        └── Resources/
            └── SwiftCraftLauncher.help/
                └── Contents/
                    ├── Info.plist
                    └── Resources/
                        ├── css/
                        │   └── app.css
                        ├── en.lproj/
                        ├── zh-Hans.lproj/
                        └── zh-Hant.lproj/
```

## 版本

当前版本：1.0.0

## 许可证

请参考主项目的许可证文件。

## 贡献

欢迎提交 Issue 和 Pull Request！

