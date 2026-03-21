import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String jobName;
  final String poNumber;
  final String siteName;
  final String address1;
  final String address2;
  final String contacts;

  const JobCard({
    super.key,
    required this.jobName,
    required this.poNumber,
    required this.siteName,
    required this.address1,
    required this.address2,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(poNumber),
                  const SizedBox(height: 6),
                  Text("Contacts: $contacts"),
                ],
              ),
            ),

            // RIGHT SIDE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  siteName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (address1.isNotEmpty) Text(address1),
                if (address2.isNotEmpty) Text(address2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}