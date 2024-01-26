import 'package:flutter/material.dart';
import 'package:web3_wallet/screen/action.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late W3MService _w3mService;
  String _signMessageResult = '';
  String _transactionResult = '';
  String _publicAddress = '';
  bool _isWalletConnected = false;
  // Timer? _sessionCheckTimer
  void _initializeService() async {
    _w3mService = W3MService(
      projectId: '91fea5ea39fc5898af040c6fd6c478c2',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();
  }

  void _checkWalletConnection() {
    setState(() {
      _isWalletConnected = _w3mService.isConnected;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeService();
    _checkWalletConnection();
    if (_w3mService.status.isInitialized) {
      tempHandler();
    } else {
      // R
    }
  }

  void _signMessage() async {
    try {
      var topic = _w3mService.session?.topic;
      if (topic != null) {
        var result = await _w3mService.web3App!.request(
          topic: topic,
          chainId: 'eip155:11155111', // Sepolia network chain ID
          request: const SessionRequestParams(
            method: 'personal_sign',
            params: ['Sign this message', '0xdeadbeef'],
          ),
        );
        setState(() {
          _signMessageResult = 'Message Signed: $result';
        });
      }
    } catch (e) {
      setState(() {
        _signMessageResult = 'Error: $e';
      });
    }
  }

  void _sendTransaction() async {
    try {
      var topic = _w3mService.session?.topic;
      if (topic != null) {
        var result = await _w3mService.web3App!.request(
          topic: topic,
          chainId: 'eip155:11155111', // Sepolia network chain ID
          request: const SessionRequestParams(
            method: 'eth_sendTransaction',
            params: [
              {
                'from': 'YOUR_METAMASK_CONNECTED_ACCOUNT',
                'to': '0xe36D57157c1F67ECA7f274843c9B4Bd04Ffd1c34',
                'data': '0x',
                'value': '0x01',
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

  void tempHandler() async {
    final session = _w3mService.session!;
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
            W3MConnectWalletButton(service: _w3mService),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActionsPage(
                            w3mService: _w3mService,
                          )),
                );
              },
              child: const Text('Action'),
            ),
            // if(_w3mService.session != null){
            //   setState((){})
            // }
            Visibility(
              // visible: !_w3mService.,
              child: Text(_publicAddress),
            ),
            ElevatedButton(
              onPressed: _signMessage,
              child: const Text('Sign Message'),
            ),
            Text(_signMessageResult),
            if (_isWalletConnected)
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
