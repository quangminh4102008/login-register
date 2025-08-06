import 'package:flutter/material.dart';
import '../models/reward.dart';
import './reward_detail_screen.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  // 50 xu mẫu của bạn vẫn ở đây
  int _userCoins = 50;

  final List<Reward> _rewards = [
    Reward(
      id: 'R1',
      name: 'Voucher Giảm 20% Highlands Coffee',
      description: 'Áp dụng cho tất cả các sản phẩm nước uống.',
      content: 'Điều kiện áp dụng:\n- Áp dụng cho tất cả các sản phẩm nước uống tại hệ thống Highlands Coffee trên toàn quốc.\n- Voucher không có giá trị quy đổi thành tiền mặt.\n- Mỗi hóa đơn chỉ được áp dụng 1 voucher.\n- Hạn sử dụng: 30/09/2025.',
      imageUrl: 'assets/images/hightland.png',
      cost: 5,
      quantity: 15,
      redemptionLimit: 1,
      timesRedeemedByUser: 0,
    ),
    Reward(
      id: 'R2',
      name: 'Miễn Phí 1 Suất Bắp Rang Bơ CGV',
      description: 'Nhận ngay 1 phần bắp rang bơ miễn phí.',
      content: 'Nhận ngay 1 phần bắp rang bơ vị mặn (lớn) miễn phí khi mua vé xem phim 2D tại tất cả các cụm rạp CGV Cinemas. Vui lòng xuất trình mã voucher này tại quầy bắp nước để nhận ưu đãi.',
      imageUrl: 'assets/images/cgv.png',
      cost: 3,
      quantity: 5,
      redemptionLimit: 2,
      timesRedeemedByUser: 1,
    ),
    Reward(
      id: 'R3',
      name: 'Thẻ Quà Tặng 100.000đ Tiki',
      description: 'Sử dụng để mua sắm trên sàn Tiki.',
      content: 'Sử dụng để mua sắm hàng ngàn sản phẩm trên sàn thương mại điện tử Tiki.vn. Không áp dụng cho các sản phẩm của nhà bán hàng quốc tế hoặc các dịch vụ tiện ích (thẻ cào, vé máy bay...).',
      imageUrl: 'assets/images/tiki.png',
      cost: 4,
      quantity: 10,
      redemptionLimit: 1,
      timesRedeemedByUser: 1,
    ),
  ];

  void _redeemReward(int index) {
    final reward = _rewards[index];
    if (_userCoins < reward.cost ||
        reward.quantity <= 0 ||
        reward.timesRedeemedByUser >= reward.redemptionLimit) {
      return;
    }
    setState(() {
      _userCoins -= reward.cost;
      _rewards[index] = Reward(
        id: reward.id,
        name: reward.name,
        description: reward.description,
        content: reward.content,
        imageUrl: reward.imageUrl,
        cost: reward.cost,
        quantity: reward.quantity - 1,
        redemptionLimit: reward.redemptionLimit,
        timesRedeemedByUser: reward.timesRedeemedByUser + 1,
      );
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đổi Quà Thành Công!'),
        content: Text('Bạn đã đổi thành công "${reward.name}".'),
        actions: <Widget>[
          TextButton(
            child: const Text('Tuyệt vời'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Reward reward) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RewardDetailScreen(reward: reward),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ví Thưởng Của Bạn'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // SỬA LỖI: Khôi phục lại phần hiển thị số xu trên AppBar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              backgroundColor: Colors.white,
              avatar: const Icon(Icons.monetization_on, color: Colors.orange),
              label: Text(
                '$_userCoins Xu',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _rewards.length,
        itemBuilder: (context, index) {
          final reward = _rewards[index];
          final bool isOutOfStock = reward.quantity == 0;
          final bool canAfford = _userCoins >= reward.cost;
          final bool hasReachedLimit =
              reward.timesRedeemedByUser >= reward.redemptionLimit;
          final bool canRedeem = !isOutOfStock && canAfford && !hasReachedLimit;

          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            color: isOutOfStock || hasReachedLimit
                ? Colors.grey.shade200
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          reward.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          color: isOutOfStock || hasReachedLimit
                              ? Colors.black.withOpacity(0.4)
                              : null,
                          colorBlendMode: isOutOfStock || hasReachedLimit
                              ? BlendMode.darken
                              : null,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.card_giftcard,
                                  size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: canRedeem
                                    ? Colors.black
                                    : Colors.grey.shade600,
                                decoration: isOutOfStock || hasReachedLimit
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              reward.description,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Đã đổi: ${reward.timesRedeemedByUser}/${reward.redemptionLimit} | Còn lại: ${reward.quantity}',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: hasReachedLimit || isOutOfStock
                                    ? Colors.red.shade700
                                    : Colors.green.shade800,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        avatar: Icon(Icons.monetization_on,
                            color: canAfford ? Colors.orange : Colors.grey),
                        label: Text('${reward.cost} Xu',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: canAfford
                            ? Colors.orange.shade50
                            : Colors.grey.shade300,
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => _showDetail(context, reward),
                            child: const Text('Chi Tiết'),
                          ),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed:
                            canRedeem ? () => _redeemReward(index) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Đổi'),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}