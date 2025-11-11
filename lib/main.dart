import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC 方法示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC 方法完整示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态显示区域
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '当前状态',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 使用 BlocBuilder 监听状态变化
                      BlocBuilder<CounterBloc, CounterState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Text(
                                '计数: ${state.value}',
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '状态: ${state.status}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _getStatusColor(state),
                                ),
                              ),
                              if (state is CounterError) ...[
                                const SizedBox(height: 10),
                                Text(
                                  '错误: ${state.error}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 基础操作区域
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '基础操作',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(Increment());
                              },
                              child: const Text('增加 (+1)'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(Decrement());
                              },
                              child: const Text('减少 (-1)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(Reset());
                              },
                              child: const Text('重置'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(AsyncIncrement());
                              },
                              child: const Text('异步增加 (+5)'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 高级操作区域
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '高级操作',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _showSetValueDialog(context);
                        },
                        child: const Text('设置特定值'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CounterBloc>().incrementBy(10);
                        },
                        child: const Text('增加10 (自定义方法)'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CounterBloc>().performBatchOperations();
                        },
                        child: const Text('批量操作'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CounterBloc>().conditionalIncrement(true);
                        },
                        child: const Text('条件增加'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // BLoC 监听示例
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'BLoC 监听示例',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 使用 BlocListener 监听状态变化
                      Expanded(
                        child: BlocListener<CounterBloc, CounterState>(
                          listener: (context, state) {
                            if (state is CounterError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (state is CounterLoading) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('正在处理异步操作...'),
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
                          },
                          child: const Center(
                            child: Text(
                              '监听器已激活\n错误和加载状态会显示提示',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(CounterState state) {
    switch (state.runtimeType) {
      case CounterInitial:
        return Colors.grey;
      case CounterLoading:
        return Colors.orange;
      case CounterUpdated:
        return Colors.green;
      case CounterError:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Future<void> _showSetValueDialog(BuildContext context) async {
    final controller = TextEditingController();
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置计数值'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '输入值',
            hintText: '请输入一个非负整数',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (value != null) {
      context.read<CounterBloc>().add(SetValue(value));
    }
  }
}

// 高级示例页面
class AdvancedCounterPage extends StatelessWidget {
  const AdvancedCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvancedCounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('高级 BLoC 示例'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 使用 BlocSelector 选择特定状态
              BlocSelector<AdvancedCounterBloc, CounterState, int>(
                selector: (state) => state.value,
                builder: (context, value) {
                  return Text(
                    '计数: $value',
                    style: const TextStyle(fontSize: 48),
                  );
                },
              ),
              const SizedBox(height: 20),
              // 使用 BlocConsumer 同时监听和构建
              BlocConsumer<AdvancedCounterBloc, CounterState>(
                listener: (context, state) {
                  if (state is CounterUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('操作次数: ${context.read<AdvancedCounterBloc>().operationCount}')),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdvancedCounterBloc>().add(Increment());
                        },
                        child: const Text('增加 (防抖)'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdvancedCounterBloc>().simulateError();
                        },
                        child: const Text('模拟错误'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}