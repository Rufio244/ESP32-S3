import 'package:http/http.dart' as http;

class DolaSyncService {
  final String deviceIp = "192.168.1.50"; // ไอพีของตัวเครื่อง DLB

  // ฟังก์ชันซื้อภาษาเพิ่ม
  Future<bool> purchaseLanguage(String langCode) async {
    // 1. ส่งคำขอตัดเงิน (Payment Gateway Logic)
    bool success = await processPayment(langCode);
    
    if (success) {
      // 2. ถ้าจ่ายเงินสำเร็จ ส่งคำสั่งให้เครื่องเริ่มดาวน์โหลด
      return await sendUpgradeCommandToDevice(langCode);
    }
    return false;
  }

  // ส่งข้อมูลอัปเกรดไปที่เครื่องผ่าน Wi-Fi
  Future<bool> sendUpgradeCommandToDevice(String langCode) async {
    final response = await http.post(
      Uri.parse('http://$deviceIp/upgrade'),
      body: {'language': langCode, 'token': 'SECURE_AUTH_TOKEN'},
    );
    return response.statusCode == 200;
  }
}
