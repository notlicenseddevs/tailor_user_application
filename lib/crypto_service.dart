import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'dart:math';
import 'dart:convert';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:flutter/services.dart';

class cryptoService {
  static late bool _isMaked = false;
  static late FortunaRandom _seed;
  static late final RSAPublicKey _my_publicKey;
  static late final RSAPrivateKey _my_privateKey;
  static late final RSAPublicKey _server_publicKey;
  static late final Encrypter _my_encrypter;
  static late final Encrypter _server_encrypter;
  static late final String _my_publicKey_PEM;
  static late final _p;

  Future<void> initialize() async {
    if(!_isMaked) {
      _p = AsymmetricBlockCipher('RSA/OAEP');
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
  Uint8List server_encrypt(String input) {
    // final utf8Input = utf8.encode(input);
    // final base64Input = base64Encode(utf8Input);
    // final Uint8ListInput = base64Decode(base64Input);
    // final output = _rsaEncrypt(_my_publicKey, Uint8ListInput);
    // final base64Output = base64.encode(output);
    // utf8.encoder()
    // final Uint8ListOutput = base64.decode(base64Output);
    // final utf8Output = utf8.decode(output);
    // return utf8Output;
    List<int> list = utf8.encode(input);
    Uint8List bytes = Uint8List.fromList(list);
    Uint8List encrypted = _rsaEncrypt(_server_publicKey, bytes);
    //String outcome = utf8.decode(bytes);
    return encrypted;
  }
  Uint8List my_encrypt(String input) {
    List<int> list = utf8.encode(input);
    Uint8List bytes = Uint8List.fromList(list);
    Uint8List encrypted = _rsaEncrypt(_my_publicKey, bytes);
    return encrypted;
  }
  String my_decrypt(Uint8List input) {
    Uint8List decrypted = _rsaDecrypt(_my_privateKey, input);
    String outcome = utf8.decode(decrypted);
    return outcome;
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

  Uint8List _rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding.withSHA256(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List _rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding.withSHA256(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);
    print('numBlocks : $numBlocks');
    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }
  Future<void> _saveServerPublicKey() async {
    const path = 'public_key.pem';
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    _server_publicKey = await parseKeyFromFile<RSAPublicKey>(file.path);
    print('file reading complete');
    return;
  }
}