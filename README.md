# 基本的な使い方
1. `../cp.sh question.nim` のように入力するとテンプレートファイルが生成される

cp.shはシンボリックリンク越しでも動作する．

例
```
$ ln -s /path/to/procon/cp.sh /usr/local/bin/procon
$ procon /tmp/hoge.nim
```