# 设置指南：将 SwiftCraftLauncherHelp 上传到 GitHub 并使用 SPM

## 步骤 1: 创建新的 GitHub 仓库

1. 登录 GitHub
2. 点击右上角的 "+" 按钮，选择 "New repository"
3. 填写仓库信息：
   - Repository name: `SwiftCraftLauncherHelp` (或你喜欢的名称)
   - Description: `SwiftCraftLauncher Help Book Package`
   - 选择 Public 或 Private
   - **不要**初始化 README、.gitignore 或 license（我们已经创建了这些文件）
4. 点击 "Create repository"

## 步骤 2: 初始化 Git 并上传文件

在终端中执行以下命令：

```bash
cd /Users/su/Development/XCodeProjects/SwiftCraftLauncher/SwiftCraftLauncherHelp

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: SwiftCraftLauncher Help Book Package"

# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/SwiftCraftLauncherHelp.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

## 步骤 3: 创建版本标签（可选但推荐）

为了使用语义化版本控制，创建第一个版本标签：

```bash
git tag -a v1.0.0 -m "Version 1.0.0"
git push origin v1.0.0
```

## 步骤 4: 在主项目中使用 SPM 包

### 方法 A: 通过 Xcode GUI

1. 打开 `SwiftCraftLauncher.xcodeproj`
2. 选择项目文件（最顶部的蓝色图标）
3. 选择你的 Target（SwiftCraftLauncher）
4. 进入 "Package Dependencies" 标签
5. 点击 "+" 按钮
6. 在搜索框中输入你的 GitHub 仓库 URL：
   ```
   https://github.com/YOUR_USERNAME/SwiftCraftLauncherHelp.git
   ```
7. 选择版本规则（例如：Up to Next Major Version: 1.0.0）
8. 点击 "Add Package"

### 方法 B: 通过 project.pbxproj（如果使用文件同步）

如果你的项目使用 `PBXFileSystemSynchronizedRootGroup`，你可能需要在构建脚本中处理资源复制。

## 步骤 5: 配置构建脚本复制帮助包

由于 SPM 资源包在构建时不会自动复制到应用的 Resources 目录，你需要添加一个构建脚本来复制帮助包：

1. 在 Xcode 中选择你的 Target
2. 进入 "Build Phases"
3. 点击 "+" 添加 "New Run Script Phase"
4. 将脚本放在 "Copy Bundle Resources" 之前
5. 添加以下脚本：

```bash
# 查找 SPM 包中的帮助包
HELP_PACKAGE_NAME="SwiftCraftLauncher.help"
SPM_CHECKOUTS_DIR="${BUILD_DIR}/../../SourcePackages/checkouts"
HELP_PACKAGE_PATH=$(find "$SPM_CHECKOUTS_DIR" -name "$HELP_PACKAGE_NAME" -type d | head -1)

if [ -z "$HELP_PACKAGE_PATH" ]; then
    # 如果找不到，尝试在 DerivedData 中查找
    DERIVED_DATA_DIR="${BUILD_DIR}/../../"
    HELP_PACKAGE_PATH=$(find "$DERIVED_DATA_DIR" -name "$HELP_PACKAGE_NAME" -type d -path "*/SourcePackages/checkouts/*" | head -1)
fi

if [ -n "$HELP_PACKAGE_PATH" ]; then
    echo "找到帮助包: $HELP_PACKAGE_PATH"
    DEST_DIR="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
    echo "复制到: $DEST_DIR"
    cp -R "$HELP_PACKAGE_PATH" "$DEST_DIR/"
    echo "✅ 帮助包已复制"
else
    echo "⚠️  警告: 未找到帮助包，请确保已添加 SPM 依赖"
fi
```

## 步骤 6: 验证 Info.plist 配置

确保你的应用 `Info.plist` 包含以下配置（通常在构建脚本中自动添加，如 `build-dmg.yml` 中所示）：

```xml
<key>CFBundleHelpBookFolder</key>
<string>SwiftCraftLauncher.help</string>
<key>CFBundleHelpBookName</key>
<string>com.su.code.SwiftCraftLauncher.help</string>
```

## 步骤 7: 测试

1. 清理构建文件夹（Product > Clean Build Folder，或 Cmd+Shift+K）
2. 构建项目（Product > Build，或 Cmd+B）
3. 运行应用
4. 在应用中按 Cmd+? 或通过菜单栏 Help > Swift Craft Launcher Help 打开帮助文档

## 更新帮助包

当你更新帮助包内容后：

```bash
cd SwiftCraftLauncherHelp

# 修改文件后
git add .
git commit -m "更新帮助文档内容"
git push

# 创建新版本标签
git tag -a v1.0.1 -m "Version 1.0.1"
git push origin v1.0.1
```

在主项目中，Xcode 会自动检测到新版本，你可以通过 Package Dependencies 更新到新版本。

## 故障排除

### 问题：找不到帮助包

- 确保 SPM 包已正确添加到项目
- 检查构建脚本中的路径是否正确
- 清理构建文件夹后重新构建

### 问题：帮助文档无法打开

- 检查 Info.plist 中的 CFBundleHelpBookFolder 和 CFBundleHelpBookName 是否正确
- 确保帮助包已正确复制到应用的 Resources 目录
- 检查帮助包的 Info.plist 中的 Bundle Identifier 是否匹配

### 问题：SPM 包无法解析

- 检查 GitHub 仓库 URL 是否正确
- 确保仓库是公开的，或者已配置访问权限
- 检查网络连接

## 注意事项

- SPM 资源包在构建时不会自动复制到应用包中，必须使用构建脚本手动复制
- 帮助包的 Bundle Identifier 必须与 Info.plist 中配置的 CFBundleHelpBookName 匹配
- 如果使用 CI/CD，确保构建脚本在正确的阶段运行

