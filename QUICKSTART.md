# 快速开始指南

## 🚀 5分钟快速启动

### 第一步：安装依赖

```bash
flutter pub get
```

> **注意**: 如果遇到 `rxdart` 包相关的编译错误，请检查 `pubspec.yaml` 文件中是否已包含 `rxdart` 依赖，如没有请添加并再次运行 `flutter pub get`。

### 第二步：运行应用

```bash
flutter run
```

就这么简单！应用会自动在可用设备上启动。

## 📱 应用界面说明

### 主界面分为五个区域：

#### 1️⃣ 当前状态区域
- 显示当前计数值
- 显示状态类型（initial/loading/updated/error）
- 如果有错误，显示错误信息

#### 2️⃣ 基础操作区域
- **增加 (+1)**：每次点击增加1
- **减少 (-1)**：每次点击减少1（不能小于0）
- **重置**：将计数重置为0
- **异步增加 (+5)**：模拟异步操作，1秒后增加5

#### 3️⃣ 高级操作区域
- **设置特定值**：打开对话框输入任意非负整数
- **增加10**：使用自定义方法一次增加10
- **批量操作**：连续执行多个操作（+1, +1, 异步+5）
- **条件增加**：根据条件决定是否增加

#### 4️⃣ BLoC 监听示例区域
- 自动监听状态变化
- 错误时显示红色提示
- 加载时显示黄色提示

#### 5️⃣ 高级示例页面（可扩展）
- 演示防抖功能
- 演示 BlocSelector 和 BlocConsumer
- 演示错误处理

## 🧪 运行测试

```bash
flutter test
```

测试覆盖了：
- ✅ 所有事件处理器
- ✅ 状态转换
- ✅ 错误情况
- ✅ 自定义方法
- ✅ 批量操作
- ✅ 条件逻辑

## 📚 代码示例

### 如何添加事件

```dart
// 方式1：使用 context
context.read<CounterBloc>().add(const Increment());

// 方式2：直接使用 bloc 实例
bloc.add(const Increment());
```

### 如何监听状态

```dart
// 方式1：BlocBuilder - 用于构建UI
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('计数: ${state.value}');
  },
)

// 方式2：BlocListener - 用于执行副作用
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state is CounterError) {
      // 显示错误提示
    }
  },
  child: YourWidget(),
)

// 方式3：BlocConsumer - 结合两者
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    // 执行副作用
  },
  builder: (context, state) {
    // 构建UI
  },
)
```

### 如何创建自定义 BLoC 方法

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // 自定义方法
  void incrementBy(int amount) {
    add(SetValue(state.value + amount));
  }
  
  // 批量操作
  void performBatchOperations() {
    const events = [
      Increment(),
      Increment(),
      AsyncIncrement(),
    ];
    for (final event in events) {
      add(event);
    }
  }
}
```

## 🎯 学习路径

### 初学者
1. 先运行应用，熟悉界面和功能
2. 查看 `lib/counter_bloc.dart` 了解事件和状态定义
3. 查看 `lib/main.dart` 了解如何使用 BLoC widgets

### 中级开发者
1. 研究事件处理器的实现
2. 理解状态转换的过程
3. 学习错误处理机制
4. 查看测试文件了解如何测试 BLoC

### 高级开发者
1. 研究防抖转换器的实现
2. 了解 emit.forEach 的使用
3. 实现自己的事件转换器
4. 扩展项目添加更多功能

## 🔍 调试技巧

### 查看调试输出

所有 BLoC 事件和状态转换都会输出到控制台：

```
flutter: 事件监听: Increment
flutter: 状态转换: CounterInitial { value: 0, status: initial } -> CounterUpdated { value: 1, status: updated } via Instance of 'Increment'
```

### 使用 BLoC Observer

添加全局 BLoC 观察者来监控所有 BLoC 实例：

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition $transition');
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}
```

## 💡 最佳实践

1. **事件命名**：使用动词形式（Increment, Reset）
2. **状态命名**：使用形容词或过去分词（Initial, Loading, Updated）
3. **使用 const**：对于无参数的事件和状态使用 const
4. **错误处理**：始终在异步操作中捕获错误
5. **测试**：为每个事件处理器编写测试

## 🆘 常见问题

**Q: 为什么状态没有更新？**
A: 确保状态类实现了 Equatable 并正确定义了 props。

**Q: 如何处理异步操作？**
A: 在事件处理器中使用 async/await，通过 emit 发送多个状态。

**Q: 如何在不同页面共享 BLoC？**
A: 将 BlocProvider 放在更高层级的 Widget 树中。

**Q: 如何关闭 BLoC？**
A: BlocProvider 会自动处理，也可以手动调用 bloc.close()。

## 📖 进一步学习

- 阅读 `README.md` 了解详细的 BLoC 概念
- 阅读 `BLOC_METHODS.md` 查看所有 BLoC 方法
- 访问 [bloclibrary.dev](https://bloclibrary.dev) 官方文档
- 探索 [GitHub 示例](https://github.com/felangel/bloc/tree/master/examples)

## 🎉 恭喜！

您已经准备好开始使用 BLoC 进行状态管理了！
