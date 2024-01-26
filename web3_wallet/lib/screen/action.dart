import 'package:flutter/material.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  String _publicAddress = '';
  String _signMessageResult = '';
  String _transactionResult = '';
  @override
  void initState() {
    super.initState();
    tempHandler();
  }

  void tempHandler() async {
    final session = widget.w3mService.session!;
    // if (session.sessionData?.namespaces.containsKey('eip155') ?? false) {
    var eip155Namespace = session.sessionData?.namespaces['eip155'];
    // if (eip155Namespace != null && eip155Namespace.accounts.isNotEmpty) {
    // Assuming you want the first account in the list
    String walletAddress = eip155Namespace!.accounts.first;
    // Extracting the wallet address part from the string
    var addressParts = walletAddress.split(':');
    if (addressParts.length > 2) {
      String extractedAddress = addressParts[2];
      print(
          extractedAddress); // This should print 0xEd8f412c6E4e426B3F467338C93575bD52fbF7A0
      _publicAddress = extractedAddress;
      // }
      // }
    }
  }

  void _signMessage() async {
    try {
      // Launch the connected wallet
      await widget.w3mService.launchConnectedWallet();

      // Check if the session is established
      var topic = widget.w3mService.session?.topic;
      if (topic != null) {
        // Send a sign message request to the wallet
        var result = await widget.w3mService.web3App!.request(
          topic: topic,
          chainId:
              'eip155:11155111', // Ensure this matches the connected network
          request: SessionRequestParams(
            method: 'personal_sign',
            params: [
              'Message you want to sign', // The message to sign
              _publicAddress // The address from which you are signing
            ],
          ),
        );

        // Handle the signed message result
        setState(() {
          _signMessageResult = 'Message Signed: $result';
        });
      }
    } catch (e) {
      // Handle errors
      setState(() {
        _signMessageResult = 'Error: $e';
      });
    }
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
                'from': _publicAddress,
                'to': '0xe36D57157c1F67ECA7f274843c9B4Bd04Ffd1c34',
                'value': '0x01', // Hexadecimal value of the amount to send
                // Include other necessary transaction parameters
              }
            ],
          ),
        );
        // Handle the transaction result here
      }
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web3Modal Flutter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   onPressed: tempHandler,
            //   child: const Text('Get Address'),
            // ),
            Text(_publicAddress),
            ElevatedButton(
              onPressed: _signMessage,
              child: const Text('Sign Message'),
            ),
            Text(_signMessageResult),
            ElevatedButton(
              onPressed: _sendTransaction,
              child: const Text('Send Transaction'),
            ),
            Text(_transactionResult),
          ],
        ),
      ),
    );
  }
}
