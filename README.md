# BLoC 方法完整示例

[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/BLoC-8.1.2-blue.svg)](https://bloclibrary.dev)

这是一个完整的 Flutter BLoC 状态管理示例项目，展示了 BLoC 库的所有主要 API 和使用模式。

## 🚀 快速开始

```bash
flutter create .  # 如果是新下载的项目，首次运行前需要执行
flutter pub get
flutter run
flutter test
```

> **注意**: 如果遇到编译错误，请先运行 `flutter pub get` 确保所有依赖都已正确安装。

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

---

**Happy Coding! 🎉**
