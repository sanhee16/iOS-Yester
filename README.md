# IOS-Yester

## AppStore

https://apps.apple.com/kr/app/예스터-어제와-오늘-그리고-내일의-날씨/id6466406778

## 프로젝트 목적

OpenAPI를 사용해서 날씨 정보를 받아오는 ios 앱을 만든다.
FlexLayout의 사용법을 익힌다.

### 외부 package

- realm
  - 지역 정보들을 담기위해 local db로 선택
- lottie
  - progressView를 띄울 때 사용
- alamofire
  - api 통신 위해 사용

### 기술 및 패턴

- MVVM
- coordinator pattern
- DI(의존성 주입)
- UIKit, PinLayout, FlexLayout
- Swift
- Combine
- api 통신에 사용
- Realm

---

### 파일 구조

<img src="/ReadmeResources/construct.png" width="200">

##### 구성

- Base
- Application
- Infrastructure
- Data
- Domain
  - Entities
  - Network 통신에 사용되는 Data Model(Codable)
- Presentation
  - UI
  - ViewController, View, ViewModel
- Resources
  - Asset, Json, Localization

<!-- <details markdown="1"> -->

### 페이지 정보

1. 스플래시
2. 날씨 페이지
   <img src="/ReadmeResources/ko4.png" width="300"> <img src="/ReadmeResources/ko5.png" width="300">
3. 설정 페이지
   <img src="/ReadmeResources/ko3.png" width="300">
4. 지역 검색 / 선택 / 편집 페이지
   <img src="/ReadmeResources/ko1.png" width="300"> <img src="/ReadmeResources/ko2.png" width="300">

### 스플래시

앱 최초 실행시 진행 작업, 로딩

- 기능

  - 앱 최초 실행시 지역 접근 권한 받기

- 현재 지역 정보 설정
  - 현재 위치의 위도/경도를 받아와서 Geocoding을 통해 위치정보를 DB에 저장

### 날씨 페이지 / 메인페이지

스플래시를 지나면 나오는 페이지  
날씨 세부정보를 카드형식(UIPageViewController)으로 알 수 있음.
설정, 지역 관리 등의 페이지로 넘어갈 수 있음.

- 표시정보
  - 현재 온도, 위치, 마지막 업데이트 시간, 현재 날씨 아이콘, 현재 날씨 설명
  - 오늘 날씨 최저 기온, 최고 기온
  - 오늘 날씨 기압, 습도, 풍속, 체감온도, 자외선
  - 시간 별 날씨 : 시간, 날씨 아이콘, 온도, 강수확률
  - 일주일 날씨 / 어제 날씨 : 날짜(요일), 날씨 아이콘, 강수량, 최고기온, 최저기온
  - 날씨 icon을 받아서 asset에 넣은 이미지로 대체
- 기능
  - 날씨 새로고침
  - 스와이프로 선택한 지역 날씨 교체 가능
  - 현재위치 표시
  - 마지막 카드 및 우측 상단에서 위치 추가 가능
  - 설정페이지 이동
- 사용된 주요 기술
  - combine: api 호출 시 사용
  - alamofire: api 호출해서 정보 받아옴
  - realm: 저장된 지역이 무엇이 있는지 확인한 후 정보 받아옴.

### 설정 페이지

앱 설정 페이지

- 기능
  - 앱 버전 확인
  - 단위 선택
    - 미터법, 야드/파운드법

### 지역 검색 / 선택 / 편집 페이지

지역을 검색하여 선택할 수 있고, 사용자가 지역을 삭제/추가 할 수 있다.
Geocoding, ReverseGeocoding이 사용된다.

- 기능

  - 지역 검색
  - 지역 추가
  - 저장된 지역 삭제

- 사용된 주요 기술
  - realm: 저장된 지역 불러오기, 사용자가 설정한 지역 삭제 및 추가시 realm DB에 저장

### Trouble Shooting

1. API 호출을 최대한 적게 하는 방법  
   <b>[문제]</b> 여러 지역을 추가하여 볼 수 있기 때문에 지역별로 효율적으로 API를 호출하는 방법이 필요했습니다. API 호출 빈도에 따라 금액이 책정되기 때문에, API를 최대한 적게 호출해야 했습니다. 한번에 모든 지역의 날씨를 호출하면, 불필요하게 API를 호출하게 됩니다.
   날씨 앱의 특성상 유저에게는 현재 위치의 날씨가 가장 중요하게 여겨집니다. 따라서 이 앱은 여러 지역을 추가해도 보지 않을 가능성이 높고, 유저가 아직 조회하지 않은 지역(페이지)이라면 API를 호출하지 않아야 합니다.
   <b>[해결방안]</b> 우선, 카드의 맨 처음은 무조건 현재위치로 설정했습니다. 유저가 가장 관심있어하는 날씨는 현재 위치의 날씨일 가능성이 제일 높기 때문에, 항상 맨 앞에 배치하여 다른 카드를 먼저 조회하지 않도록 했습니다.<br/><br/>

   처음에 카드를 보여줄 때 사용자가 카드를 넘길 때 해당 카드 지역의 API를 호출하도록 설정했습니다. 아직 API 로드중이면 사용자의 네트워크가 원활하지 않을 때 유저가 오류라고 느낄 수 있기 때문에, Circular Progress Bar를 띄웠습니다.<br/><br/>

   다른 페이지에 갔다가 돌아올 때도 다시 API를 호출하지 않도록 해야 했습니다. 따라서 이미 로드된 정보가 있다면 isLoad 변수가 true로 하고 기존 item을 불러오도록 했습니다.<br/><br/>

   유저가 다른 페이지에 갔다 왔을 때는 변경사항이 있을 수 있습니다. 지역이 추가/삭제되거나, 단위가 변경되는 일이 발생할 수 있습니다. 따라서 지역이 추가 되었다면 추가된 지역을 isLoad = false 로 설정하여 날씨를 Load할 수 있도록 하고, 단위가 변경되면 모든 지역이 다시 Load되어야 하기 때문에 분기처리를 통해 isLaod를 모두 false로 변경하여 전부 다시 로드될 수 있도록 설정했습니다.

   ```swift
   // 날씨 API 호출
   func updateWeather(_ idx: Int, onDone: ((WeatherCardItem?)->())? = nil) {
       // API 호출 작업이 아직 안끝났거나, 이미 Load된 데이터라면
       if self.isLoading.value || self.items[idx].isLoaded {
           onDone?(self.items[idx])
           return
       }
   }
   ```

2. 지역 검색시 동일 지역명의 문제점  
   <b>[문제]</b> 지역 검색 기능을 위해 Geocoding API를 사용하였는데, 동일 지역명일때는 위도와 경도 말고는 사용자가 해당 데이터들이 서로 다른 데이터인지 구분할 수 있는 방법이 없었습니다. 위도 경도를 보여주면서 유저에게 지역을 선택하라고는 할 수 없기 때문에, 다른 방법을 찾아야 했습니다.
   <b>[해결방안]</b>
   첫번째 방법으로, 다른 Geocoding API를 찾아보았습니다. API의 우선순위는 다국어 지원, 원하는 정보(지역명, 위도/경도)의 표시, 무료거나 낮은 가격이었습니다. 하지만 적당한 API를 찾지못해 다른 방법을 찾아야 했습니다.<br/>

   두번째 방법으로는 위도 경도를 가지고 ReverseGeocoding을 통하여 더 정확한 지리명을 가져오는 것이었습니다. ReverseGeocoding API의 우선순위 역시 다국어 지원, 지역명 표시, 무료거나 낮은 가격이었습니다. 적합한 API를 찾았고, Geocoding → ReverseGeocoding의 과정을 통해 더 정확한 지역명을 가져오도록 하였습니다.
