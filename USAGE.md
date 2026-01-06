# 使用示例和代码片段

## 📱 应用功能预览

运行应用后，你会看到：

### 当前状态区域
显示实时计数和当前状态

### 基础操作
- 增加 (+1)
- 减少 (-1)
- 重置
- 异步增加 (+5)

### 高级操作
- 设置特定值
- 增加10（自定义方法）
- 批量操作
- 条件增加

### 监听器
自动显示错误和加载提示

## 💻 代码示例

### 添加事件

```dart
context.read<CounterBloc>().add(const Increment());
```

### 监听状态

```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('计数: ${state.value}');
  },
)
```

### 处理错误

```dart
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state is CounterError) {
      // 显示错误
    }
  },
)
```

## 🎯 学习路径

### 初学者

1. **运行应用** - 理解应用功能
2. **阅读 `counter_bloc.dart`** - 了解事件和状态定义
3. **阅读 `main.dart`** - 了解 UI 如何使用 BLoC
4. **查看测试** - 了解如何测试 BLoC

### 中级开发者

1. **修改事件处理器** - 改变业务逻辑
2. **添加新事件** - 扩展功能
3. **自定义状态** - 添加新状态
4. **编写测试** - 为新功能编写测试

### 高级开发者

1. **实现事件转换器** - 防抖、节流等
2. **优化性能** - 减少不必要的重建
3. **错误处理** - 完善错误处理机制
4. **架构设计** - 应用到实际项目

## 💡 使用技巧

### 热重载

运行 `flutter run` 后：
- 按 `r` - 热重载（保持应用状态）
- 按 `R` - 热重启（重置应用状态）
- 按 `q` - 退出应用

### 查看日志

应用运行时会输出详细的 BLoC 事件和状态转换日志：

```
flutter: 事件监听: Increment
flutter: 状态转换: CounterInitial { value: 0, status: initial } -> CounterUpdated { value: 1, status: updated } via Instance of 'Increment'
```

## ✨ 示例代码片段

### 添加事件

```dart
// 在 UI 中添加事件
ElevatedButton(
  onPressed: () {
    context.read<CounterBloc>().add(const Increment());
  },
  child: const Text('增加'),
)
```

### 监听状态

```dart
// 使用 BlocBuilder 构建 UI
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('计数: ${state.value}');
  },
)

// 使用 BlocListener 执行副作用
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state is CounterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: YourWidget(),
)
```

### 自定义方法

```dart
// 在 BLoC 中添加自定义方法
void incrementBy(int amount) {
  add(SetValue(state.value + amount));
}

// 在 UI 中调用
context.read<CounterBloc>().incrementBy(10);
```