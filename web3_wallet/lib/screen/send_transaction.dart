import 'package:flutter/material.dart';
import 'package:web3_wallet/widgets/customButton.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SendTransactions extends StatefulWidget {
  const SendTransactions(
      {super.key, required this.w3mService, required this.publicAddress});
  final W3MService w3mService;
  final String publicAddress;
  @override
  State<SendTransactions> createState() => _SendTransactionsState();
}

class _SendTransactionsState extends State<SendTransactions> {
  String _transactionResult = '';
  late TextEditingController _fromController;
  late TextEditingController _toController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.publicAddress);
    _toController = TextEditingController(
        text: '0xe36D57157c1F67ECA7f274843c9B4Bd04Ffd1c34');
    _amountController = TextEditingController(text: '0x01');
  }

  void _sendTransaction() async {
    try {
      await widget.w3mService.launchConnectedWallet();

      var topic = widget.w3mService.session?.topic;
      if (topic != null) {
        var result = await widget.w3mService.web3App!.request(
          topic: topic,
          chainId: 'eip155:11155111', // Use the correct chain ID
          request: SessionRequestParams(
            method: 'eth_sendTransaction',
            params: [
              {
                'from': _fromController.text,
                'to': _toController.text,
                'value': _amountController.text,
              }
            ],
          ),
        );
        setState(() {
          _transactionResult = 'Transaction Sent: $result';
        });
      }
    } catch (e) {
      setState(() {
        _transactionResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Send Transaction',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 17, bottom: 2),
              alignment: Alignment.topLeft,
              child: const Text(
                'From:',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _fromController,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                  Radius.circular(22),
                ))),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 2),
              alignment: Alignment.topLeft,
              child: const Text(
                'To:',
                style: TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _toController,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                  Radius.circular(22),
                ))),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 15, bottom: 2),
              alignment: Alignment.topLeft,
              child: const Text(
                'Amount:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _amountController,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(22),
                  )),
                ),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(text: "Send Transaction", onTap: _sendTransaction),
            const SizedBox(height: 20),
            if (_transactionResult != '')
              Text(
                'Send Transaction: $_transactionResult',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
