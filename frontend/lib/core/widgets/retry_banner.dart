import 'package:flutter/material.dart';
import '../api/api_client.dart';

class RetryBanner extends StatelessWidget {
  final Widget child;
  const RetryBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<RetryStatus?>(
          valueListenable: ApiClient.instance.retryStatus,
          builder: (context, status, _) {
            if (status == null) return const SizedBox.shrink();
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: const Color(0xFFFFF4CC),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Waking up the server, this can take up to a minute... '
                            '(attempt ${status.attempt + 1} of ${status.maxAttempts})',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}