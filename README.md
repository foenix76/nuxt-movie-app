# nuxt-movie-app

# 실습환경을 만들기 위한 삽질
일단은 nuxt-movie-app 설치전 vue2-movie-app을 실행해보기 위한 환경 설정.  
nodejs를 여러버전 사용할 수 있게 해주는 nvm으로 nodejs를 강의환경과 동일한 14.16.0으로 맞추기 위한 과정을 설명해본다.

기존에 scoop install mvn으로 설치한 mvn으로 node인스톨을 시도했으나 14.16.0인스톨시 에러 발생.

좀 더 상위의 다른 버전을 인스톨 해보니 잘 됨. 일단 scoop으로 설치한 mvn이 의심가서 전부 삭제하고 nvm공식 배포처인
[https://github.com/coreybutler/nvm-windows/releases](https://github.com/coreybutler/nvm-windows/releases)에서 받아 클린설치함.  

nodejs를 최신버전부터 전부 설치해보기로 마음먹고 하나씩 설치하면서 쭈욱 내려가는데 15.14.0부터 문제 발생.  
(나중에 재설치해보면서 알았는데 이 문제는 nvm을 스쿱으로 설치했던 인스톨본으로 설치했던 동일하다)

```bash
# 16.20.2 정상 설치
nvm install 16.20.2
Downloading node.js version 16.20.2 (64-bit)...
Extracting node and npm...
Complete
Installation complete.
If you want to use this version, type:

nvm use 16.20.2

# 15.14.0 설치 실패
nvm install 15.14.0

Downloading node.js version 15.14.0 (64-bit)...
Complete
Downloading npm...
Creating C:\TEMP\nvm-install-3453498624\temp

Downloading npm version 7.7.6... Complete
Installing npm v7.7.6...
error installing 15.14.0: open C:\TEMP\nvm-npm-2944932808\npm-v7.7.6.zip: The system cannot find the file specified.
```
오오.. 여기서 눈에 딱 띄는 문구!  
npm-v7.7.6.zip파일이 있어야 하는데 없다는 것.
그런데 다른 TEMP폴더를 뒤져보니 15.14.0이 받아져는 있음
```bash
# 일단 설치된 버전 확인
nvm list
    23.6.0
    22.13.0
    21.7.3
    20.18.1
    19.9.0
    18.20.5
    17.9.1
    16.20.2

# nodjs의 실행 파일 위치를 찾아보니 아래 폴더에 있음
C:\Users\blabla\AppData\Local\nvm\

# 아까 TEMP폴더에서 찾은 nodejs 15.14.0을 위 폴더로 카피
nvm list
    23.6.0
    22.13.0
    21.7.3
    20.18.1
    19.9.0
    18.20.5
    17.9.1
    16.20.2
    15.14.0  <-- 빙고!!
```
그런데 여전히 vscode에 내장된 터미널과 cmd쉘, git bash에서는 갱신된 nvm, node경로를 못 가져옴.  왜지? why? 왜때문에?!!  
환경변수의 NVM_HOME, NVM_SYMLINK를 현재 상태가 아닌 아까 scoop으로 설치했다 지웠던 옛날 경로를 계속 참조하고 있다.  
vscode밖에서 여는 창들에서는 환경변수를 현재 값으로 잘만 가져오는데..  
vscode의 터미널에서 파워쉘, cmd, git bash를 열어보니 3가지 창이 모두 예전 환경변수를 가리키는 것을 보니 이건 파워쉘이나 cmd같은 단일 커멘드창의 문제가 아닐지도 모른다는 생각이 들었다.  
이후 GPT에게도 물어보고 구글링하면서 찬찬히 다음 게시물을 읽어보다가 힌트를 발견!  
[https://stackoverflow.com/questions/48595446/is-there-any-way-to-set-environment-variables-in-visual-studio-code](https://stackoverflow.com/questions/48595446/is-there-any-way-to-set-environment-variables-in-visual-studio-code)

vscode가 시작할 때 지정된 환경을 상속받는다는 내용이 있어 일단 vscode의 내장터미널을 닫고 vscode를 종료하고 프로젝트 루트를 새 cmd창으로 열어 code . 으로 현재디렉토리에서 vscode를 실행시켰다.  
이후 터미널을 열어 nvm list 하니 두둥!!
```bash
nvm list
    23.6.0
    22.13.0
    21.7.3
    20.18.1
    19.9.0
    18.20.5
    17.9.1
    16.20.2
    15.14.0
```
그런데 이게 끝이 아니었다.  
15.14.0의 nodejs에는 npm이 제대로 설치되지 않아 npm 실행이 불가. 아오 짜증나..  
결국 아래 주소에서 node-v14.16.0-x64.msi를 다운로드 받아 nvm아래의 경로에 설치하고 설치시 옵션에서 path추가만 제외해줬다.  
(윈도우용 패키지 관리툴인 chocolatey가 추가로 필요한 파일들을 한참을 설치한다)  
[https://nodejs.org/download/release/v14.16.0/](https://nodejs.org/download/release/v14.16.0/)

이후 vue2-movie-app 프로젝트 경로에서 npm i하니 깔끔하게 한방에 패키지 업데이트 성공!  
(vue3때도 삽질하지 말고 이렇게 버전을 딱딱 맞춰서 했어야 했다. 뭐 결과적으로 패키지에 대한이해는 높아졌지만서도..)  

이후 npm run dev하고 접속시 401오류 발생하여 확인해보니 .env설정이 필요.  
.env파일에 OMDB_API_KEY=API키 넣어주고 재기동하면 정상 동작함  

# nuxt-movie-app 생성
생성과정에 물어보는 내용이 좀 달라 확인해보니 create-nuxt-app의 버전이 5라 강의에 나오는 3.6.0으로 지정하여 실치  
이때 아래와 같은 오류 발생. 
```bash
npm create-nuxt-app@v3.6.0 nuxt-movie-app
.
.
.
# 윈도우에서 테스트 안했구만 ㅎㅎ..
Trace: ReferenceError: ejs:1
 >> 1| <%_ if (isWindows === true) { _%>
    2| command_exists () {
    3|   command -v "$1" >/dev/null 2>&1
    4| }

isWindows is not defined

# 버전을 약간만 올려서 재시도하니 성공!
npm create-nuxt-app@v3.7.0 nuxt-movie-app
.
.
.
🎉  Successfully created project nuxt-movie-app

  To get started:

        cd nuxt-movie-app
        npm run dev

  To build & start for production:

        cd nuxt-movie-app
        npm run build
        npm run start
```

# Vue2 Movie app 소개
vue2-movie-app은 Vue2와 OMDb API를 사용하는 영화 검색 애플리케이션입니다.<br>
[Vue3-Movie-app](https://github.com/ParkYoungWoong/vue3-movie-app) 과 비교해 보세요!

목표 : 이 앱을 현재 생성한 NUXT-MOVIE-APP으로 마이그레이션 해야 함  
추가로 vue2와 vue3의 차이도 체크해볼 것  

# 폴더 구조
기존의 src하위에 있는 컴포넌트 폴더가 nuxt에서는 루트에 있음  
Logo.vue파일 덮어쓸건지 안 물어봐서 확인해보니 NuxtLogo.vue라는 이름으로 들어있음. (아 불안한데? ㅋㅋ 0.1올렸다고 또 뭔가 안되려나 ^^;)    
RouterLink -> NuxtLink로 변경  
routes대신 pages폴더로 처리. pages폴더에는 메인화면을 뜻하는 index.vue파일이 있는데 일단 삭제.
routes에서 index.js제외하고 pages로 옮김. 메인화면 역할인 Home.vue -> index.vue로 변경
About.vue -> about.vue, routes의 index.js의 path: '/movie/:id'를 참조하여 /pages/movie/_id.vue 생성  
Movie.vue의 내용은 _id.vue로 옮기고 Movie.vue는 제거  
NotFound.vue는 layout에 넣어줘야 한다는데 layout폴더가 없어서 만들어서 옮겨주고 error.vue로 리네임

기존 routes에서 index.js로 관리해주던 경로를 nuxt에서는 pages안의 파일을 통해 자동으로 해준다는 것 같음  
기존에 메인페이지에서 Header, RouterView, Footer를 제공하던 App.vue가 nuxt쪽에는 없고 대신 layout/default.vue가 공용컴포넌트로 쓰임  
내용 복제 후 RouterView -> Nuxt로 변경  
(기존 컴포넌트에서 RouterLink를 NuxtLink로 변경한 것처럼 RouterView는 Nuxt로 변경하고 기능차이는 없음)  
plugins/loadIage.js플러그인도 같은 경로에 옮겨줌. 단, Vue.use(플러그인)을 main.js이 아닌 plugins/index.js에서 해주고 nuxt.config.js에 plugins부분에 '~/plugins/index.js' 추가.  

loadImage.js의 document객체에 대한 예외처리 : 서버에서는 document를 사용하지 않으므로 별도 처리  
scss폴더 복제 및 경로에 ~사용(nuxt에서는 ~이용시 node_dules/를 바로 참조)  

기존 sass-loader설정처럼 공통 임포트를 해주기 위해 아래 의존성 추가 및 nuxt.config.js에 설정 추가  
npm i -D @nuxtjs/style-resources  
```js
  modules: [
    '@nuxtjs/style-resources'
  ],

  styleResources: {
    scss: [
      '~/scss/main.scss'
    ]
  },
```
store폴더 복제 및 index.js내용 제거(삭제는 하면 안됨. 파일이 있어야 store기능 활성화)  

.barbelrc부터 계속해야 함
07강 05:24부터


# 이하 생성시 디폴트 내용
## Build Setup

```bash
# install dependencies
$ npm install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

## Special Directories

You can create the following extra directories, some of which have special behaviors. Only `pages` is required; you can delete them if you don't want to use their functionality.

### `assets`

The assets directory contains your uncompiled assets such as Stylus or Sass files, images, or fonts.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/assets).

### `components`

The components directory contains your Vue.js components. Components make up the different parts of your page and can be reused and imported into your pages, layouts and even other components.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/components).

### `layouts`

Layouts are a great help when you want to change the look and feel of your Nuxt app, whether you want to include a sidebar or have distinct layouts for mobile and desktop.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/layouts).


### `pages`

This directory contains your application views and routes. Nuxt will read all the `*.vue` files inside this directory and setup Vue Router automatically.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/get-started/routing).

### `plugins`

The plugins directory contains JavaScript plugins that you want to run before instantiating the root Vue.js Application. This is the place to add Vue plugins and to inject functions or constants. Every time you need to use `Vue.use()`, you should create a file in `plugins/` and add its path to plugins in `nuxt.config.js`.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/plugins).

### `static`

This directory contains your static files. Each file inside this directory is mapped to `/`.

Example: `/static/robots.txt` is mapped as `/robots.txt`.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/static).

### `store`

This directory contains your Vuex store files. Creating a file in this directory automatically activates Vuex.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/store).
