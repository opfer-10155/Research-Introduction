--  依存型プログラミングについてのサンプルコード

module Intro where

open import Data.Nat using (zero; suc; _+_) renaming (ℕ to UInt)

-- 依存型とは、型の中に値(数値など)のデータを埋め込むことができる型です。
-- これにより、通常の型では表現できないデータの型を表現することができます。
-- 以下に2つの型を示します。
-- 1つは通常の言語にもある、ある型の要素を持つリスト、
-- もう1つは依存型を使って表現した、ある型の要素を持つ長さがnのリストです。

-- 普通のリスト
-- AgdaでのSetはいわゆる"型の型"です。たとえば、型"Bool"はSet型の要素であると言えます。
data NormalList (A : Set) : Set where
  [] : NormalList A
  _∷_ : A -> NormalList A -> NormalList A


-- 依存型を使って、型の中に長さの情報を加えたリスト
data List (A : Set) : UInt -> Set where 
  [] : List A zero
  _∷_ : ∀{n : UInt} -> A -> List A n -> List A (1 + n)

infixr 20 _∷_

-- 以下にList型の値の例を示します。
-- List A n は "A型の要素を持つ長さnのリスト"のみを表す型です。
a : List UInt 0
a = []

b : List UInt 1
b = 1 ∷ []

c : List UInt 2
c = 2 ∷ 1 ∷ []

-- 以下をコメントアウトして型検査をすると型エラーになります。
-- List UInt 0 つまり長さ0のリストの型の変数に
-- 長さ1のリストを代入しようとしているからです。
-- error1! : List UInt 0
-- error1! = 1 ∷ []


-- List型が長さの情報を持つと、どんないいことがあるでしょうか？
-- 例えば、通常の型の言語におけるhead関数を考えてみましょう。
-- headはリストの先頭の要素を返す関数です。
-- headに空のリストが渡されたときの動作はどうすればよいでしょうか？
-- 通常の言語では、実行時エラーを出して実行を終了してしまいます。
-- このような、想定外の引数が渡される事態は避けるべきなのです。
-- head : ∀{A : Set} -> NormalList A -> A
-- head [] = ???
-- head (a ∷ _) = a

-- 長さの情報を持ったリストなら、この事態を避けられます。
-- safe-head には空のリストを渡されたときの動作定義が必要ありません。
-- なぜなら、safe-headの型宣言を見ると、第一引数の型は長さ1以上であると定義されているからです。
safe-head : ∀{A : Set}{n : UInt} -> List A (1 + n) -> A
safe-head (a ∷ _) = a

-- もちろん、safe-headに空リストを渡そうとすれば型エラーになります。
-- つまり、safe-headに不正な引数を渡すことによるエラーを、型検査によって実行前に検出できるということです。
-- これを通常の型システムで行うことはできません。
-- これが、依存型がより強力なプログラム検証能力を持つと言われる所以です。

-- 型エラーが起きます
-- safe-head []


