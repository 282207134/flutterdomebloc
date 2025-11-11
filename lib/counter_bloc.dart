import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

// 事件定义 - 用户可以执行的所有操作
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

// 增加计数事件
class Increment extends CounterEvent {}

// 减少计数事件
class Decrement extends CounterEvent {}

// 重置计数事件
class Reset extends CounterEvent {}

// 设置特定值事件
class SetValue extends CounterEvent {
  final int value;

  const SetValue(this.value);

  @override
  List<Object> get props => [value];
}

// 异步增加事件
class AsyncIncrement extends CounterEvent {}

// 状态定义 - 计数器的所有可能状态
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

// 初始状态
class CounterInitial extends CounterState {
  const CounterInitial() : super(value: 0, status: 'initial');

  @override
  String toString() => 'CounterInitial { value: $value, status: $status }';
}

// 加载状态
class CounterLoading extends CounterState {
  const CounterLoading({required super.value}) : super(status: 'loading');

  @override
  String toString() => 'CounterLoading { value: $value, status: $status }';
}

// 更新状态
class CounterUpdated extends CounterState {
  const CounterUpdated({required super.value}) : super(status: 'updated');

  @override
  String toString() => 'CounterUpdated { value: $value, status: $status }';
}

// 错误状态
class CounterError extends CounterState {
  final String error;

  const CounterError({
    required super.value,
    required this.error,
  }) : super(status: 'error');

  @override
  List<Object> get props => [value, status, error];

  @override
  String toString() => 'CounterError { value: $value, status: $status, error: $error }';
}

// BLoC 实现 - 核心业务逻辑
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // 构造函数 - 初始化BLoC
  CounterBloc() : super(const CounterInitial()) {
    // 注册事件处理器
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
    on<SetValue>(_onSetValue);
    on<AsyncIncrement>(_onAsyncIncrement);
    
    // 添加事件监听器
    onEveryEvent(_onEveryEvent);
    onTransition(_onTransition);
    onError(_onError);
  }

  // 处理增加事件
  Future<void> _onIncrement(
    Increment event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 Increment 事件');
    emit(CounterUpdated(value: state.value + 1));
  }

  // 处理减少事件
  Future<void> _onDecrement(
    Decrement event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 Decrement 事件');
    if (state.value > 0) {
      emit(CounterUpdated(value: state.value - 1));
    } else {
      emit(CounterError(
        value: state.value,
        error: '计数器不能小于0',
      ));
    }
  }

  // 处理重置事件
  Future<void> _onReset(
    Reset event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 Reset 事件');
    emit(const CounterUpdated(value: 0));
  }

  // 处理设置值事件
  Future<void> _onSetValue(
    SetValue event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 SetValue 事件: ${event.value}');
    if (event.value < 0) {
      emit(CounterError(
        value: state.value,
        error: '设置的值不能为负数',
      ));
      return;
    }
    emit(CounterUpdated(value: event.value));
  }

  // 处理异步增加事件
  Future<void> _onAsyncIncrement(
    AsyncIncrement event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 AsyncIncrement 事件');
    emit(CounterLoading(value: state.value));
    
    try {
      // 模拟异步操作
      await Future.delayed(const Duration(seconds: 1));
      emit(CounterUpdated(value: state.value + 5));
    } catch (error) {
      emit(CounterError(
        value: state.value,
        error: error.toString(),
      ));
    }
  }

  // 监听所有事件
  Future<void> _onEveryEvent(
    CounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('事件监听: ${event.runtimeType}');
  }

  // 监听状态转换
  void _onTransition(
    Transition<CounterEvent, CounterState> transition,
  ) {
    debugPrint('状态转换: ${transition.currentState} -> ${transition.nextState} '
        'via ${transition.event}');
  }

  // 错误处理
  void _onError(Object error, StackTrace stackTrace) {
    debugPrint('BLoC 错误: $error');
    debugPrint('堆栈跟踪: $stackTrace');
  }

  // 添加自定义方法
  void incrementBy(int amount) {
    add(SetValue(state.value + amount));
  }

  // 批量操作
  void performBatchOperations() {
    const Batch<CounterEvent>([
      Increment(),
      Increment(),
      AsyncIncrement(),
    ]).forEach(add);
  }

  // 条件性添加事件
  void conditionalIncrement(bool condition) {
    if (condition) {
      add(Increment());
    }
  }

  @override
  Future<void> close() {
    debugPrint('CounterBloc 正在关闭');
    return super.close();
  }
}

// 高级BLoC示例 - 展示更多BLoC方法
class AdvancedCounterBloc extends Bloc<CounterEvent, CounterState> {
  int _operationCount = 0;

  AdvancedCounterBloc() : super(const CounterInitial()) {
    on<Increment>(_onIncrement, transformer: debounce(const Duration(milliseconds: 300)));
    on<Decrement>(_onDecrement);
    
    // 使用 addAll 添加多个事件
    addAll([const Increment(), const Increment()]);
  }

  // 使用防抖转换器
  Future<void> _onIncrement(
    Increment event,
    Emitter<CounterState> emit,
  ) async {
    _operationCount++;
    emit(CounterUpdated(value: state.value + 1));
  }

  Future<void> _onDecrement(
    Decrement event,
    Emitter<CounterState> emit,
  ) async {
    _operationCount++;
    emit(CounterUpdated(value: state.value - 1));
  }

  // 获取操作计数
  int get operationCount => _operationCount;

  // 使用 emit.forEach 处理流
  void startPeriodicIncrement() {
    emit.forEach(
      Stream.periodic(const Duration(seconds: 1), (_) => Increment()),
      onData: (event) => CounterUpdated(value: state.value + 1),
    );
  }

  // 重写状态流
  @override
  Stream<CounterState> get stream => super.stream.map((state) {
    debugPrint('流状态: $state');
    return state;
  });

  // 使用 addError 添加错误
  void simulateError() {
    addError('模拟错误', StackTrace.current);
  }
}

// 防抖转换器
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}