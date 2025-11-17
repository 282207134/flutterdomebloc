# BLoC 方法完整示例

[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/BLoC-8.1.2-blue.svg)](https://bloclibrary.dev)

这是一个完整的 Flutter BLoC 状态管理示例项目，展示了 BLoC 库的所有主要 API 和使用模式。

## 📋 目录

- [快速开始](#-快速开始)
- [项目结构](#-项目结构)
- [核心概念](#-核心概念)
- [主要功能](#-主要功能)
- [BLoC 方法详解](#-bloc-方法详解)
- [Flutter Widget](#-flutter-widget)
- [高级功能](#-高级功能)
- [最佳实践](#-最佳实践)
- [测试](#-测试)
- [相关资源](#-相关资源)

## 🚀 快速开始

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
flutter run
```

### 运行测试

```bash
flutter test
```

详细的设置和运行指南请查看 [QUICKSTART.md](QUICKSTART.md) 和 [SETUP.md](SETUP.md)。

## 📁 项目结构

```
bloc_methods_sample/
├── lib/
│   ├── main.dart              # 主应用入口和UI组件
│   └── counter_bloc.dart      # BLoC 实现（事件、状态、业务逻辑）
├── test/
│   └── counter_bloc_test.dart # 完整的单元测试
├── pubspec.yaml               # 项目依赖配置
├── README.md                  # 本文件 - 项目说明
├── QUICKSTART.md             # 快速开始指南
├── SETUP.md                  # 详细设置指南
├── BLOC_METHODS.md           # BLoC 方法快速参考
├── USAGE.md                  # 使用示例和代码片段
└── PROJECT_SUMMARY.md        # 项目总结
```

## 🎯 核心概念

### 1. 事件 (Events)

事件代表用户可以执行的操作：

```dart
abstract class CounterEvent extends Equatable {
  const CounterEvent();
  
  @override
  List<Object> get props => [];
}

class Increment extends CounterEvent {
  const Increment();
}

class Decrement extends CounterEvent {
  const Decrement();
}

class Reset extends CounterEvent {
  const Reset();
}

class SetValue extends CounterEvent {
  final int value;
  const SetValue(this.value);
  
  @override
  List<Object> get props => [value];
}

class AsyncIncrement extends CounterEvent {
  const AsyncIncrement();
}
```

### 2. 状态 (States)

状态代表应用的所有可能状态：

```dart
abstract class CounterState extends Equatable {
  final int value;
  final String status;

  const CounterState({
    required this.value,
    required this.status,
  });

  @override
  List<Object> get props => [value, status];
}

class CounterInitial extends CounterState {
  const CounterInitial() : super(value: 0, status: 'initial');
}

class CounterLoading extends CounterState {
  const CounterLoading({required super.value}) : super(status: 'loading');
}

class CounterUpdated extends CounterState {
  const CounterUpdated({required super.value}) : super(status: 'updated');
}

class CounterError extends CounterState {
  final String error;
  
  const CounterError({
    required super.value,
    required this.error,
  }) : super(status: 'error');

  @override
  List<Object> get props => [value, status, error];
}
```

### 3. BLoC (Business Logic Component)

BLoC 处理业务逻辑和状态转换：

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
    on<SetValue>(_onSetValue);
    on<AsyncIncrement>(_onAsyncIncrement);
  }

  Future<void> _onIncrement(
    Increment event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterUpdated(value: state.value + 1));
  }

  // ... 其他事件处理器
}
```

## ⚡ 主要功能

### 基础操作
- ✅ **增加计数 (+1)**：同步增加计数
- ✅ **减少计数 (-1)**：同步减少计数（带错误处理）
- ✅ **重置计数**：重置为初始值
- ✅ **异步增加 (+5)**：模拟异步操作

### 高级操作
- ✅ **设置特定值**：通过对话框输入任意值
- ✅ **自定义方法**：使用自定义 BLoC 方法
- ✅ **批量操作**：一次性执行多个事件
- ✅ **条件增加**：根据条件决定是否执行

### BLoC 特性
- ✅ **事件监听**：监听所有事件
- ✅ **状态转换监听**：监听状态变化
- ✅ **错误处理**：完整的错误处理机制
- ✅ **防抖转换器**：避免重复事件
- ✅ **生命周期管理**：正确的资源清理

## 📚 BLoC 方法详解

### 构造函数方法

#### `Bloc(initialState)`

创建 BLoC 实例并设置初始状态：

```dart
CounterBloc() : super(const CounterInitial()) {
  on<Increment>(_onIncrement);
  on<Decrement>(_onDecrement);
}
```

### 事件处理方法

#### `on<Event>(handler, {transformer})`

注册事件处理器：

```dart
on<Increment>(_onIncrement);
on<AsyncIncrement>(
  _onAsyncIncrement,
  transformer: debounce(const Duration(milliseconds: 300)),
);
```

#### `add(event)`

添加事件到事件流：

```dart
bloc.add(const Increment());
context.read<CounterBloc>().add(const Increment());
```

### 状态发射方法

#### `emit(state)`

发射新状态：

```dart
emit(CounterUpdated(value: state.value + 1));
```

#### `emit.forEach(stream, onData)`

处理流并发射状态：

```dart
emit.forEach<CounterEvent>(
  Stream.periodic(const Duration(seconds: 1), (_) => const Increment()),
  onData: (_) => CounterUpdated(value: state.value + 1),
);
```

### 生命周期方法

#### `close()`

关闭 BLoC 并清理资源：

```dart
@override
Future<void> close() {
  debugPrint('CounterBloc 正在关闭');
  return super.close();
}
```

### 监听器方法

#### `onEvent(event)`

监听所有事件：

```dart
@override
void onEvent(CounterEvent event) {
  debugPrint('事件监听: ${event.runtimeType}');
  super.onEvent(event);
}
```

#### `onTransition(transition)`

监听状态转换：

```dart
@override
void onTransition(Transition<CounterEvent, CounterState> transition) {
  debugPrint('状态转换: ${transition.currentState} -> ${transition.nextState}');
  super.onTransition(transition);
}
```

#### `onError(error, stackTrace)`

错误处理：

```dart
@override
void onError(Object error, StackTrace stackTrace) {
  debugPrint('BLoC 错误: $error');
  super.onError(error, stackTrace);
}
```

### 自定义方法

#### `addError(error, stackTrace)`

手动添加错误：

```dart
addError('模拟错误', StackTrace.current);
```

## 🎨 Flutter Widget

### BlocProvider

提供 BLoC 实例给子组件：

```dart
BlocProvider(
  create: (context) => CounterBloc(),
  child: const CounterPage(),
)
```

### BlocBuilder

根据状态构建 UI：

```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('计数: ${state.value}');
  },
)
```

### BlocListener

监听状态变化并执行副作用：

```dart
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state is CounterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: MyWidget(),
)
```

### BlocConsumer

同时监听和构建：

```dart
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    // 处理副作用
  },
  builder: (context, state) {
    return Text('计数: ${state.value}');
  },
)
```

### BlocSelector

选择状态的一部分重建：

```dart
BlocSelector<CounterBloc, CounterState, int>(
  selector: (state) => state.value,
  builder: (context, value) {
    return Text('计数: $value');
  },
)
```

### Context 扩展方法

```dart
// 获取 BLoC 实例（不监听）
context.read<CounterBloc>().add(const Increment());

// 获取 BLoC 实例并监听
final state = context.watch<CounterBloc>().state;

// 选择状态的一部分并监听
final value = context.select<CounterBloc, int>((bloc) => bloc.state.value);
```

## 🔥 高级功能

### 事件转换器

#### 防抖 (Debounce)

```dart
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

on<Increment>(
  _onIncrement,
  transformer: debounce(const Duration(milliseconds: 300)),
);
```

#### 节流 (Throttle)

```dart
on<SearchChanged>(
  _onSearchChanged,
  transformer: throttle(const Duration(milliseconds: 500)),
);
```

### 批量操作

```dart
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
```

### 条件操作

```dart
void conditionalIncrement(bool condition) {
  if (condition) {
    add(const Increment());
  }
}
```

## ✨ 最佳实践

### 1. 状态设计

- ✅ 保持状态不可变
- ✅ 使用 Equatable 进行状态比较
- ✅ 为每个业务场景定义明确的状态
- ✅ 使用 const 构造函数

### 2. 事件设计

- ✅ 事件应该是用户操作的抽象
- ✅ 保持事件简单和单一职责
- ✅ 使用参数化事件传递数据
- ✅ 事件命名使用动词形式

### 3. BLoC 设计

- ✅ 单一职责原则
- ✅ 避免在 BLoC 中包含 UI 逻辑
- ✅ 使用适当的错误处理
- ✅ 正确清理资源

### 4. Widget 使用

- ✅ 合理使用不同的 BLoC widgets
- ✅ 避免不必要的重建
- ✅ 正确处理 BLoC 生命周期
- ✅ 使用 context.read 而不是 watch 来添加事件

## 🧪 测试

项目包含完整的单元测试，覆盖了：

- ✅ 所有事件处理器
- ✅ 状态转换
- ✅ 错误情况
- ✅ 自定义方法
- ✅ 批量操作
- ✅ 条件逻辑

运行测试：

```bash
flutter test
```

查看测试覆盖率：

```bash
flutter test --coverage
```

测试示例：

```dart
blocTest<CounterBloc, CounterState>(
  '添加 Increment 事件应该增加计数',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(const Increment()),
  expect: () => [const CounterUpdated(value: 1)],
);
```

## 📖 相关文档

- [QUICKSTART.md](QUICKSTART.md) - 5分钟快速开始指南
- [SETUP.md](SETUP.md) - 详细的设置和配置指南
- [BLOC_METHODS.md](BLOC_METHODS.md) - BLoC 方法快速参考手册
- [USAGE.md](USAGE.md) - 详细的使用示例和代码片段
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - 项目总结和架构说明

## 🔗 相关资源

- [BLoC 官方文档](https://bloclibrary.dev/)
- [BLoC GitHub 仓库](https://github.com/felangel/bloc)
- [Flutter BLoC 包](https://pub.dev/packages/flutter_bloc)
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言文档](https://dart.dev/guides)

## 📄 许可证

本项目仅用于学习和演示目的。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题或建议，请提交 Issue。

---

**Happy Coding! 🎉**
