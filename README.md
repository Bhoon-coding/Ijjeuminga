# Ijjeuminga(이쯤인가) 🚌 👀

> 탑승중인 버스의 현재 경로를 실시간으로 알려주고 목적지 근처부터 사용자에게 알림을 주는 버스도착 알림앱 (공공API 사용)


<br>

# 목차
1. [프로젝트 소개](#프로젝트-소개)
    - [작업요약](#작업요약)
    - [미리보기](#미리보기)
    
2. [트러블슈팅](#트러블슈팅)

<br><br>

# 프로젝트 소개

> 아래 공공API (서울버스)를 이용해 현재위치 기반의 가까운 정류장을 기준으로 목적지 선택시 목적지 부근부터 미리 안내를 해주는 앱

**API**
- [서울_버스위치정보조회_서비스](https://www.data.go.kr/data/15000332/openapi.do)
- [서울_버스운행정보_공유서비스](http://api.bus.go.kr/contents/sub02/getStaionByRoute.html)


<br>

### 👨‍💻 Developers
|조성빈🍎|이병훈🍎|이하연🍎|
|:--:|:--:|:--:|



<br>

## 작업요약

<br>

||조성빈|이병훈|이하연|
|:---:|---|---|---|
|구현 & 기여|%| <br> - 출발지 / 목적지 선택 페이지 (100%) <br> - Tuist 도입 및 구조설계 (100%) <br> - 버스 실시간 현황판 (LiveActivity) (100%) | % |



<br>

#### 기간

2024.07.01 ~ 2024.09.10 (2개월)

<br>

#### 기술스택

- UIKit, SwiftUI
- CoreData, CLLocation
- MVVM
- RxSwift
- Unit Test
- Tuist

<br>

### 공통

- View의 로직이 많아짐과 역할 분리에 따른 `MVVM 패턴` 적용 (input | output)
- 네트워크 요청만을 담당하는 `NetworkLayer` 설계
- 반응형 프로그래밍(Reactive Programming)을 위해 RxSwift 적용

<br>

### 조성빈

<br>

### 이병훈
- `Tuist` 도입 및 프로젝트 구조 설계, 협업간 `pbxproj 충돌 개선`
- `LiveActivity`를 활용한 실시간 버스위치 현황판 구현
- `출발지 | 목적지 선택 페이지`
    - `CLLocation`을 활용한 현재위치와 가까운 정류장 표기
    - SkeletonView를 활용한 데이터 fetch하는동안 UX개선 

<br>

### 이하연


<br>

## 미리보기

<br>

### 조성빈

<br>

### 이병훈
|출발지 선택|목적지 선택|
|:--:|:--:|
|<img width="200" src="https://github.com/user-attachments/assets/9f68b5b2-2339-426d-8da3-c74da84cf2ee"/>|<img width="200" src="https://github.com/user-attachments/assets/f012d1ca-6201-4686-9414-9c52795bc49c"/>|

|실시간 버스현황판<br>(LiveActivity)|도착시|
|:--:|:--:|
|<img width="200" src="https://github.com/user-attachments/assets/de286d08-22a7-45ca-acd7-57b018dabbae"/>|<img width="200" src="https://github.com/user-attachments/assets/5ae34c18-f138-410e-892b-33b83f72ec50"/>|

<br>

### 이하연

## 트러블슈팅

### 조성빈

<br>

### 이병훈

##### 문제 1
`project.pbxproj`의 잦은 충돌

- 팀원들의 작업 merge 과정에서 파일 변경(생성, 삭제)시 `project.pbxproj` 에서 충돌이 나는데 이를 해결하는데만 2~3시간이 소요되는 일이 잦았음
- <img width="500" alt="대환장파티1" src="https://github.com/user-attachments/assets/05ab120e-9513-4072-b972-f98f503205e1">
    
#### 해결방안 
- 이를 해결하고자 리서치했던 툴은 아래와 같으며, 채택한 이유도 작성
    - **Tuist(채택)**
        - swift 파일로 프로젝트를 관리한다는 장점이 있음
        - [SwiftGen](https://github.com/SwiftGen/SwiftGen)과 같이 Asset, Font등 파일을 추가하면 하드코딩하지 않고 해당 리소스에 접근할 수 있는 기능제공
        - 의존성을 직관적으로 확인할 수 있는 `tuist graph`
        - 추후 모듈화 및 빌드속도 향상 기대
    - git attributes(x)
        - 적용을해도 충돌이 난다는 대다수의 의견 확인

#### 느낀점
- 개인적으로 러닝커브가 높다는 생각이 들었고, 버전 업데이트가 많다보니 레퍼런스  이미 프로젝트 진행중인 상황에 Tuist를 적용하다보니 혹시 잘못 건들여 문제가 발생하는게 아닌가하는 걱정이 있었지만, 프로젝트를 CLI를 통해 .xcodeproj 파일은 `tuist generate`시 재생성되기 때문에 수정된 코드만 반영이 되는점이 매력적이었음. 또한 Project, Package, Config 등 각각의 파일들의 역할이 명시적으로 나와있고 역할에 따라 적용만 해주면되는 편리함이 있었음.

##### 문제 2
현재위치와 가장 가까운 버스 정류장 표기

- API의 response값으로, 버스 정류장 리스트들의 좌표중 현재위치와 가장 가까운 버스정류장을 표기해야 했음

#### 해결방안
- 버스 정류장 리스트들을 반복문을 돌려 각 정류장마다 현재 위치와 가장 가까운 좌표를 찾게 구현함
![image](https://github.com/user-attachments/assets/1cb6590b-f3a4-4a0d-8312-032213c29e70)

1. 각 좌표별로 distance를 구하는 메서드를 이용해 distance가 가장 적을경우 현재 위치와 가장 가까운 정류장이라고 판단.
2. 각 정류장의 distance를 distances라는 Array에 추가한 후 
3. distances의 요소중 최소값 (***min()***)을 가진 해당 index를 구하고
4. 해당 index를 현재위치와 가장 가까운 정류장으로 표기


##### 문제 3
`CLLocation 및 정류장 표기 문제`

- 기존에 기획된 페이지는 3개였음 (버스검색 | 목적지 선택 | 실시간 버스)
    - 현재정류장 표기를 `CLLocation`의 현재 위치 기준 `가장 가까운 정류장`을 표기하도록 구현했으나,<br> 맞은편의 정류장이 표기되는 문제가 발생함
    - 목적지선택 > 검색기능을 활용해서 방면을 선택하는 부분도 있었지만 사용자가 텍스트를 입력하고 방면을 선택해야한다는 번거로움이 있을거라 판단

#### 해결방안 
- 목적지 선택 페이지 이전에 출발지 선택 페이지에서 근처 정류장 2개를 보여줌.
- 이후 사용자가 현위치 및 방면을 한 눈에 볼 수 있도록 UI를 제공하고 선택하여 목적지 방향에 맞출 수 있도록 함

#### 느낀점

- 처음엔 로직적으로 어떻게든 풀어내려고 고민을 했었다.
하지만 정확성을 확신할 수 없었고, 이후 팀원들과 얘기를 해보면서 페이지를 하나 더 만들어 유저 입장에서도 더 간단하게 알아볼 수 있고, 개발리소스도 적게 들면서 문제를 해결해 나갔던점이 좋았다.


<br>

### 이하연



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
