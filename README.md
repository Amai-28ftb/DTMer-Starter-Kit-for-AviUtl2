## 紹介動画
動画を見ればどんなスクリプトか一発で分かります。基本的に音声波形、ステレオイメージャー、MIDI表示がメインです。
[ニコニコ動画](https://www.nicovideo.jp/watch/sm45949170)


## 配布先について
- [Notion](https://app.notion.com/p/AviUtl-Script-178bea655f6480208a75fc94e60244ad)：一番更新が早いです
- [BOOTH](https://amai-28ftb.booth.pm/items/7986564)：支援用です。無料DLも可能です。
- [Github](https://github.com/Amai-28ftb/DTMer-Starter-Kit-for-AviUtl2)：ここです。


## 注意事項
- 私の書いたコードが各方面から怒られるレベルであまりにも汚すぎたのと、冗長な処理が多すぎて動作がかなり重かったので、可読性を高める為&処理の簡略化の為、AIにリファクタを手伝って貰っています。使用前にご了承ください。
- GitHub Copilotが提案するコードは著作権的にクリーンのはずですが、万が一問題がありましたら連絡ください。該当箇所を修正します。
- 現在はβ版ですので、バグや不具合が多いと思いますがご了承ください。

## 使用方法
- カスタムオブジェクト、アニメーション効果、トラックバーから呼び出してください。
- 詳細な説明は [Notion](https://tourmaline-rock-7c0.notion.site/DTMerStarterKit-Wiki-AviUtl2-300bea655f64804d975fea11976ad85c) をご覧ください。

## 内容物
### @DTMer Starter Kit.obj2
- AudioSpectrum_01：音声波形です。
- AudioSpectrum_02：音声波形です。
- AudioSpectrum_03：音声波形です。
- AudioSpectrum_04：音声波形です。
- AudioSpectrum_05：音声波形です。
- VolumeMeter：音量バーです。
- SoundSync_Live：トラックバーの音声同期設定用です。音声波形から特定周波数の音量情報をトラックバーへ飛ばします。音量追従式。
- SoundSync_Cumulative：トラックバーの音声同期設定用です。音声波形から特定周波数の音量情報をトラックバーへ飛ばします。音量加算ループ式。
- StereoImager：音の広がりを可視化します。
- PlayBar：オブジェクトの長さに応じて再生バーを表示します。
- PlayTime：オブジェクトの長さに応じて再生時間を表示します。
- TimeSignature：BPMと拍数を入力すると拍数が表示されます。
- MIDI_Visualizer：MIDIを読み込み、ノーツを表示します。
- MIDI_Visualizer_2：MIDIを読み込み、ノーツを表示します。
- MIDI_ChordTone：MIDIを読み込み、音階を表示します。
- MIDI_ChordDetectionMIDIを読み込み、コードを自動判定し表示します。
### @DTMer Starter Kit.anm2
- BitterDance：FL Studio の Fruity Dance の様なものです。
### @DTMer Starter Kit.tra2
- SoundSync_Live：カスタムオブジェクト側で設定した情報からトラックバーの動きを音声同期させます。
- SoundSync_Cumulative：カスタムオブジェクト側で設定した情報からトラックバーの動きを音声同期させます。
### MIDI_for_AviUtl.lua
- MIDI系スクリプト用です。MIDIを読み込み、ノーツデータを取得する用のファイルです。
### chord_config.lua
- コード判定用のデータです。判定するコード内容を追加・削除が可能です。


## 規約的な何か
- 感染性ライセンスが嫌いなので、特定のライセンスは設けていません。
- Script使用した動画の親登録は任意です。親登録通知が来た動画は全て見に行ってますが、しなくてもOKです。
- 私が配布先を全て削除し、失踪した場合は再配布を認めます。
- フォーク版の作成を認めます。条件は以下の通りです。以下の条件が守られている場合、事前連絡は無くても構いません。
  - ファイル名は元となった Script と被らない様にお願い致します。被らなければファイル名は自由です。もし名前を引き継ぐ場合は『@DTMer Starter Kit_by〇〇フォーク版.obj2』の様に完全一致にならない様にしてください。
  - ニコニコ動画への投稿を必須とします。その際、私が把握するため親登録をお願いします。クリエイター奨励プログラムはして頂いて構いません(親登録によってクリ奨の収益が減ることはありません)。
  - Youtube への投稿は任意です。投稿の際に動画説明欄にて『@Amai_28ftb』とメンションして頂けると通知が届くので、視聴させて頂きます。こちらも同様に収益化して頂いて構いません。
  - その他 SNS への投稿は自由です。リプで『@Amai_28ftb』とメンションして頂くか、DM を頂ければ RT させて頂きます。こちらも同様に収益化して頂いて構いません。
  - 動画説明欄、もしくはチャンネルの概要欄からSNSへ飛べるリンクの記載をお願いします。何かあったらこちらから連絡をする為です。SNSに関してはDMが解放されていない場合、リプで連絡致します。
- 『MIDI_for_AviUtl.lua』と『chord_config.lua』を使用した Script を自由に作成・配布して頂いて構いません。
 - 配布時に『MIDI_for_AviUtl.lua』や『chord_config.lua』を同梱するのはご遠慮ください。アップデートや重複時のエラーを避けるためです。
 - 『MIDI_for_AviUtl.lua』や『chord_config.lua』の中身改変ファイルを同梱したい場合はTwitter(現X)へ連絡をお願い致します。DMが送れない場合は私が一時的にフォロー致しますので、そこからDMをお願いします。
  - 詳しい連絡先は下記をご覧ください。



## 連絡先
- [Twitter(現X)](https://x.com/Amai_28ftb)
- [その他SNS](https://linktr.ee/amai_28ftb)
- [contact](https://forms.gle/j9dP1Lz6hVX8uhpV9)
- 『AviUtl2の情報が知りたいだろって!!』『抹茶鯖』『音声波形の部屋』にも加入していますので、そこから Discord の DM に連絡頂いても構いません。全ての通知を切って放置している為、鯖内でメンションされても気付きません。ご了承ください。


## あとがき
Pull Requestする場合はTwitterかDiscordのDMに一報頂ければ多分通します。
