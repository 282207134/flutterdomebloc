# BLoC 方法快速参考

## 核心 BLoC 类方法

### 构造和初始化
- `Bloc(initialState)` - 创建 BLoC 实例
- `super(state)` - 设置初始状态

### 事件处理
- `on<Event>(handler, {transformer})` - 注册事件处理器
- `add(event)` - 添加事件
- `addAll(events)` - 批量添加事件
- `addRepository(repository)` - 添加仓库（已弃用）

### 状态管理
- `emit(state)` - 发射新状态
- `emit.forEach(stream, onData)` - 处理流并发射状态

### 错误处理
- `addError(error, stackTrace)` - 添加错误
- `onError(handler)` - 注册错误处理器

### 生命周期
- `close()` - 关闭 BLoC

### 监听器
- `onEveryEvent(handler)` - 监听所有事件
- `onTransition(handler)` - 监听状态转换

### 属性访问
- `state` - 当前状态
- `stream` - 状态流
- `isClosed` - 是否已关闭

## Flutter BLoC Widgets

### Provider
- `BlocProvider` - 提供 BLoC 实例
- `RepositoryProvider` - 提供仓库实例

### Builders
- `BlocBuilder` - 根据状态构建 UI
- `BlocSelector` - 选择状态部分重建

### Listeners
- `BlocListener` - 监听状态变化
- `MultiBlocListener` - 多个监听器

### Consumers
- `BlocConsumer` - 同时监听和构建
- `MultiBlocProvider` - 多个提供者

### Context 扩展
- `context.read<T>()` - 获取实例（不监听）
- `context.watch<T>()` - 获取实例并监听
- `context.select<T, R>()` - 选择状态部分监听

## 事件转换器

- `debounce(duration)` - 防抖
- `throttle(duration)` - 节流
- `distinct()` - 去重
- `concurrent()` - 并发处理

## 实用工具

- `Batch<T>(events)` - 批量事件
- `Equatable` - 状态比较
- `BlocObserver` - 全局观察者
- `HydratedBloc` - 状态持久化

## 生命周期钩子

```dart
class MyBloc extends Bloc<Event, State> {
  @override
  void onEvent(Event event) { /* 事件添加前 */ }
  
  @override
  void onChange(Change<State> change) { /* 状态变化时 */ }
  
  @override
  void onTransition(Transition<Event, State> transition) { /* 状态转换时 */ }
  
  @override
  void onError(Object error, StackTrace stackTrace) { /* 错误发生时 */ }
  
  @override
  Future<void> close() { /* BLoC 关闭时 */ }
}
```