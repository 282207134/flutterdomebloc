import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rxdart/rxdart.dart';

// 事件定义 - 用户可以执行的所有操作
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

// 增加计数事件
class Increment extends CounterEvent {
  const Increment();
}

// 减少计数事件
class Decrement extends CounterEvent {
  const Decrement();
}

// 重置计数事件
class Reset extends CounterEvent {
  const Reset();
}

// 设置特定值事件
class SetValue extends CounterEvent {
  final int value;

  const SetValue(this.value);

  @override
  List<Object> get props => [value];
}

// 异步增加事件
class AsyncIncrement extends CounterEvent {
  const AsyncIncrement();
}

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
    debugPrint('处理 Increment 事件');
    emit(CounterUpdated(value: state.value + 1));
  }

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

  Future<void> _onReset(
    Reset event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 Reset 事件');
    emit(const CounterUpdated(value: 0));
  }

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

  Future<void> _onAsyncIncrement(
    AsyncIncrement event,
    Emitter<CounterState> emit,
  ) async {
    debugPrint('处理 AsyncIncrement 事件');
    emit(CounterLoading(value: state.value));
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(CounterUpdated(value: state.value + 5));
    } catch (error) {
      emit(CounterError(
        value: state.value,
        error: error.toString(),
      ));
    }
  }

  void incrementBy(int amount) {
    add(SetValue(state.value + amount));
  }

  void performBatchOperations() {
    add(const Increment());
    add(const Increment());
    add(const AsyncIncrement());
  }

  void conditionalIncrement(bool condition) {
    if (condition) {
      add(const Increment());
    }
  }

  @override
  Future<void> close() {
    debugPrint('CounterBloc 正在关闭');
    return super.close();
  }

  @override
  void onEvent(CounterEvent event) {
    debugPrint('事件监听: ${event.runtimeType}');
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<CounterEvent, CounterState> transition) {
    debugPrint('状态转换: ${transition.currentState} -> ${transition.nextState} via ${transition.event}');
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    debugPrint('BLoC 错误: $error');
    debugPrint('堆栈跟踪: $stackTrace');
    super.onError(error, stackTrace);
  }
}

// 高级BLoC示例 - 展示更多BLoC方法
class AdvancedCounterBloc extends Bloc<CounterEvent, CounterState> {
  int _operationCount = 0;

  AdvancedCounterBloc() : super(const CounterInitial()) {
    on<Increment>(
      _onIncrement,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<Decrement>(_onDecrement);
  }

  // 添加初始化方法，用于手动触发初始事件
  void initialize() {
    add(const Increment());
    add(const Increment());
  }

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

  int get operationCount => _operationCount;

  // startPeriodicIncrement 方法有问题，已注释
  /*
  Future<void> startPeriodicIncrement() {
    return emit.forEach<CounterEvent>(
      Stream.periodic(const Duration(seconds: 1), (_) => const Increment()),
      onData: (_) => CounterUpdated(value: state.value + 1),
    );
  }
  */

  @override
  Stream<CounterState> get stream => super.stream.map((state) {
    debugPrint('流状态: $state');
    return state;
  });

  void simulateError() {
    addError('模拟错误', StackTrace.current);
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}
