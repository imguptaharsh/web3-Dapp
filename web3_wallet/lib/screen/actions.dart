import 'package:flutter/material.dart';
import 'package:web3_wallet/screen/send_transaction.dart';
import 'package:web3_wallet/screen/sign_message.dart';
import 'package:web3_wallet/widgets/customButton.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  String _publicAddress = '';
  @override
  void initState() {
    super.initState();
    _publicAddressHandler();
  }

  void _publicAddressHandler() async {
    final session = widget.w3mService.session!;
    var eip155Namespace = session.sessionData?.namespaces['eip155'];
    String walletAddress = eip155Namespace!.accounts.first;
    var addressParts = walletAddress.split(':');
    if (addressParts.length > 2) {
      String extractedAddress = addressParts[2];
      // print(
      //     extractedAddress);
      _publicAddress = extractedAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Dapp Actions',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your public address is:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Text(
                _publicAddress == '' ? 'please connect wallet' : _publicAddress,
                style: TextStyle(
                    fontSize: 15,
                    color: _publicAddress == ''
                        ? Colors.red
                        : const Color.fromARGB(255, 117, 229, 121)),
              ),
            ),
            const SizedBox(height: 250),
            CustomButton(
              text: 'Sign Message',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignMessage(
                          w3mService: widget.w3mService,
                          publicAddress: _publicAddress)),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Send Transactions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendTransactions(
                          w3mService: widget.w3mService,
                          publicAddress: _publicAddress)),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: const Color.fromARGB(255, 110, 221, 114),
                  border: Border.all(
                    color: const Color.fromARGB(255, 110, 221, 114),
                  ),
                ),
                child: W3MNetworkSelectButton(service: widget.w3mService)),
          ],
        ),
      ),
    );
  }
}
