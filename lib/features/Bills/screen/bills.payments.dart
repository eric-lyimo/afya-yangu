import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/Bills/models/bills.dart';
import 'package:mtmeru_afya_yangu/features/Bills/models/payments.dart';
import 'package:mtmeru_afya_yangu/features/home/components/afyaAppBar.appbar.dart';

class BillsAndPaymentsScreen extends StatefulWidget {
  const BillsAndPaymentsScreen({super.key});

  @override
  _BillsAndPaymentsScreenState createState() => _BillsAndPaymentsScreenState();
}

class _BillsAndPaymentsScreenState extends State<BillsAndPaymentsScreen> {
  // Mock Data
  final List<Bill> outstandingBills = [
    Bill(serviceName: "Online Consultation", amount: 450.00, dueDate: "Dec 5, 2024"),
    Bill(serviceName: "Lab Tests", amount: 120.00, dueDate: "Nov 28, 2024"),
    Bill(serviceName: "Pharmacy Purchase", amount: 50.00, dueDate: "Nov 20, 2024"),
  ];

  final List<Payment> recentPayments = [
    Payment(serviceName: "Online Consultation", amount: 450.00, date: "Nov 28, 2024"),
    Payment(serviceName: "Lab Tests", amount: 120.00, date: "Nov 20, 2024"),
    Payment(serviceName: "Pharmacy Purchase", amount: 50.00, date: "Nov 15, 2024"),
  ];

  @override
  Widget build(BuildContext context) {
    return AfyaLayout(
      title: "Bills And Payments",
      subtitle: "",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
             _walletSection(),
              const SizedBox(height: 16),
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(icon: Icon(FontAwesomeIcons.moneyBills), text: "Outstanding Bills"),
                  Tab(icon: Icon(FontAwesomeIcons.clockRotateLeft), text: "Recent Transactions"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildBillList(),
                    _buildPaymentList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Outstanding Balance",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Text(
            "Tsh 12,854.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(Icons.send_outlined, "Pay Now"),
              _actionButton(Icons.receipt_long_outlined, "Review"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

Widget _buildBillList() {
  return ListView.builder(
    itemCount: outstandingBills.length,
    itemBuilder: (context, index) {
      final bill = outstandingBills[index];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.medical_services_outlined, color: Colors.blueAccent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due: ${bill.dueDate}",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${bill.amount.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildPaymentList() {
  return ListView.builder(
    itemCount: recentPayments.length,
    itemBuilder: (context, index) {
      final payment = recentPayments[index];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Date: ${payment.date}",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${payment.amount.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
