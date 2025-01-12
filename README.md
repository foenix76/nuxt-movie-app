# nuxt-movie-app

# 실습환경을 만들기 위한 삽질
일단은 nuxt-movie-app 설치전 vue2-movie-app을 실행해보기 위한 환경 설정.
nodejs를 여러버전 사용할 수 있게 해주는 nvm으로 nodejs를 강의환경과 동일한 14.16.0으로 맞추기 위한 과정을 설명해본다.

기존에 scoop install mvn으로 설치한 mvn으로 node인스톨을 시도했으나 14.16.0인스톨시 에러 발생.

좀 더 상위의 다른 버전을 인스톨 해보니 잘 됨. 일단 scoop으로 설치한 mvn이 의심가서 전부 삭제하고 nvm공식 배포처인
[https://github.com/coreybutler/nvm-windows/releases](https://github.com/coreybutler/nvm-windows/releases)에서 받아 클린설치함.

nodejs를 최신버전부터 전부 설치해보기로 마음먹고 하나씩 설치하면서 쭈욱 내려가는데 15.14.0부터 문제 발생.
(나중에 재설치해보면서 알았는데 이 문제는 nvm을 스쿱으로 설치했던 인스톨본으로 설치했던 동일해서 이하 설명은 scoop으로 nvm을 다시 설치하고 진행하였음)

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
그런데 다른 TEMP폴더를 뒤져보니 node는 15.14.0이 받아져는 있음
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
C:\Users\blabla\scoop\apps\nvm\current\nodejs\node.exe

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
이후 터미널을 열어 nvm list 하니 두둥!! 드디어 환경변수를 제대로 가져온다.

아니 근데 이렇게 별도 cmd창으로 열어서 vscode를 실행하기 전에 몇번이나 Kill All Terminal도 해보고 vscode도 재시작 시켜봤는데.. 그때는 적용이 안되고 별도 cmd창을 열고 code .으로 실행해야만 환경변수를 새로 가져오다니...
아마 이 방법 외에는 시스템을 리부팅 했어야 적용이 됬을듯 하다
```bash
echo %NVM_HOME%
C:\Users\blabla\scoop\apps\nvm\current

echo %NVM_SYMLINK%
C:\Users\blabla\scoop\persist\nvm\nodejs\nodejs
```
그런데 이게 끝이 아니었다.
15.14.0의 nodejs에는 npm이 제대로 설치되지 않아 npm 실행이 불가. 아오 짜증나..
결국 아래 주소에서 node-v14.16.0-x64.msi를 다운로드 받아 nvm아래의 경로에 설치하고 설치시 옵션에서 path추가만 제외해줬다.
(윈도우용 패키지 관리툴인 chocolatey가 추가로 필요한 파일들을 한참을 설치한다)
[https://nodejs.org/download/release/v14.16.0/](https://nodejs.org/download/release/v14.16.0/)
이후 다른 PC에서 같은 과정을 한번 더 진행했는데 이때는 node-v14.16.0-x64.msi설치가 원하는 경로에 안되서 그냥 기본 디렉에 설치하고 chocolatey패키지 설치 도스창은 끈 뒤 원하는 경로로 설치파일을 이동시키고 이후 아래 가이드대로 진행했다. (node-gyp설치 및 chocolatey로 파이썬과 visualstudio2022-workload-vctools 설치)
[https://github.com/nodejs/node-gyp#on-windows](https://github.com/nodejs/node-gyp#on-windows)

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
# 윈도우에서 테스트 안했구만 ㅉㅉ..
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

.babelrc.js의 내용을 nuxt.config.js plugins속성에 babel:로 복사
.postcssrc.js의 내용도 nuxt.config.js plugins속성에 postcss:로 복사

package.json에 browserlist복사

주의점! jest를 쓰려면 .babelrc.js파일도 복사해줘야 함.
(babel은 ES6+, JSX등의 최신 자바문법을 jest가 이해할 수 있도록 트랜스파일링함)
nuxt.config.js에도 이미 옮겨줬지만 왜 .babelrc.js파일까지 복사해줘야 하는 이유는 jest의 실행환경은 nuxt.config.js와는 별개이기 때문.

cypress, tests, .eslintrc.js, cypress.json, jest.config.js도 복사
index.html의 헤더의 title, link등은 nuxt.config.js의 head에 옮겨줌
body tag의 스타일은 별도 css로 만든 후 nuxt.config.js의 css에 경로 추가

기존 functions의 서버리스펑션을 nuxt의 미들웨어로 마이그레이션
server-middleware/movie.js 생성하여 기존 functions/movie.js와 같은 역할을 하는 스크립트 코딩 후 경로 정보를 nuxt.config.js에 serverMiddleware:속성으로 추가
(해당 속성의 내용은 기존 netlify펑션 경로로 호출시 server-middleware로 들어올 수 있게 하는 것)

# 상세보기 화면
상세보기 화면에서 브라우저 릴로드시 포스터가 안나오는 증상의 수정을 위해 스토어디스패치 로직을 created에서 asyncData로 옮겨주는 부분이 있다.
그런데 작업 후에 테스트를 해봐도 계속 화면이 스캘레톤 상태.  너무 이상해서 강사분의 소스로도 빌드를 해봤는데 증상은 동일했다

결국 이것저것 해보다 알게 되었는데 npx browserslist@latest --update-db 명령어로 해결이 되었다.
단순히 브라우저 호환성과 관련이 있다고 생각은 했는데 이런 간단한 로직에도 영향을 끼칠 정도인건 솔직히 의외였다

브라우저 리스트를 업데이트하면 의존성중에 caniuse-lite의 버전이 1.0.30001220 -> 1.0.30001692로 바뀌고 이후에 상세보기 화면에서 브라우저 릴로드 테스트를 해보면 포스터가 잘 출력된다.
(이게 솔직히 운영중에 벌어진다면 바로 알아차리긴 쉽지 않을 것 같다. 잘 기억해둬야 할 듯...)
```bash
# 브라우저 리스트를 업데이트 하라는 경고. 정기적으로 업데이트 해야겠다.
 WARN  Browserslist: caniuse-lite is outdated. Please run:

npx browserslist@latest --update-db

Why you should do it regularly:
https://github.com/browserslist/browserslist#browsers-data-updating
```
Heroku 디플로이 완료. 우선 카드 등록하고 진행 후 디플로이 확인하고 바로 해지
(이후 FlyIO, Koyeb, Render, Vercel) 등 대체체 알아보고 옮길 예정

참고로 환경변수 중 사이트 주소 셋팅시에 끝에 /를 붙히면 상세보기 화면에서 리프레시하면 앱이 크래시되는 증상이 있었음
(수정하고 리디플로이 하니 해소됨)

# 이후 코드를 다시 돌려볼 일이 있어 빌드하는데 계속 오류 발생
잠깐 리엑트 공부하고 오느라 node버전을 14.16.0 -> 16.17.1로 변경했었는데 package.json과 package-lock.json이 기존과 동일하면 빌드 될 줄 알았더니 안된다.
node버전 변경했던걸 깜빡해서 한참을 package.json 만져보면서 쓸데없는 삽질을 했다.
계속 gyp랑 core모듈 관련된 에러가 나길래 내가 뭔가를 잘못 만진 줄..
여기서 나의 중요한 선입견 하나가 깨졌는데 package.json, package-lock.json까지 기존 프로젝트에서 가져오면 node, npm 버전이 달라도 빌드가 될거라고 상상했었는데 결론은 될 수도 있고 안될 수도 있다는 것이다.
이 점을 잊지 말 것!

이후 다시 nvm use 14.16.0으로 기존 버전으로 되돌리고 node_module폴더를 지우지도 않고 바로 npm i했더니 빌드가 성공하였다.
(허나 찝찝해서 node_modules를 지우고 다시 설치함)
```bash
# 혹시 몰라 에러 로그 기록
npm WARN deprecated core-js@2.6.12: core-js@<3.23.3 is no longer maintained and not recommended for usage due to the number of issues. Because of the V8 engine whims, feature detection in old core-js versions could cause a slowdown up to 100x even if nothing is polyfilled. Some versions have web compatibility
issues. Please, upgrade your dependencies to the actual version of core-js.
npm ERR! code 1
npm ERR! path C:\dev_study\nuxt-movie-app\node_modules\deasync
npm ERR! command failed
npm ERR! command C:\Windows\system32\cmd.exe /d /s /c C:\Temp\install-a6bc5d29.cmd
npm ERR! gyp info it worked if it ends with ok
npm ERR! gyp info using node-gyp@9.0.0
npm ERR! gyp info using node@16.17.1 | win32 | x64
npm ERR! gyp info find Python using Python version 3.13.1 found at "C:\Python313\python.exe"
npm ERR! gyp ERR! find VS
npm ERR! gyp ERR! find VS msvs_version not set from command line or npm config
npm ERR! gyp ERR! find VS VCINSTALLDIR not set, not running in VS Command Prompt
npm ERR! gyp ERR! find VS checking VS2022 (17.12.35527.113) found at:
npm ERR! gyp ERR! find VS "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
npm ERR! gyp ERR! find VS - found "Visual Studio C++ core features"
npm ERR! gyp ERR! find VS - found VC++ toolset: v143
npm ERR! gyp ERR! find VS - missing any Windows SDK
npm ERR! gyp ERR! find VS could not find a version of Visual Studio 2017 or newer to use
npm ERR! gyp ERR! find VS looking for Visual Studio 2015
npm ERR! gyp ERR! find VS - not found
npm ERR! gyp ERR! find VS not looking for VS2013 as it is only supported up to Node.js 8
npm ERR! gyp ERR! find VS
npm ERR! gyp ERR! find VS **************************************************************
npm ERR! gyp ERR! find VS You need to install the latest version of Visual Studio
npm ERR! gyp ERR! find VS including the "Desktop development with C++" workload.
npm ERR! gyp ERR! find VS For more information consult the documentation at:
npm ERR! gyp ERR! find VS https://github.com/nodejs/node-gyp#on-windows
npm ERR! gyp ERR! find VS **************************************************************
npm ERR! gyp ERR! find VS
npm ERR! gyp ERR! configure error
npm ERR! gyp ERR! stack Error: Could not find any Visual Studio installation to use
npm ERR! gyp ERR! stack     at VisualStudioFinder.fail (C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\find-visualstudio.js:122:47)
npm ERR! gyp ERR! stack     at C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\find-visualstudio.js:75:16
npm ERR! gyp ERR! stack     at VisualStudioFinder.findVisualStudio2013 (C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\find-visualstudio.js:363:14)
npm ERR! gyp ERR! stack     at C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\find-visualstudio.js:71:14
npm ERR! gyp ERR! stack     at C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\find-visualstudio.js:384:16
npm ERR! gyp ERR! stack     at C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\util.js:54:7
npm ERR! gyp ERR! stack     at C:\Users\blabla\scoop\persist\nvm\nodejs\v16.17.1\node_modules\npm\node_modules\node-gyp\lib\util.js:33:16
npm ERR! gyp ERR! stack     at ChildProcess.exithandler (node:child_process:408:5)
npm ERR! gyp ERR! stack     at ChildProcess.emit (node:events:513:28)
npm ERR! gyp ERR! stack     at maybeClose (node:internal/child_process:1093:16)
npm ERR! gyp ERR! System Windows_NT 10.0.19045
npm ERR! gyp ERR! command "C:\\Users\\shadow\\scoop\\apps\\nvm\\current\\nodejs\\nodejs\\node.exe" "C:\\Users\\shadow\\scoop\\persist\\nvm\\nodejs\\v16.17.1\\node_modules\\npm\\node_modules\\node-gyp\\bin\\node-gyp.js" "rebuild"
npm ERR! gyp ERR! cwd C:\dev_study\nuxt-movie-app\node_modules\deasync
npm ERR! gyp ERR! node -v v16.17.1
npm ERR! gyp ERR! node-gyp -v v9.0.0
npm ERR! gyp ERR! not ok
npm ERR! Build failed

npm ERR! A complete log of this run can be found in:
npm ERR!     C:\Users\blabla\AppData\Local\npm-cache\_logs\2025-01-12T10_50_37_552Z-debug-0.log
```
예전 자바 개발할 때처럼 maven, gradle 생각이 나서 이 종속성에 대한 부분은 nodejs관련 툴로 개발을 할 때 알고 있어야 하는 문제 같아서 chatgpt에게 물어본 답변을 첨부한다.
# Node.js 버전 변경 후 빌드 실패 원인과 해결 방법

Node.js 버전을 변경한 후 빌드가 실패하는 문제는 **Node.js 버전, 종속성의 호환성, 프로젝트 설정**과 관련이 있습니다. 아래에 가능한 원인과 해결 방법을 정리했습니다.

---

## 1. Node.js와 프로젝트 종속성의 호환성 문제
- 일부 NPM 패키지는 특정 Node.js 버전에서만 정상적으로 작동합니다.
- 예: Node.js 14.x → 16.x로 업그레이드 시 새로운 기능 또는 내부 API 변경으로 문제가 발생.

---

## 2. Node.js 주요 버전 간의 Breaking Changes
Node.js의 주요 버전(예: 14 → 16) 업그레이드에서는 종종 Breaking Changes가 발생합니다.
Node.js 16.x에서 문제가 될 수 있는 주요 변경 사항:
- **V8 엔진 업그레이드**: V8 9.x 포함. 일부 JavaScript 기능이 변경되거나 제거됨.
- **종속성 호환성**: `npm` 버전이 업그레이드되면서 종속성이 잘못 설치될 가능성.
- **네이티브 모듈 API 변경**: `node-gyp`를 사용하는 패키지에서 재빌드 필요.

---

## 3. 패키지 락 파일 문제
- `package-lock.json`은 Node.js 버전을 포함하지 않지만 **종속성의 해시 및 버전 정보**를 저장.
- Node.js 버전 변경 시 일부 패키지가 새로 설치되거나 호환되지 않을 수 있음.

### 해결 방법:
`node_modules` 폴더 삭제 후 다시 패키지 설치
```bash
rm -rf node_modules
npm install
```
## 4. 엔진 설정 문제
- `package.json` 파일의 `"engines"` 필드에서 지원하는 Node.js와 NPM 버전을 명시:
  ```json
  "engines": {
    "node": "14.x",
    "npm": "6.x"
  }
  ```
- 지정된 버전과 다른 Node.js를 사용하면 빌드가 실패하거나 경고가 발생할 수 있습니다.

---

## 5. C++ 빌드 툴 또는 네이티브 모듈 문제
- 일부 패키지(예: `node-sass`, `sharp`, `bcrypt`)는 네이티브 모듈을 사용하며, Node.js 버전에 따라 재컴파일해야 할 수 있습니다.
- Node.js 업그레이드 후 네이티브 모듈을 재빌드:
  ```bash
  npm rebuild
  ```

---

## 6. NPM 또는 Yarn의 문제
- Node.js 버전 업그레이드 시, NPM 버전도 자동으로 업그레이드됩니다. 이로 인해 호환성 문제가 발생할 수 있습니다.

### 해결 방법:
1. **NPM 캐시 정리**:
   ```bash
   npm cache clean --force
   ```
2. 필요 시, NPM 버전을 프로젝트에 맞게 다운그레이드:
   ```bash
   npm install -g npm@6
   ```

---

## 7. Node.js 버전 관리 (nvm 사용 추천)
Node.js 프로젝트는 보통 특정 버전에 의존합니다. 다양한 Node.js 버전을 쉽게 전환하려면 **nvm (Node Version Manager)**를 사용하는 것이 좋습니다.

### 설치 및 사용:
```bash
nvm install 14.16.0
nvm use 14.16.0
```

---

## 결론
Node.js 버전을 변경했을 때 빌드 실패는 **호환성 문제** 또는 **환경 설정 불일치**에서 발생할 가능성이 높습니다. 아래 단계를 추천합니다:
1. `node_modules` 폴더 삭제 및 재설치.
2. 네이티브 모듈 재빌드 (`npm rebuild`).
3. `package.json`에서 `engines` 설정 확인.
4. `nvm`으로 Node.js 버전을 관리하여 프로젝트별로 정확한 버전을 사용.

문제가 계속 발생하면 에러 로그를 제공해 주시면 추가로 분석해 드릴게요! 😊

# 내가 이해한 결론
nodejs의 버전에 따라 OS에 맞는 네이티브 모듈을 재컴파일 하기 위해 python과 node-gyp가 사용됨.
nodejs의 버전이 바뀌어서 python의 버전과 c++컴파일러가 달라지면서 desync모듈 컴파일시에 오류가 난 것으로 추측됨.

# 후기
CSR -> SSR전환이 생각했던 것 보다는 어렵지 않다는 느낌을 받았음.
사내전용 SI B/O프로젝트 등에서는 SEO가 중요하지 않겠지만 검색엔진으로 서비스 유입을 시켜야 하는 프로젝트의 경우 SSR은 선택이 아닌 필수로 보임

# Heroku -> Koyeb 이전
잘 빌드되나 구동에서 자꾸 실패하는중...
일단 node와 npm버전을 package.json에 추가해줌
``` js
  "engines": {
    "node": "14.16.0"
  }
```

이후 또 실패하여 (https://www.npmjs.com/package/npm?activeTab=versions)[https://www.npmjs.com/package/npm?activeTab=versions]를 참고하여 npm버전을 "6.14.11" -> "6.14.18"-> "6.x" 변경했다 아예 제거해봄.

이 경고도 찝찝해서 다운그레이드 했다가 Koyeb빌드 실패로 원복
```bash
 WARN  postcss@8.2.13 is installed but ^7.0.32 is expected
```

그외 가이드가 필요할 경우 아래 URL 참고
[https://www.koyeb.com/docs/deploy/nuxt](https://www.koyeb.com/docs/deploy/nuxt)
[https://nuxt.com/deploy/koyeb](https://nuxt.com/deploy/koyeb)
