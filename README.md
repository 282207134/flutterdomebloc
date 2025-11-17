# BLoC 方法完整示例

这个项目展示了 Flutter BLoC 状态管理库的完整使用方法和各种 API。

## 项目结构

```
lib/
├── main.dart              # 主应用入口和UI组件
└── counter_bloc.dart      # BLoC实现和状态管理
```

## 核心概念

### 1. 事件 (Events)
定义用户可以执行的操作：

```dart
abstract class CounterEvent extends Equatable {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}
class SetValue extends CounterEvent {}
class AsyncIncrement extends CounterEvent {}
```

### 2. 状态 (States)
定义应用的所有可能状态：

```dart
abstract class CounterState extends Equatable {}
class CounterInitial extends CounterState {}
class CounterLoading extends CounterState {}
class CounterUpdated extends CounterState {}
class CounterError extends CounterState {}
```

### 3. BLoC (Business Logic Component)
处理业务逻辑和状态转换：

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    // ... 其他事件处理器
  }
}
```

## 主要 BLoC 方法

### 构造函数方法

#### `Bloc(initialState)`
- 创建 BLoC 实例
- 设置初始状态
- 注册事件处理器

```dart
CounterBloc() : super(const CounterInitial()) {
  on<Increment>(_onIncrement);
  on<Decrement>(_onDecrement);
}
```

### 事件处理方法

#### `on<Event>(handler, {transformer})`
注册事件处理器

```dart
on<Increment>(_onIncrement);
on<AsyncIncrement>(_onAsyncIncrement, 
  transformer: debounce(Duration(milliseconds: 300)));
```

#### `addAll(events)`
批量添加多个事件

```dart
addAll([Increment(), Increment(), Reset()]);
```

#### `add(event)`
添加单个事件到事件流

```dart
context.read<CounterBloc>().add(Increment());
```

### 状态发射方法

#### `emit(state)`
发射新状态

```dart
emit(CounterUpdated(value: state.value + 1));
```

#### `emit.forEach(stream, onData)`
处理流并发射状态

```dart
emit.forEach(
  Stream.periodic(Duration(seconds: 1), (_) => Increment()),
  onData: (event) => CounterUpdated(value: state.value + 1),
);
```

### 错误处理方法

#### `addError(error, stackTrace)`
手动添加错误

```dart
addError('模拟错误', StackTrace.current);
```

#### `onError(handler)`
注册错误处理器

```dart
onError((error, stackTrace) {
  debugPrint('BLoC 错误: $error');
});
```

### 生命周期方法

#### `close()`
关闭 BLoC 并清理资源

```dart
@override
Future<void> close() {
  debugPrint('CounterBloc 正在关闭');
  return super.close();
}
```

### 监听器方法

#### `onEveryEvent(handler)`
监听所有事件

```dart
onEveryEvent((event, emit) {
  debugPrint('事件监听: ${event.runtimeType}');
});
```

#### `onTransition(handler)`
监听状态转换

```dart
onTransition((transition) {
  debugPrint('状态转换: ${transition.currentState} -> ${transition.nextState}');
});
```

## Flutter Widget 方法

### `BlocProvider<BlocType>`
提供 BLoC 实例给子组件

```dart
BlocProvider(
  create: (context) => CounterBloc(),
  child: MyWidget(),
)
```

### `BlocBuilder<BlocType, StateType>`
根据状态构建 UI

```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('计数: ${state.value}');
  },
)
```

### `BlocListener<BlocType, StateType>`
监听状态变化并执行副作用

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

### `BlocConsumer<BlocType, StateType>`
同时监听和构建

```dart
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    // 处理副作用
  },
  builder: (context, state) {
    // 构建 UI
    return MyWidget();
  },
)
```

### `BlocSelector<BlocType, StateType, SelectedType>`
选择状态的一部分重建

```dart
BlocSelector<CounterBloc, CounterState, int>(
  selector: (state) => state.value,
  builder: (context, value) {
    return Text('计数: $value');
  },
)
```

### `context.read<BlocType>()`
获取 BLoC 实例（不监听变化）

```dart
context.read<CounterBloc>().add(Increment());
```

### `context.watch<BlocType>()`
获取 BLoC 实例并监听变化

```dart
final state = context.watch<CounterBloc>().state;
```

### `context.select<BlocType, SelectedType>(selector)`
选择状态的一部分并监听

```dart
final value = context.select<CounterBloc, int>((bloc) => bloc.state.value);
```

## 高级功能

### 事件转换器 (Event Transformers)

#### `debounce`
防抖处理

```dart
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
```

#### `throttle`
节流处理

```dart
EventTransformer<T> throttle<T>(Duration duration) {
  return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
}
```

#### `distinct`
去重处理

```dart
EventTransformer<T> distinct<T>() {
  return (events, mapper) => events.distinct().flatMap(mapper);
}
```

### 批量操作

#### `Batch`
批量执行事件

```dart
const Batch<CounterEvent>([
  Increment(),
  Increment(),
  AsyncIncrement(),
]).forEach(add);
```

## 最佳实践

### 1. 状态设计
- 保持状态不可变
- 使用 Equatable 进行状态比较
- 为每个业务场景定义明确的状态

### 2. 事件设计
- 事件应该是用户操作的抽象
- 保持事件简单和单一职责
- 使用参数化事件传递数据

### 3. BLoC 设计
- 单一职责原则
- 避免在 BLoC 中包含 UI 逻辑
- 使用适当的错误处理

### 4. Widget 使用
- 合理使用不同的 BLoC widgets
- 避免不必要的重建
- 正确处理 BLoC 生命周期

## 运行示例

### 前置条件
- Flutter SDK >=3.10.0
- Dart SDK >=3.0.0

### 安装和运行

1. **克隆或下载项目**
   ```bash
   git clone <repository-url>
   cd bloc-methods-sample
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用**
   ```bash
   flutter run
   ```

4. **运行测试**
   ```bash
   flutter test
   ```

5. **代码分析**
   ```bash
   flutter analyze
   ```

### 在没有Flutter环境的情况下

如果你没有安装Flutter，仍然可以：
- 查看源代码学习BLoC的实现方式
- 阅读文档了解各个方法的使用
- 参考测试用例理解测试策略
1. 安装依赖：
```bash
flutter pub get
```

2. 运行应用：
```bash
flutter run
```

3. 尝试各种操作来了解 BLoC 的工作方式

## 相关资源

- [BLoC 官方文档](https://bloclibrary.dev/)
- [BLoC GitHub 仓库](https://github.com/felangel/bloc)
- [Flutter BLoC 包](https://pub.dev/packages/flutter_bloc)