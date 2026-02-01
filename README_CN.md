# ScrollSnap

[English](README.md) | [中文](#)

ScrollSnap 是一款开源的 macOS 应用程序，专为捕获滚动截图而设计，具有可自定义的选择区域和菜单界面。它允许用户定义捕获区域、拍摄拼接的滚动截图，并将其保存到各种位置（如桌面、剪贴板、预览）。使用 Swift 构建并利用 AppKit 和 ScreenCaptureKit，ScrollSnap 提供了一个简洁的基于叠加层的 UI，以实现精确控制。

<div style="text-align: center;">
  <img src="assets/preview.gif" alt="ScrollSnap 演示" style="width: 700px; height: 400px;">
</div>

## 下载

- 📦 [从 GitHub Releases 下载 ZIP](https://github.com/brkgng/ScrollSnap/releases/latest) - **免费**
- 🍎 [在 App Store 下载](https://apps.apple.com/app/scrollsnap/id6744903723) – 付费版本，适合喜欢 App Store 便利性的用户

## 功能特性

- **菜单栏集成**：便捷地运行在 macOS 菜单栏中，快速访问所有功能。
- **全局热键**：通过可自定义的键盘快捷键即时触发截图捕获。
- **可自定义选择区域**：调整大小和拖动选择矩形以定义捕获区域。
- **滚动捕获**：自动将多个截图拼接成单个图像，用于捕获长内容。
- **交互式菜单**：包含捕获、保存、重置位置或取消等选项，具有可拖动的界面。
- **缩略图预览**：显示可拖动的捕获图像缩略图，支持滑动保存或右键单击选项。
- **保存目标**：支持保存到桌面、文稿、下载、剪贴板或在预览中打开。
- **偏好设置**：通过设置窗口重置选择和菜单位置（Command + ,）。

## 系统要求

- macOS 12.0 或更高版本（需要 ScreenCaptureKit 框架）。
- Xcode 14.0 或更高版本用于开发。

## 安装

1. **克隆仓库**：
   ```bash
   git clone https://github.com/brkgng/ScrollSnap.git
   cd ScrollSnap
   ```
2. **在 Xcode 中打开**：

- 打开 `ScrollSnap.xcodeproj`

3. **构建并运行**：

- 按 `Cmd + R` 进行构建和运行。
- **注意**：确保应用在系统设置 > 安全性与隐私中启用了屏幕录制权限。

## 使用方法

1. **启动应用**：

- ScrollSnap 在菜单栏中运行。点击菜单栏图标或使用全局热键开始捕获。

2. **快速捕获**：

- 使用键盘快捷键（可在偏好设置中配置）立即激活捕获叠加层。

3. **调整选择区域**：

- 拖动矩形移动它，或使用调整大小手柄调整其大小。

4. **捕获截图**：

- 对于滚动捕获，点击"捕获"开始，然后点击"保存"停止并拼接图像。

5. **与缩略图交互**：

- 拖动缩略图将图像复制到其他位置，向右滑动保存，或右键单击以获取选项（在访达中显示、删除、关闭）。

6. **保存选项**：

- 使用"选项"菜单设置保存目标（桌面、剪贴板等）。

7. **偏好设置**：

- 按 `Cmd + ,` 或通过菜单栏图标访问以打开设置并自定义热键或重置位置。

8. **退出**：

- 按 `Esc` 或从菜单栏图标中选择"退出 ScrollSnap"。

## 项目结构

```
ScrollSnap
│── App
│   │── ScrollSnapApp.swift         # 应用入口点（SwiftUI）
│   │── AppDelegate.swift          # 菜单和设置配置
│── Controllers
│   │── SettingsWindowController.swift  # 偏好设置窗口
│── Utilities
│   │── Constants.swift            # 应用范围常量
│   │── ScreenshotUtilities.swift  # 截图捕获和保存逻辑
│── Views
│   │── OverlayView.swift          # 主叠加层协调器
│   │── ContentView.swift          # SwiftUI 入口点
│   │── SelectionRectangleView.swift  # 选择区域 UI
│   │── MenuBarView.swift          # 菜单栏 UI
│   │── ThumbnailView.swift        # 缩略图预览 UI
│── Managers
│   │── OverlayManager.swift       # 叠加层和状态管理
│   │── StitchingManager.swift     # 滚动捕获的图像拼接
```

## 工作原理

- **叠加层系统**：`OverlayManager` 在所有屏幕上创建叠加层，由 `OverlayView` 管理，它将绘制和交互委托给 `SelectionRectangleView` 和 `MenuBarView`。
- **截图捕获**：`ScreenshotUtilities` 使用 ScreenCaptureKit 捕获定义的矩形区域，排除应用的 UI。
- **滚动捕获**：`StitchingManager` 使用重叠检测将截图组合成单个图像。
- **缩略图**：`ThumbnailView` 提供具有拖放和滑动手势的交互式预览。

## 贡献

ScrollSnap 是一个开源项目，我们欢迎贡献！如果您想改进它：

- **报告问题**：在 [GitHub 仓库](https://github.com/brkgng/ScrollSnap/issues)上提交问题，报告错误或功能请求。
- **提交 Pull Request**：
  1. Fork 仓库。
  2. 为您的更改创建一个新分支（例如，`git checkout -b feature/your-feature-name`）。
  3. 进行更改并提交。
  4. 提交带有您改进的 pull request。

## 许可证

MIT 许可证。
