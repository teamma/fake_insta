### 1. CRUD 끝내기 (non scaffold)

**RESTful** 하게 짜기! (posts 컨트롤러, post 모델!)

RESTful이란, 주소창(url)을 통해서 자원(리소스)과 행위(HTTP Verb)를 표현하는 것.

[가장 깔끔한 설명](http://meetup.toast.com/posts/92)

[routes](#1. routes.rb)

#### 0. 기본 사항

 - `git` 셋팅(git init부터)
 - C/R/U/D 마다 **commit** 하기
 - `posts` 컨트롤러와 `post` 모델만!

# 1. routes.rb

```ruby
  # index
  get '/posts' => 'posts#index'
  # Create
  get '/posts/new' => 'posts#new'
  post '/posts'=> 'posts#create'
  # Read
  get '/posts/:id' => 'posts#show'
  # Update
  get '/posts/:id/edit' => 'posts#edit'
  put '/posts/:id' => 'posts#update'
  # Delete
  delete '/posts/:id' => 'posts#destroy'
```

2. controller

  * [filter](http://guides.rorlab.org/action_controller_overview.html#%ED%95%84%ED%84%B0)

  ```ruby
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  private

  def set_post
    @post = Post.find(params[:id])
  end
  ```

  * [strong parameters](http://guides.rorlab.org/action_controller_overview.html#strong-parameters)

  ```ruby
  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
  ```

3. view - form_tag / form_for
  * [폼 헬퍼](http://guides.rorlab.org/form_helpers.html)

### 2. scaffolding.. 편하게 CRUD

1. `routes.rb`

```ruby
  resources :posts
```

2. `scaffold` 명령어

```console
$ rails g scaffold post title:string content:text
```

`posts` 컨트롤러와 `post` 모델을 만들어줌! 코드도 겁나 많음..


### 3. [파일업로드](https://github.com/carrierwaveuploader/carrierwave)

    1. `gemfile`

  ```ruby
  gem carrierwave
  ```

  ```console
  $ bundle install
  ```
    2. 파일업로더 생성

  ```console
  $ rails generate uploader Avatar
  ```

  3. 서버 작업

    * migration : string 타입의 column 추가

    * `post.rb`

      ```ruby
      mount_uploader :컬럼명, AvatarUploader
      ```

    * `posts_controller.rb`

      ```ruby
      # strong parameter에 받아주거나, create 단계에서 사진 받을 준비
      ```

  4. `new.html.erb`

  ```html
  <form enctype="multipart/form-data">
    <input type="file" name="post[postimage]">
  </form>

  <%= form_tag ("/posts", method: "post", multipart: true) do %>
    <%= file_field_tag("post[postimage]") %><br />
  <% end %>
  ```

### 3-1. 사진 크기 조절하여 저장

  `gem mini_magick`

### 4. 인스타처럼 꾸미기(카드형 배치)


### 5. devise로 회원가입 기능 구현하기

  * [devise](https://github.com/plataformatec/devise)

    1. 기초 시작하기

  - `Gemfile`에 devise 추가 후 `bundle install` 하기

  ```
  gem 'devise'
  ```

  - devise를 설치함

  ```console
  $ rails generate devise:install
  ```

> 주요하게 만들어지는 것들 ..
>
> devise.rb

  - User **모델** 만들기 with devise

  ```console
  $ rails generate devise User
  ```

  > 주요하게 만들어지는 것들 ..
  >
  > migration 파일 / user.rb  / routes에 경로 추가 됨.

* 마이그레이션

> 별도의 커스터마이징 column이 없다면 바로, 아니면 추가하고 실행할 것.

```console
$ rake db:migrate
```

* 서버 실행!
  * `rake routes`로 만들어진 url들 확인.
  * 예시
    *  /users/sign_up : 회원가입
    *  /users/sign_in : 로그인
    *  /users/sign_out : 로그아웃
      **주의** : get이 아니라 delete http method임! (url 접근 불가..)

2. 추가 내용

* 사용 가능한 helper

  * current_user : 로그인 되어 있으면, 해당 user를 불러올 수 있다.
  * user_signed_in? : 로그인 되어있는지 => return boolean

* 로그인해야 페이지 보여주는 방법 (`posts_controller.rb`)

  ```ruby
  before_action :authenticate_user!, except: :index
  ```

* view에서 로그인/로그아웃/회원가입 링크 보여주기(`application.html.erb`)

  ```erb
  <% if user_signed_in? %>
  <li>
    <%= current_user.email %>님
    <%= link_to('Logout', destroy_user_session_path, method: :delete) %>
  </li>
  <% else %>
  <li>
    <%= link_to('Login', new_user_session_path) %>
    <%= link_to('회원가입', new_user_registration_path)%>
  </li>
  <% end %>
  ```

* devise view파일 가져오기(커스터마이징..)

  ```console
  $ rails g devise:views
  ```

* devise controller 커스터마이징 하기

  ```console
  $ rails g devise:controller users
  ```

  `users/` 많은 컨트롤러가 생김..

  **반드시 `routes.rb` 수정 **

  ```ruby
  devise_for :users, controllers: {
    sessions: 'users/sessions'
    }
  ```

* 커스터마이징 column

  1) `migration` 파일에 원하는 대로 만들기!

  2)  해당 view에서 input 박스 만들기!

  3) strong parameter 설정 (컨트롤러 직접 가능/`application_controller.rb`에서도 가능)

  ```ruby
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  ```

  ​
