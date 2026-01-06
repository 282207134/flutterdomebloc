# 项目设置和运行指南

## 前置要求

在运行此项目之前，请确保您已安装：

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)

## 安装步骤

### 1. 克隆项目

```bash
git clone <repository-url>
cd bloc_methods_sample
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 运行项目

#### 在模拟器或设备上运行

```bash
flutter run
```

#### 运行 Web 版本

```bash
flutter run -d chrome
```

#### 运行 iOS 版本（仅限 macOS）

```bash
flutter run -d ios
```

#### 运行 Android 版本

```bash
flutter run -d android
```

### 4. 运行测试

```bash
flutter test
```

### 5. 生成测试覆盖率报告

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 6. 依赖项说明

> **注意**: 如果遇到 `rxdart` 包相关的编译错误，请确保 `pubspec.yaml` 文件中已包含 `rxdart` 依赖：

```yaml
dependencies:
  # ... 其他依赖
  rxdart: ^0.27.7
```

然后再次运行 `flutter pub get` 安装新添加的依赖。

## 项目结构

```
bloc_methods_sample/
├── lib/
│   ├── main.dart              # 主应用入口和UI组件
│   └── counter_bloc.dart      # BLoC 实现（事件、状态、业务逻辑）
├── test/
│   └── counter_bloc_test.dart # 单元测试
├── pubspec.yaml               # 项目依赖配置
├── README.md                  # 项目说明文档
├── BLOC_METHODS.md           # BLoC 方法快速参考
└── SETUP.md                  # 本文件 - 设置和运行指南
```

## 功能特性

### 基础操作
- ✅ 增加计数 (+1)
- ✅ 减少计数 (-1)
- ✅ 重置计数
- ✅ 异步增加 (+5)

### 高级操作
- ✅ 设置特定值
- ✅ 自定义增量（增加10）
- ✅ 批量操作
- ✅ 条件增加

### BLoC 特性
- ✅ 事件监听（onEvent）
- ✅ 状态转换监听（onTransition）
- ✅ 错误处理（onError）
- ✅ 防抖转换器
- ✅ BlocProvider、BlocBuilder、BlocListener
- ✅ BlocConsumer、BlocSelector

## 常见问题

### 问题：Flutter 命令未找到

**解决方案**：确保已安装 Flutter SDK 并将其添加到环境变量 PATH 中。

```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

### 问题：依赖安装失败

**解决方案**：清除缓存并重新安装

```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### 问题：运行时出错

**解决方案**：确保所有依赖版本兼容

```bash
flutter doctor
flutter pub upgrade
```

## 开发模式

### 热重载

在 `flutter run` 运行时，按 `r` 键进行热重载，按 `R` 键进行热重启。

### 调试模式

使用 VS Code 或 Android Studio 的调试功能：

1. 在代码中设置断点
2. 按 F5 启动调试
3. 使用调试工具栏进行单步调试

## 代码格式化

```bash
# 格式化所有 Dart 文件
dart format .

# 检查代码风格
flutter analyze
```

## 生成文档

```bash
dart doc .
```

## 额外资源

- [Flutter 官方文档](https://flutter.dev/docs)
- [BLoC 库文档](https://bloclibrary.dev)
- [Dart 语言文档](https://dart.dev/guides)

## 联系方式

如有问题或建议，请提交 Issue 或 Pull Request。
