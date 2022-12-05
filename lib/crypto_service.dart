import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/api.dart' as symm_crypto;
import 'package:pointycastle/asymmetric/api.dart' as asymm_crypto;
import 'package:async/async.dart';

class cryptoService {
  static late symm_crypto.AsymmetricKeyPair _myKeyPair;
  static bool _isMaked = false;
  static late final asymm_crypto.RSAPublicKey publicKey;
  static late final asymm_crypto.RSAPrivateKey _privateKey;

  late final Encrypter _encrypter;

  Future<void> initialize() async {
    if(!_isMaked) {
      var helper = RsaKeyHelper();
      _myKeyPair = await helper.computeRSAKeyPair(helper.getSecureRandom());
      publicKey = _myKeyPair.publicKey as asymm_crypto.RSAPublicKey;
      _privateKey =  _myKeyPair.privateKey as asymm_crypto.RSAPrivateKey;
      _encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: _privateKey));
      _isMaked = true;
    }
    return;
  }
  bool isMaked() {
    return _isMaked;
  }
  Encrypted encrypt(String input) {
    return _encrypter.encrypt(input);
  }
  String decrypt(Encrypted input) {
    return _encrypter.decrypt(input);
  }
}