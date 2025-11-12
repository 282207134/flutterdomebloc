# BLoC 方法完整示例 - 使用指南

这个项目是一个完整的 Flutter BLoC 状态管理示例，展示了 BLoC 库的所有主要功能和方法。

## 项目结构

```
bloc-methods-sample/
├── lib/
│   ├── main.dart              # 主应用入口和UI组件
│   └── counter_bloc.dart      # BLoC实现和状态管理
├── test/
│   └── counter_bloc_test.dart # 单元测试
├── pubspec.yaml               # 项目依赖
├── README.md                  # 详细文档
├── BLOC_METHODS.md           # 快速参考
└── analysis_options.yaml      # 代码分析配置
```

## 快速开始

### 1. 安装依赖
```bash
flutter pub get
```

### 2. 运行应用
```bash
flutter run
```

### 3. 运行测试
```bash
flutter test
```

## 功能特性

### 🎯 核心BLoC方法
- ✅ 事件处理：`on()`, `add()`, `addAll()`
- ✅ 状态管理：`emit()`, `emit.forEach()`
- ✅ 生命周期：`close()`, `onEvent()`, `onTransition()`, `onError()`
- ✅ 高级功能：事件转换器、批量操作、自定义方法

### 🎨 Flutter集成
- ✅ `BlocProvider` - 依赖注入
- ✅ `BlocBuilder` - 状态构建
- ✅ `BlocListener` - 状态监听
- ✅ `BlocConsumer` - 监听+构建
- ✅ `BlocSelector` - 选择性重建
- ✅ Context扩展：`read()`, `watch()`, `select()`

### 🔄 事件类型
- ✅ 同步事件：Increment, Decrement, Reset, SetValue
- ✅ 异步事件：AsyncIncrement（带加载状态）
- ✅ 错误处理：CounterError状态

### 🎛️ 高级功能
- ✅ 防抖转换器（debounce）
- ✅ 批量操作
- ✅ 条件性事件添加
- ✅ 自定义BLoC方法
- ✅ 状态转换监听
- ✅ 全局错误处理

## 代码示例

### 基础BLoC使用

```dart
// 1. 创建BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
  }

  Future<void> _onIncrement(Increment event, Emitter<CounterState> emit) async {
    emit(CounterUpdated(value: state.value + 1));
  }
}

// 2. 在UI中使用
BlocProvider(
  create: (context) => CounterBloc(),
  child: BlocBuilder<CounterBloc, CounterState>(
    builder: (context, state) {
      return Text('计数: ${state.value}');
    },
  ),
)
```

### 高级功能示例

```dart
// 防抖处理
on<Increment>(_onIncrement, transformer: debounce(Duration(milliseconds: 300)));

// 批量操作
void performBatchOperations() {
  final events = [Increment(), Increment(), AsyncIncrement()];
  for (final event in events) {
    add(event);
  }
}

// 异步操作
Future<void> _onAsyncIncrement(AsyncIncrement event, Emitter<CounterState> emit) async {
  emit(CounterLoading(value: state.value));
  await Future.delayed(Duration(seconds: 1));
  emit(CounterUpdated(value: state.value + 5));
}
```

## 学习路径

### 1. 基础概念
- 理解事件、状态、BLoC的关系
- 学习基本的事件处理和状态发射
- 掌握简单的UI集成

### 2. 进阶功能
- 异步事件处理
- 错误状态管理
- 生命周期钩子

### 3. 高级技巧
- 事件转换器（防抖、节流）
- 批量操作
- 性能优化技巧

### 4. 最佳实践
- BLoC设计原则
- 测试策略
- 项目架构

## 测试覆盖

项目包含完整的单元测试，覆盖：
- ✅ 所有事件处理逻辑
- ✅ 状态转换验证
- ✅ 异步操作测试
- ✅ 错误处理测试
- ✅ 自定义方法测试

## 文档资源

- 📖 [README.md](README.md) - 完整的使用文档
- 📋 [BLOC_METHODS.md](BLOC_METHODS.md) - 快速方法参考
- 🧪 [测试文件](test/counter_bloc_test.dart) - 测试示例

## 常见问题

### Q: 如何处理异步操作？
A: 使用 `emit()` 先发射加载状态，然后在异步操作完成后发射结果状态。

### Q: 如何避免频繁的状态更新？
A: 使用事件转换器如 `debounce()` 来防抖处理。

### Q: 如何在多个页面共享BLoC？
A: 在应用的根部使用 `BlocProvider` 创建BLoC实例。

### Q: 如何处理复杂的业务逻辑？
A: 将复杂逻辑拆分为多个小事件，或者使用Repository模式分离数据层。

## 贡献

欢迎提交问题和改进建议！这个项目旨在成为学习Flutter BLoC的最佳参考。

---

**注意**: 这是一个学习示例项目，展示了BLoC库的完整功能。在实际项目中，请根据具体需求选择合适的功能。