import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    late W3MService _w3mService;

    void _initializeService() async {
      final _w3mService = W3MService(
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

    @override
    void initState() {
      super.initState();
      _initializeService();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web3 Wallet'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Web3 Wallet',
            ),
          ],
        ),
      ),
    );
  }
}
