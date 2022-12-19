# Project: Tailor / User Application

## 1. 디렉토리 구성
- assets/ 디렉토리에 있는 파일들은 이미지, 서버 공개키파일입니다.
- lib/ 디렉토리 안에 있는 파일들이 실제로 작성한 코드들이며, 그 이외의 코드들은 Flutter project를 생성할 때 자동으로 생성되거나, 라이브러리 파일입니다.

## 2. 코드 파일
### 1. boxwidgets.dart

홈화면 (로그인, 비로그인 포함)에 사용하는 버튼들을 만들어둔 파일입니다. 홈화면에서 이 파일에 있는 widget을 import하여 사용합니다.
### 2. crypto_service.dart
암호화에 사용하는 클래스입니다. 암호화를 하기 위한 다양한 메소드들과 변수들이 정의되어 있으며, 주로 server_encrypt와 my_decrypt를 사용하게 됩니다. (서버의 공개키로 암호화, 나의 개인키로 복호화) 처음 실행하면 반드시 initialize 메소드를 호출해야합니다.

### 3. favoriteplace.dart
사용자가 장소 즐겨찾기를 눌렀을 떄 나오는 화면을 구현한 파일입니다.

### 4. googlemap.dart
사용자가 장소를 추가할 때, 구글맵으로 찾기를 누를 경우 나오는 화면을 구현한 파일입니다.

### 5. intentHandler.dart
사용자가 타 어플리케이션에서 공유버튼을 눌렀을 때 이를 처리하기 위한 파일입니다.

### 6. landingpage.dart
사용자가 처음 어플을 실행할 때, 로그인할 때, 로그아웃할 때 보여지게 되는 랜딩페이지입니다. 

### 7. locations_service.dart
구글의 place_API를 이용하기 위하여 구현해놓은 class와 method입니다.

### 8. login.dart
로그인 화면을 구현한 파일입니다.


### 9. logout.dart
로그아웃 화면을 구현한 파일입니다.

### 10. main.dart
main함수가 있는 파일입니다. 이곳에서 intentHandler를 실행시키고 App을 실행합니다. 실행된 App은 랜딩페이지를 불러오게 됩니다.

### 11. mainpage.dart
메인 페이지입니다. 4개의 메뉴가 보여지게 됩니다.

### 12. mainpage_guest.dart
로그인을 하지 않게 되면 이 메인 페이지로 들어오게 됩니다.

### 13. mqttConnection.dart
서버와의 통신을 하기 위한 클래스가 정의되어 있습니다. 대부분의 변수가 static으로 선언되어 있어서, 모든 파일에서 각자 인스턴스를 생성하여도 동일한 통신 클래스를 사용하게 됩니다. 서버에서 메시지를 받는 것과 보내는 것 모두 이 클래스를 통해 이루어지게 됩니다.

### 14. playlist.dart
플레이리스트 추가, 제거, 관리를 위한 페이지입니다.

### 15. registarPlaylist.dart / registarUser / registarface / registarplace.dart
유저가 플레이리스트 추가 , 회원가입, 얼굴 등록, 장소 등록을 할 때 사용하는 페이지입니다.

### 16. registarplace_intent.dart
유저가 구글맵 어플리케이션을 통해 장소를 공유하려고 할 때 사용되는 페이지입니다.

### 17. temp.dart
테스트를 위한 임시페이지 입니다.
