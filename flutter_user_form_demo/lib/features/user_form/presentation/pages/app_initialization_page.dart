import 'package:flutter/material.dart';
import 'dart:io';

class AppInitializationPage extends StatelessWidget {
  final String message;
  final bool isLoading;
  final String? error;
  final bool canRetry;

  const AppInitializationPage({
    super.key,
    required this.message,
    required this.isLoading,
    this.error,
    this.canRetry = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusIcon(),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (isLoading) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Por favor espera...',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
              ],
              if (error != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles del error:',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error!,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (canRetry) ...[
                ElevatedButton(
                  onPressed: () => _restartApp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Reintentar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isLoading) {
      return const Icon(
        Icons.hourglass_empty,
        color: Colors.white,
        size: 80,
      );
    }

    if (error != null) {
      return const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 80,
      );
    }

    return const Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 80,
    );
  }

  void _restartApp() {
    // Restart the entire app by exiting
    // Note: This is a simple approach. In production, you might want to use
    // a more sophisticated restart mechanism
    exit(0);
  }
}
