// file: screens/reward_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/reward.dart';

class RewardDetailScreen extends StatelessWidget {
  final Reward reward;

  const RewardDetailScreen({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Phần Thưởng'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              reward.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.card_giftcard, size: 100, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32.0),
                  // CẬP NHẬT: Hiển thị nội dung chi tiết (content) thay vì mô tả (description)
                  Text(
                    'Điều khoản và Điều kiện:', // Thêm tiêu đề cho phần nội dung
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    reward.content, // Sử dụng trường content mới
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                  const Divider(height: 32.0),
                  _buildInfoRow(
                    context,
                    icon: Icons.monetization_on,
                    color: Colors.orange,
                    label: 'Giá đổi',
                    value: '${reward.cost} Xu',
                  ),
                  const SizedBox(height: 12.0),
                  _buildInfoRow(
                    context,
                    icon: Icons.inventory_2,
                    color: Colors.green,
                    label: 'Số lượng còn lại',
                    value: reward.quantity > 0 ? reward.quantity.toString() : 'Hết hàng',
                  ),
                  const SizedBox(height: 12.0),
                  _buildInfoRow(
                    context,
                    icon: Icons.repeat_one,
                    color: Colors.purple,
                    label: 'Giới hạn đổi của bạn',
                    value: '${reward.timesRedeemedByUser}/${reward.redemptionLimit}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required Color color, required String label, required String value}) {
    // ... (Giữ nguyên widget phụ này)
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16.0),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}