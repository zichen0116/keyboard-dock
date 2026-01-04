# Keyboard Dock / 笔记本键盘屏蔽工具

[English](#english) | [中文](#中文)

---

## English

### 📌 Overview

**Keyboard Dock** is a lightweight Windows tool designed to temporarily disable keyboard input, solving the common problem of accidental key presses when placing a laptop on your keyboard while watching videos or reading materials and writing notes simultaneously.

### 🎯 Problem It Solves

When using a laptop, you might place the laptop (with its keyboard facing up) beneath documents or notebooks. This often leads to accidental keyboard input.
Keyboard Dock provides a simple, elegant solution by allowing you to quickly disable and re-enable your keyboard.

### ✨ Features

- **🎨 Minimalist Design**: Extremely lightweight and simple interface
- **🖱️ Drag & Drop**: Freely drag the tool window anywhere on your screen
- **👁️ Collapsible Panel**: Hide the control panel to save screen space
- **⌨️ Emergency Hotkey**: `Ctrl+Alt+Backspace` to instantly unblock keyboard (always available)
- **🔒 No Mouse Blocking**: Only keyboard is disabled - mouse remains fully functional for your workflow
- **⚡ Always on Top**: Tool window stays visible above other windows
- **💡 Smart Positioning**: Automatically docks to screen edges

### 🚀 Quick Start

#### Requirements
- Windows OS
- AutoHotkey v2.0

#### Usage
1. Download the file from Releases
2. The tool window will appear at the bottom-right corner of your screen
3. Click the keyboard icon to toggle keyboard blocking on/off
4. Use `Ctrl+Alt+Backspace` anytime to emergency-unblock the keyboard

### 🎨 Interface

- **Keyboard Button**: Toggle keyboard blocking (icon changes color when active)
- **Close Button**: Exit the application  
- **Toggle Handle**: Collapse/expand the control panel
- **Drag Area**: Click and drag the panel to move it

### ⚠️ Emergency Unblock

If you need to use your keyboard urgently (e.g., the mouse stops working), press:
```
Ctrl + Alt + Backspace
```
This hotkey will immediately disable keyboard blocking, regardless of the application state.

### 🛠️ Technical Details

- Built with AutoHotkey v2.0
- Web-based UI using Neutron.ahk framework
- Minimal resource footprint
- No installation required - portable executable

### 🔧 Improvements Over Original Project

Based on [I-wanna-clean-keyboard](https://github.com/Nigh/I-wanna-clean-keyboard), the following improvements were made:

1. **Extremely Simplified**: Removed unnecessary features, focusing on core functionality
2. **Draggable Interface**: Freely position the tool window
3. **Collapsible Panel**: Hide the panel when needed to save screen space
4. **No Mouse Blocking**: Designed for "reading courseware while writing notes" scenario, keeping mouse fully functional
5. **Emergency Hotkey**: Added `Ctrl+Alt+Backspace` shortcut to prevent situations where keyboard input cannot be restored

### 📝 Credits

- Original concept inspired by [I-wanna-clean-keyboard](https://github.com/Nigh/I-wanna-clean-keyboard)
- `web_gui/Neutron.ahk` forked from [G33kDude/Neutron.ahk](https://github.com/G33kDude/Neutron.ahk)

### 📄 License

This project is open source. Feel free to use and modify.

---

## 中文

### 📌 项目简介

**Keyboard Dock（键盘停靠工具）** 是一个轻量级的 Windows 工具,用于临时禁用键盘输入。专门解决在边看视频或课件、边写作业时,笔记本压在键盘上导致误触的问题。

### 🎯 解决的问题

当使用笔记本时,你可能会将笔记本(键盘面朝上)放在文档或本子下方。这经常导致意外的键盘输入。
Keyboard Dock 提供了一个简单优雅的解决方案,让你可以快速禁用和重新启用键盘。

### ✨ 功能特性

- **🎨 极简设计**: 极度精简的轻量级界面
- **🖱️ 自由拖拽**: 可以将工具窗口拖拽到屏幕任意位置
- **👁️ 可折叠面板**: 隐藏控制面板以节省屏幕空间
- **⌨️ 紧急热键**: `Ctrl+Alt+Backspace` 快速解除键盘禁用(始终可用)
- **🔒 不阻止鼠标**: 仅禁用键盘 - 鼠标保持完全可用以配合工作流程
- **⚡ 窗口置顶**: 工具窗口始终保持在其他窗口之上
- **💡 智能定位**: 自动停靠到屏幕边缘

### 🚀 快速开始

#### 系统要求
- Windows 操作系统
- AutoHotkey v2.0

#### 使用方法
1. 下载Releases中的文件
2. 工具窗口将出现在屏幕右下角
3. 点击键盘图标以切换键盘阻止的开/关状态
4. 随时使用 `Ctrl+Alt+Backspace` 紧急解除键盘禁用

### 🎨 界面说明

- **键盘按钮**: 切换键盘阻止状态(激活时图标会改变颜色)
- **关闭按钮**: 退出应用程序
- **折叠手柄**: 折叠/展开控制面板
- **拖拽区域**: 点击并拖拽面板来移动它

### ⚠️ 紧急解除

如果你需要紧急使用键盘(例如鼠标停止工作),请按:
```
Ctrl + Alt + Backspace
```
此热键将立即禁用键盘阻止功能,无论应用程序处于何种状态。

### 🔧 与原项目的改进

基于 [I-wanna-clean-keyboard](https://github.com/Nigh/I-wanna-clean-keyboard) 进行了以下针对性改进:

1. **极度精简**: 移除了不必要的功能,专注核心需求
2. **可拖拽移动**: 自由定位工具窗口
3. **可折叠界面**: 需要时隐藏面板,节省屏幕空间
4. **无鼠标阻止**: 针对"边看课件边写作业"场景,保留鼠标操作能力
5. **紧急热键**: 添加 `Ctrl+Alt+Backspace` 快捷键,防止特殊情况下无法恢复键盘输入

### 🛠️ 技术细节

- 使用 AutoHotkey v2.0 构建
- 基于 Neutron.ahk 框架的 Web UI
- 极小的资源占用
- 无需安装 - 便携式可执行文件

### 📝 致谢

- 原始创意灵感来自 [I-wanna-clean-keyboard](https://github.com/Nigh/I-wanna-clean-keyboard)
- `web_gui/Neutron.ahk` 从 [G33kDude/Neutron.ahk](https://github.com/G33kDude/Neutron.ahk) Fork

### 📄 开源协议

本项目开源,可自由使用和修改。
