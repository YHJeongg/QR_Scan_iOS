# QR Code Scan App

>## <I> 기술 </I>
* <img src="https://img.shields.io/badge/Swift5-v5.8.0-9cf?logo=Swift" alt="Swift5" />
* <img src="https://img.shields.io/badge/Cocoapods-v1.12.0-red?logo=Cocoapods" alt="Swift5" />

  - GoogleMLKit BarcodeScanning - v3.2.0
<br/><br/>
----

### BarcodeScanning 설치
* 프로젝트 폴더 이동
```Swift
cd QRScan
pod install
 ```
 Xcode version 12.4 or greater. <br />
 iOS version 15.6 or greater.
 <br/><br/>

>## <I> 기능 </I>
1. 전면, 후면 카메라 전환 기능
2. 사진 촬영 기능 (갤러리에 사진 저장)
3. 카메라에서 QR 코드 스캔 기능

|                   카메라 전환 기능                   |                  사진 촬영                    |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://github.com/YHJeongg/QR_Scan_iOS/assets/97114061/5da95c5d-7dc3-410a-a5d9-da5afd1392ea" alt="카메라 전환" width=100%> | <img src="https://github.com/YHJeongg/QR_Scan_iOS/assets/97114061/e776b550-ac5c-4974-aa1a-1187c963da52" alt="사진 촬영" width=100%> |

|                QR URL                 |                     QR Not URL                      |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://github.com/YHJeongg/QR_Scan_iOS/assets/97114061/c2b15919-3c65-4310-86b1-ca94d4640efb" alt="QR URL" width=95%> | <img src="https://github.com/YHJeongg/QR_Scan_iOS/assets/97114061/77bc46ba-5a38-4a33-9e9d-8abb49480c5f" alt="QR Not URL" width=95%> |

<br />

----
### 프로젝트 구성
- [Camera](https://github.com/YHJeongg/QR_Scan_iOS/tree/main/QRScan/QRScan/Camera)
  - [Camera.swift](https://github.com/YHJeongg/QR_Scan_iOS/blob/main/QRScan/QRScan/Camera/Camera.swift) - 카메라와 관련된 기능을 처리하는 클래스
  - [CameraView.swift](https://github.com/YHJeongg/QR_Scan_iOS/blob/main/QRScan/QRScan/Camera/CameraView.swift) - 카메라 화면을 표시하고 카메라 관련 버튼 및 기능을 제공하는 View
  - [CameraViewModel.swift](https://github.com/YHJeongg/QR_Scan_iOS/blob/main/QRScan/QRScan/Camera/CameraViewModel.swift) - 카메라와 관련된 데이터와 로직을 처리하는 ViewModel 클래스
- [Utils](https://github.com/YHJeongg/QR_Scan_iOS/tree/main/QRScan/QRScan/Utils)
  - [ImagePicker.swift](https://github.com/YHJeongg/QR_Scan_iOS/blob/main/QRScan/QRScan/Utils/ImagePicker.swift) - 이미지 피커, 갤러리 확인용도
  - [QRCodeReader.swift](https://github.com/YHJeongg/QR_Scan_iOS/blob/main/QRScan/QRScan/Utils/QRCodeReader.swift) - MLKit를 사용하여 QR 코드를 스캔하는 기능을 제공하는 클래스