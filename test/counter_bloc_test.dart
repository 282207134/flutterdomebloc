import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_methods_sample/counter_bloc.dart';

void main() {
  group('CounterBloc', () {
    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = CounterBloc();
    });

    tearDown(() {
      counterBloc.close();
    });

    test('初始状态应该是 CounterInitial', () {
      expect(counterBloc.state, const CounterInitial());
    });

    blocTest<CounterBloc, CounterState>(
      '添加 Increment 事件应该增加计数',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(const Increment()),
      expect: () => [const CounterUpdated(value: 1)],
    );

    blocTest<CounterBloc, CounterState>(
      '添加 Decrement 事件应该减少计数',
      build: () => CounterBloc(),
      seed: () => const CounterUpdated(value: 5),
      act: (bloc) => bloc.add(const Decrement()),
      expect: () => [const CounterUpdated(value: 4)],
    );

    blocTest<CounterBloc, CounterState>(
      '当计数为0时添加 Decrement 事件应该产生错误',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(const Decrement()),
      expect: () => [
        const CounterError(value: 0, error: '计数器不能小于0'),
      ],
    );

    blocTest<CounterBloc, CounterState>(
      '添加 Reset 事件应该重置计数为0',
      build: () => CounterBloc(),
      seed: () => const CounterUpdated(value: 10),
      act: (bloc) => bloc.add(const Reset()),
      expect: () => [const CounterUpdated(value: 0)],
    );

    blocTest<CounterBloc, CounterState>(
      '添加 SetValue 事件应该设置特定值',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(const SetValue(42)),
      expect: () => [const CounterUpdated(value: 42)],
    );

    blocTest<CounterBloc, CounterState>(
      '添加负数的 SetValue 事件应该产生错误',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(const SetValue(-5)),
      expect: () => [
        const CounterError(value: 0, error: '设置的值不能为负数'),
      ],
    );

    blocTest<CounterBloc, CounterState>(
      '添加 AsyncIncrement 事件应该异步增加计数',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(const AsyncIncrement()),
      expect: () => [
        const CounterLoading(value: 0),
        const CounterUpdated(value: 5),
      ],
    );

    blocTest<CounterBloc, CounterState>(
      'incrementBy 方法应该增加指定数量',
      build: () => CounterBloc(),
      act: (bloc) => bloc.incrementBy(10),
      expect: () => [const CounterUpdated(value: 10)],
    );

    blocTest<CounterBloc, CounterState>(
      'performBatchOperations 应该执行批量操作',
      build: () => CounterBloc(),
      act: (bloc) => bloc.performBatchOperations(),
      expect: () => [
        const CounterUpdated(value: 1),
        const CounterUpdated(value: 2),
        const CounterLoading(value: 2),
        const CounterUpdated(value: 7),
      ],
    );

    blocTest<CounterBloc, CounterState>(
      'conditionalIncrement 当条件为true时应该增加',
      build: () => CounterBloc(),
      act: (bloc) => bloc.conditionalIncrement(true),
      expect: () => [const CounterUpdated(value: 1)],
    );

    blocTest<CounterBloc, CounterState>(
      'conditionalIncrement 当条件为false时不应该增加',
      build: () => CounterBloc(),
      act: (bloc) => bloc.conditionalIncrement(false),
      expect: () => [],
    );
  });

  group('AdvancedCounterBloc', () {
    late AdvancedCounterBloc advancedBloc;

    setUp(() {
      advancedBloc = AdvancedCounterBloc();
    });

    tearDown(() {
      advancedBloc.close();
    });

    test('初始状态应该是增加后的状态', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      expect(advancedBloc.state.value, 2);
    });

    test('operationCount 应该跟踪操作次数', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      expect(advancedBloc.operationCount, 2);
    });

    blocTest<AdvancedCounterBloc, CounterState>(
      '防抖的 Increment 应该工作',
      build: () => AdvancedCounterBloc(),
      act: (bloc) => bloc.add(const Increment()),
      wait: const Duration(milliseconds: 400),
      skip: 2,
      expect: () => [const CounterUpdated(value: 3)],
    );

    test('simulateError 应该添加错误', () {
      expect(
        () => advancedBloc.simulateError(),
        returnsNormally,
      );
    });
  });

  group('CounterState', () {
    test('CounterInitial 应该有正确的 props', () {
      const state1 = CounterInitial();
      const state2 = CounterInitial();
      expect(state1, equals(state2));
    });

    test('CounterUpdated 应该有正确的 props', () {
      const state1 = CounterUpdated(value: 5);
      const state2 = CounterUpdated(value: 5);
      const state3 = CounterUpdated(value: 10);
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('CounterError 应该有正确的 props', () {
      const state1 = CounterError(value: 0, error: '错误');
      const state2 = CounterError(value: 0, error: '错误');
      const state3 = CounterError(value: 0, error: '其他错误');
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('CounterEvent', () {
    test('Increment 应该有正确的 props', () {
      const event1 = Increment();
      const event2 = Increment();
      expect(event1, equals(event2));
    });

    test('SetValue 应该有正确的 props', () {
      const event1 = SetValue(5);
      const event2 = SetValue(5);
      const event3 = SetValue(10);
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });
  });
}
