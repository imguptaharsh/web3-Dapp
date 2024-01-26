import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:web3_wallet/screen/action.dart';
import 'package:web3_wallet/screen/actions.dart';
import 'package:web3_wallet/widgets/customButton.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late W3MService _w3mService;
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

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _clearSession() {
    setState(() {
      // Disconnect the wallet
      _w3mService.disconnect();
      // Reset variables
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'Dapp',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/wallet.svg',
              height: 150,
            ),
            const SizedBox(height: 50),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
                color: const Color.fromARGB(255, 110, 221, 114),
                border: Border.all(
                  color: Colors.green,
                  // width: 4,
                ),
              ),
              child: W3MConnectWalletButton(
                service: _w3mService,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
                text: 'Clear Session',
                color: Colors.red,
                fontSize: 15,
                onTap: _clearSession),
            const SizedBox(height: 20),
            CustomButton(
                text: 'Actions',
                fontSize: 16,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActionsPage(
                              w3mService: _w3mService,
                            )),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
