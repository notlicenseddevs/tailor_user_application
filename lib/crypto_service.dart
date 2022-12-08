import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'dart:math';
import 'dart:convert' as convert;

import 'package:rsa_encrypt/rsa_encrypt.dart';

class cryptoService {
  static late bool _isMaked = false;
  static late FortunaRandom _seed;
  static late final RSAPublicKey _my_publicKey;
  static late final RSAPrivateKey _my_privateKey;
  static late final RSAPublicKey _server_publicKey;
  static late final Encrypter _my_encrypter;
  static late final Encrypter _server_encrypter;
  static late final String _my_publicKey_PEM;

  Future<void> initialize() async {
    if(!_isMaked) {
      _seed = await _getSecureRandomSeed();
      await _generateRSAkeyPair(_seed).then((v) => _my_encrypter = Encrypter(RSA(publicKey: _my_publicKey, privateKey: _my_privateKey)));
      await _saveServerPublicKey().then((v) => _server_encrypter = Encrypter(RSA(publicKey: _server_publicKey)));
      _isMaked = true;
    }
    else {
      print('error : this function can run only one time.');
    }
    return;
  }
  bool isMaked() {
    return _isMaked;
  }
  Encrypted server_encrypt(String input) {
    return _server_encrypter.encrypt(input);
  }
  Encrypted my_encrypt(String input) {
    return _my_encrypter.encrypt(input);
  }
  String my_decrypt(Encrypted input) {
    return _my_encrypter.decrypt(input);
  }
  String getMyPublicKey() {
    return _my_publicKey_PEM;
  }

  Future<FortunaRandom> _getSecureRandomSeed() async {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  Future<void> _generateRSAkeyPair(FortunaRandom secureRandom, {int bitLength = 2048}) async {
    // Create an RSA key generator and initialize it
    final keyGen = KeyGenerator('RSA')
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    // Use the generator
    final pair = keyGen.generateKeyPair();
    RsaKeyHelper helper = RsaKeyHelper();
    // Cast the generated key pair into the RSA key types
    _my_publicKey = pair.publicKey as RSAPublicKey;
    _my_privateKey = pair.privateKey as RSAPrivateKey;
    _my_publicKey_PEM = helper.encodePublicKeyToPemPKCS1(_my_publicKey);
    return;
  }
  Future<void> _saveServerPublicKey() async {
    _server_publicKey = await parseKeyFromFile<RSAPublicKey>('../server_key/public_key.pem');
    return;
  }
}