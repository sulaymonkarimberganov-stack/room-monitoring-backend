import 'package:flutter/material.dart';
import 'widgets.dart';

/// Bu fayl widgetlarni qanday ishlatishni ko'rsatadi
/// 
/// ISHLATISH MISOLLARI:

// ═══════════════════════════════════════════════════════════════════════════
// 1. LOADING WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class LoadingExample extends StatelessWidget {
  const LoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomLoadingWidget(
        message: 'Ma\'lumotlar yuklanmoqda...',
      ),
    );
  }
}

// Kichik loading (button ichida)
class ButtonLoadingExample extends StatelessWidget {
  const ButtonLoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmallLoadingIndicator(),
          SizedBox(width: 8),
          Text('Yuklanmoqda...'),
        ],
      ),
    );
  }
}

// Loading overlay (butun ekranni qoplash)
class OverlayLoadingExample extends StatefulWidget {
  const OverlayLoadingExample({super.key});

  @override
  State<OverlayLoadingExample> createState() => _OverlayLoadingExampleState();
}

class _OverlayLoadingExampleState extends State<OverlayLoadingExample> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: 'Saqlanmoqda...',
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              Future.delayed(const Duration(seconds: 2), () {
                setState(() => _isLoading = false);
              });
            },
            child: const Text('Saqlash'),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 2. ERROR WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class ErrorExample extends StatelessWidget {
  const ErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomErrorWidget(
        title: 'Xatolik yuz berdi',
        message: 'Ma\'lumotlarni yuklashda xatolik yuz berdi.',
        onRetry: () {
          // Qayta yuklash logikasi
          print('Qayta yuklash...');
        },
      ),
    );
  }
}

// Network error
class NetworkErrorExample extends StatelessWidget {
  const NetworkErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NetworkErrorWidget(
        onRetry: () {
          print('Internet tekshirilmoqda...');
        },
      ),
    );
  }
}

// Server error
class ServerErrorExample extends StatelessWidget {
  const ServerErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ServerErrorWidget(
        errorMessage: '500 Internal Server Error',
        onRetry: () {
          print('Qayta ulanmoqda...');
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 3. EMPTY STATE WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class EmptyRoomsExample extends StatelessWidget {
  const EmptyRoomsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyRoomsWidget(
        onAddRoom: () {
          print('Xona qo\'shish...');
        },
      ),
    );
  }
}

class EmptyTasksExample extends StatelessWidget {
  const EmptyTasksExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptyTasksWidget(),
    );
  }
}

class EmptySearchExample extends StatelessWidget {
  const EmptySearchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptySearchWidget(
        searchQuery: 'test',
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 4. SNACKBAR
// ═══════════════════════════════════════════════════════════════════════════

class SnackBarExample extends StatelessWidget {
  const SnackBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                CustomSnackBar.showSuccess(
                  context,
                  'Muvaffaqiyatli saqlandi!',
                );
              },
              child: const Text('Success SnackBar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                CustomSnackBar.showError(
                  context,
                  'Xatolik yuz berdi!',
                  onRetry: () {
                    print('Qayta urinish...');
                  },
                );
              },
              child: const Text('Error SnackBar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                CustomSnackBar.showWarning(
                  context,
                  'Diqqat! Bu muhim xabar.',
                );
              },
              child: const Text('Warning SnackBar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                CustomSnackBar.showInfo(
                  context,
                  'Ma\'lumot: Yangilanish mavjud.',
                );
              },
              child: const Text('Info SnackBar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 5. REAL WORLD EXAMPLE - API CALL WITH STATES
// ═══════════════════════════════════════════════════════════════════════════

enum LoadingState { idle, loading, success, error, empty }

class RealWorldExample extends StatefulWidget {
  const RealWorldExample({super.key});

  @override
  State<RealWorldExample> createState() => _RealWorldExampleState();
}

class _RealWorldExampleState extends State<RealWorldExample> {
  LoadingState _state = LoadingState.idle;
  List<String> _data = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = LoadingState.loading);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate different scenarios:
      // 1. Success with data
      // _data = ['Item 1', 'Item 2', 'Item 3'];
      // _state = LoadingState.success;
      
      // 2. Success but empty
      _data = [];
      _state = LoadingState.empty;
      
      // 3. Error
      // throw Exception('Server error');
      
      setState(() {});
    } catch (e) {
      setState(() {
        _state = LoadingState.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real World Example'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadingState.idle:
      case LoadingState.loading:
        return const CustomLoadingWidget(
          message: 'Ma\'lumotlar yuklanmoqda...',
        );

      case LoadingState.error:
        return CustomErrorWidget(
          message: _errorMessage,
          onRetry: _loadData,
        );

      case LoadingState.empty:
        return EmptyTasksWidget(
          onAddTask: () {
            CustomSnackBar.showInfo(context, 'Vazifa qo\'shish oynasi ochiladi');
          },
        );

      case LoadingState.success:
        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_data[index]),
              );
            },
          ),
        );
    }
  }
}
