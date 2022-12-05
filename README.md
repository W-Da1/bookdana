# bookdana
所有している本を一括登録しておくアプリケーションです．

1.テーブルビューの右上「+」マーク
2.New Book登録画面になり，著書名，出版年月日，著者名を登録でき，著書名のみからの登録(save)が可能です．
3.手打ちが面倒な方のために，「バーコードリーダ」を押すと本のISBNをカメラで読み取り登録に使用することができます．
3'.最近はバーコードがない本もあるためISBNは手打ち可能です．
4.正しいISBNを入力の上，「ISBN検索」を押すことでGoogleBook APIによって上記３つ情報を取得し登録します(API取得できなかった場合は????が文字列として入力されます)．
5．saveボタンを押すことで登録できます．
