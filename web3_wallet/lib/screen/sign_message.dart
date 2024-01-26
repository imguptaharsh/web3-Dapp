import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web3_wallet/widgets/customButton.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SignMessage extends StatefulWidget {
  const SignMessage(
      {super.key, required this.w3mService, required this.publicAddress});
  final W3MService w3mService;
  final String publicAddress;

  @override
  State<SignMessage> createState() => _SignMessageState();
}

class _SignMessageState extends State<SignMessage> {
  String _signMessageResult = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: """{"domain"("chainld":"0x1","name": "Ether
Mail"," verifyingContract":"OCcCCCCCCCCCCcCCC
ssage":("contents": "Hello, Busa!"," from":
{"name": "Kinno"," wallets":
["OxCD2a3d9F938E13CD947Ec05AbC7FE734Df8D
D826","0xDeaDbeefdEAdbeefdEadbEEFdeadbeEF
dEaDbeeF"]},"to":K"name": "Busa"," wallets":
["OxbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBb
bBBbB","0xB0BdaBea57B0BDABeA57b0bdABEA5
7b0BDabEa57","0xB0B0b0b0b0b0B000000000000
000000000000000"1)."primary Type":"Mail","types"
:"EIP712Domain":["name":"name","type":"string"),
{"name": "version","type": "string"),
{"name": "chainld","type": "uint256"),
{"name": "verifyingContract","type": "address")],"Gro
up":[("name": "name","type": "string"),
{"name":"members","type" :"Person!"}],"Mail":
["name": "from","type": "Person"),
("name":"to","type": "Person!"),
{"name":"contents","type": "string" ],"Person":
["name": "name","type":"string"),
{"name":""");
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
              // 'Message you want to sign', // The message to sign
              _controller.text,
              widget.publicAddress // The address from which you are signing
            ],
          ),
        );

        // Handle the signed message result
        setState(() {
          _signMessageResult = '$result';
        });
      }
    } catch (e) {
      // Handle errors
      setState(() {
        _signMessageResult = 'Error: $e';
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
          'Sign Message',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                maxLines: 15,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                  Radius.circular(26),
                ))),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(text: "Sign Message", onTap: _signMessage),
            const SizedBox(height: 20),
            if (_signMessageResult != '')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Message Signed!',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      'assets/done.svg',
                      height: 30,
                    ),
                  ],
                ),
              ),
            if (_signMessageResult != '')
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  _signMessageResult,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
