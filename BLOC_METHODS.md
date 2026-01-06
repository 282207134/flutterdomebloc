# BLoC 方法快速参考

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

## 🔥 高级功能

### 事件转换器

#### 防抖 (Debounce)

```dart
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
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