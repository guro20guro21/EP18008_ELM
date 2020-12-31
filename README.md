# EP18008_ELM

## Webブラウザで図形をD&Dで動かす

**条件：**
Elm(エルム)を使う

Elm公式：[[Elm - A delightful language for reliable webapps](https://elm-lang.org/)]
Elm使用ガイド(日本語訳)：[[An Introduction to Elm](https://guide.elm-lang.jp/)]

## Elmの特徴
・JavaScriptにコンパイルできる関数型プログラミング言語

・エラー表示が分かりやすい↓
![](https://i.imgur.com/3FNwgtE.png)

・パフォーマンスが高い↓
![](https://i.imgur.com/pXDM9YR.png)

・if式、let式、case式、匿名関数、不変性、静的型付け等を持っている
　（不変性：Elmのすべての値はイミュータブル）
　（静的型：全ての定義に型注釈をつけることができる）

・シンプル、簡単で初心者でも入りやすい

# 第1週

## Elmを動かす(チュートリアル)
Elmをインストールして使用ガイドを見ながら実行
　⇒Ver0.19 だったので正常に動かない(Verが古い、というエラー表示)
　⇒Ver0.19.1 をインストール：[[ここから]](https://github.com/elm/compiler/releases/tag/0.19.1)
　⇒node.js がインストールされていないためエラー
　⇒node.js をインストール：[[ここから]](https://nodejs.org/en/)
　⇒プログラム実行可能！


# 第2週
## はじめに
日本語訳サイトが大きく変わっていました。
[[旧版]](http://guide-backup.elm-lang.jp/about_translation.html) ⇒ [[新版]](https://guide.elm-lang.jp/about_translation.html)

変更点：
インストールの項目の位置が変化した(オンラインエディタ推奨？)
　⇒インストールが必要な項目の直前に移動
 
新版を参考に進めていく...が、
**[オンラインエディタ](https://elm-lang.org/examples/buttons)を用いる**(一番単純にできるため)

## サンプルプログラムを試す
オンラインエディタ上部のMore Examples [Here](https://elm-lang.org/examples)から行う
![](https://i.imgur.com/opxTZSr.jpg)

:::spoiler マウスの周囲に円を表示、クリックで色が薄くなる
```
-- Draw a cicle around the mouse. Change its color by pressing down.
--
-- Learn more about the playground here:
--   https://package.elm-lang.org/packages/evancz/elm-playground/latest/
--

import Playground exposing (..)


main =
  game view update ()


view computer memory =
  [ circle lightPurple 30
      |> moveX computer.mouse.x
      |> moveY computer.mouse.y
      |> fade (if computer.mouse.down then 0.2 else 1)
  ]


update computer memory =
  memory
```
:::


**このプログラムと増減カウンターを組み合わせる？**
・import部分が異なっているため合わせる必要有？

## 参考サイト
[Elmのシンタックス](http://gtech.hatenablog.com/entry/2016/10/21/110212)
関係演算子の確認

# 第3週
## 進捗
ゼロです...というわけでもなく微妙
:::spoiler プログラム
```
import Browser
-- import Html exposing (Html, button, div, text)
-- import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html.Events.Extra.Mouse as Mouse
import List.Extra

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL
type alias Model = {
  rects: List (Float, Float),
  dragState: DragState }

type DragState = NotDragging
  | Dragging Int

init : Model
init = {
  rects = [ (50, 50), (200, 200) ],
  dragState = NotDragging }

-- UPDATE

type Msg = Down Mouse.Event
  | Move Mouse.Event
  | Up Mouse.Event

update : Msg -> Model -> Model
update msg model =
  case msg of
    Down event ->
      case intersects event.clientPos model.rects of
        Just index ->
          { model | dragState = Dragging index }
        Nothing ->
          { model | dragState = NotDragging }
  
    Move event ->
      case model.dragState of
        Dragging index ->
          { model | rects = List.Extra.setAt index
            (event.clientPos) model.rects }
        NotDragging ->
          model
    
    Up event ->
      { model | dragState = NotDragging }

intersects: (Float, Float) -> List (Float, Float) -> Maybe Int
intersects pos rects =
  rects
    |> List.Extra.findIndex (intersect pos)

intersect: (Float, Float) -> (Float, Float) -> Bool
intersect (px, py) (rx, ry) =
  if between px rx (rx + 100) then
    if between py ry (ry + 100) then
      True
    else
      False
  else
    False

between: Float -> Float -> Float -> Bool
between o min max =
  if o > min then
    if o < max then
      True
    else
      False
  else
    False

-- VIEW

view : Model -> Svg Msg
view model =
  svg
    [ width "500"
    , height "500"
    , viewBox "0 0 500 500"
    , Mouse.onDown Down
    , Mouse.onMove Move
    , Mouse.onUp Up
    ]
    (List append
      (List.map viewRect model.rects)
      [ text (Debug.toString model) ]
    )

viewRect : (Float, Float) -> Svg msg
viewRect (xPos, yPos) =
  rect [ x (String.fromFloat xPos) , y (String.fromFloat yPos)
    , width "100", height "100"] []
```
:::

先にこちらを↓

## 参考サイト
[Elm入門 プラスウイングTV](https://www.youtube.com/playlist?list=PLp_EUEO9JJP2P4fW-73jR3iC14476twsW)
このプレイリスト内の14～16(特に16の9:30～)

Playgroundじゃなくてもできている！

## なぜ進捗ゼロか
オンラインエディタではエラーが出てしまう。
:::spoiler エラー文(1)
You are trying to import a `Html.Events.Extra.Mouse` module:

6| import Html.Events.Extra.Mouse as Mouse
          ^^^^^^^^^^^^^^^^^^^^^^^
I checked the "dependencies" and "source-directories" listed in your elm.json,
but I cannot find it! Maybe it is a typo for one of these names?

    Html.Events
    Html.Attributes
    Html.Keyed
    Svg.Events

Hint: If it is not a typo, check the "dependencies" and "source-directories" of
your elm.json to make sure all the packages you need are listed there!
:::
:::spoiler エラー文(2)
You are trying to import a `List.Extra` module:

7| import List.Extra
          ^^^^^^^^^^
I checked the "dependencies" and "source-directories" listed in your elm.json,
but I cannot find it! Maybe it is a typo for one of these names?

    Set
    Bitwise
    Dict
    File

Hint: If it is not a typo, check the "dependencies" and "source-directories" of
your elm.json to make sure all the packages you need are listed there!
:::
原因...
オンラインエディタでは、
・参照しているソースコード(プログラム)がない
⇒参考先でも複数のファイルが関連しているため

インストールしたもので試そうとするが、
・Elmのコード作成ができない(エディタの問題？)


## 結果
Playgroundを使用しないでオブジェクトを動かす映像を見た。
プログラムも確認した。
実行はできていない...。

# 第4週
## 進捗 の前に...
先週時点で、
・Playgroundでの図形のドラッグ&ドロップで動かす
・↑を用いずに実行
　を色々な人が完成、改良済み
ということで、上記2つとは別の切り口を探してみる

## 進捗
**＊コマンドプロンプト**
mkdir [フォルダ名]
cd [フォルダ名]
elm init　←src(Main.elm等を入れるフォルダ)とelm.jsonを作成

**＊Sublime Text**　←elmファイルの作成、編集
File → Open Folder... →[フォルダ名]　からいろいろやっていく

ドラッグ&ドロップが使われそうなもの → スライドパズルを試す

これ(↓)が
![](https://i.imgur.com/azJxLG4.png)
　　　　　　　　![](https://i.imgur.com/GOeIX2u.png)
![](https://i.imgur.com/Klh2ENY.png)
こう(↑)なる

but. ドラッグ&ドロップではなくセルの入れ替え
　　　[elm-animator](https://package.elm-lang.org/packages/mdgriffith/elm-animator/latest/)を使用してアニメーションの設定

## elm-animatorについて
Elmでアニメーションを扱うためのパッケージ、[elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/)の作者が開発
* Animator：Timelineを使う、こいつが中心
* Animatior.Css：Cssの機能も用いる、拡張
* Animator.Inline：限定的に手間を省ける、拡張

## これまでのものと比較
* 実際にドラッグ&ドロップしていない...自由には動かせない
* セルの交換...将棋やチェスのようなものの作成では使える？
　→ 空きマスへ決められた移動、変な位置に駒を置かない
 　but. 移動が1パターンではない(空き1マスではなく前後左右等)

今回の課題に完全には適していないが、何かに利用できそう？
個人的に試していくのも楽しそう(感想)

## 参考サイト
[[elm-animatorでアニメーション(Animator.Inline) - Qiita]](https://qiita.com/nikueaters/items/e9e5a5c01bcb60d252ca)
　elm-animatorの説明

[[Elmでスライドパズル - Qiita]](https://qiita.com/nikueaters/items/8247c1d9de2ca3ec8ec0)
　プログラムの解説

[[GitHub - nikueater/9puzzle]](https://github.com/nikueater/9puzzle)
　8パズルのソースコード

[[GitHub - ababup/15-puzzle]](https://github.com/ababup1192/15-puzzle)
　15パズルのソースコード

