# Ijjeuminga(이쯤인가) 🚌 👀

> 탑승중인 버스의 현재 경로를 실시간으로 알려주고 목적지 근처부터 사용자에게 알림을 주는 버스도착 알림앱 (공공API 사용)


<br>

# 목차
1. [프로젝트 소개](#프로젝트-소개)
    - [미리보기](#미리보기)
    - [작업요약](#작업요약)
2. 객체 역할 소개
      - 앱 설계
      - View
      - Manager
3. 고민한점

<br><br>

# 프로젝트 소개

> 아래 공공API (서울버스)를 이용해 현재위치 기반의 가까운 정류장을 기준으로 목적지 선택시 목적지 부근부터 미리안내를 해주는 앱

**API**
- [서울_버스위치정보조회_서비스](https://www.data.go.kr/data/15000332/openapi.do)
- [서울_버스운행정보_공유서비스](http://api.bus.go.kr/contents/sub02/getStaionByRoute.html)


<br>

### 👨‍💻 Developers
|조성빈🍎|이병훈🍎|이하연🍎|
|:--:|:--:|:--:|

<br>

## 미리보기
<br>

### 조성빈

<br>

### 이병훈
|목적지 선택|실시간 버스현황판(LiveActivity)|도착시|
|:--:|:--:|:--:|
|<img width="400" src="https://github.com/user-attachments/assets/f012d1ca-6201-4686-9414-9c52795bc49c"/>|<img width="400" src="https://github.com/user-attachments/assets/de286d08-22a7-45ca-acd7-57b018dabbae"/>|<img width="400" src="https://github.com/user-attachments/assets/5ae34c18-f138-410e-892b-33b83f72ec50"/>

<br>

### 이하연

<br>

## 작업요약

<br>

### 공통

- View의 로직이 많아짐과 역할 분리에 따른 `MVVM 패턴` 적용 (input | output)
- 네트워크 요청만을 담당하는 `NetworkLayer` 설계
- 반응형 프로그래밍(Reactive Programming)을 위해 RxSwift 적용

### 조성빈

<br>

### 이병훈
- `Tuist` 도입 및 프로젝트 구조 설계, 협업간 `pbxproj 충돌 개선`
- `LiveActivity`를 활용한 실시간 버스위치 현황판 구현
- `목적지 선택 페이지`
    - `CLLocation`을 활용한 현재위치와 가까운 정류장 표기
    - SkeletonView를 활용한 데이터 fetch하는동안 UX개선 

<br>

### 이하연


<br>

---


### TODO

1. 컨벤션
    - Color Asset 
    - self. 
    - string처리 
    - final class

2. Splash 화면


---


노션ID와 구간 정보로 차량들의 위치 정보 조회
https://www.data.go.kr/data/15000332/openapi.do

노선별 경유정류소 목록 조회
http://api.bus.go.kr/contents/sub02/getStaionByRoute.html

특정차량 위치 정보 조회 
http://api.bus.go.kr/contents/sub02/getBusPosByVehId.html


## Convention

컨벤션은 아래와 같음

#### Extension

파일명 
Extenion + 확장할 파일

ex)
`Extension + UIImageView.swift`
`Extention + UIAlert`
