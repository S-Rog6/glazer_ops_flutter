import 'package:flutter/material.dart';

class JobInfoTab extends StatelessWidget {
  final Map<String, String> jobInfo;

  const JobInfoTab({
    super.key,
    required this.jobInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: jobInfo.entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    entry.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
