## 紹介動画
動画を見ればどんなスクリプトか一発で分かります。基本的に音声波形、ステレオイメージャー、MIDI表示、音声同期がメインです。
一部 [AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor) が無いと動かない機能があります。
[ニコニコ動画](https://www.nicovideo.jp/watch/sm45949170)


## 配布先について
- [Notion](https://app.notion.com/p/AviUtl-Script-178bea655f6480208a75fc94e60244ad)：一番更新が早いです
- [BOOTH](https://amai-28ftb.booth.pm/items/7986564)：支援用です。無料DLも可能です。
- [Github](https://github.com/Amai-28ftb/DTMer-Starter-Kit-for-AviUtl2)：多分ここです。


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
- TimeSignature：BPMと拍数を入力すると拍数が表示されます。MIDI ファイルを読み込むと MIDI から拍子とBPMを取得します。
- MIDI_Visualizer：MIDI を読み込み、ノーツを表示します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@Easing Receptor』と連携があります。
- MIDI_Visualizer_2：MIDI を読み込み、ノーツを表示します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@Easing Receptor』と連携があります。
- MIDI_ChordTone：MIDI を読み込み、音階を表示します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@Easing Receptor』と連携があります。
- MIDI_ChordDetection：MIDI を読み込み、コードを自動判定し表示します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@Easing Receptor』と連携があります。
### @DTMer Starter Kit.anm2
- BitterDance：FL Studio の Fruity Dance の様なものです。
- MIDI_NoteSync：MIDIを読み込み、ノーツの位置にオブジェクトを描画します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@Easing Receptor』と連携があります。
### @DTMer Starter Kit.tra2
- SoundSync_Live：カスタムオブジェクト側で設定した情報からトラックバーの動きを音声同期させます。
- SoundSync_Cumulative：カスタムオブジェクト側で設定した情報からトラックバーの動きを音声同期させます。
- BPM_Sync：BPM 同期します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@Easing Receptor』と連携があります。
- MIDI_NoteTrigger：MIDI をトリガーにしてトラックバーの範囲で値が変化します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@MIDI Receptor』が必須です。
- MIDI_Sync(Low)：MIDI のノーツと同期します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@MIDI Receptor』が必須です。
- MIDI_Sync(High)：MIDI のノーツと同期します。[AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@MIDI Receptor』が必須です。
### MIDI_for_AviUtl.lua
- MIDI系スクリプト用です。MIDIを読み込み、ノーツデータを取得する用のファイルです。
- DTMer Starter Kit の MIDI系 Script を動作させるのに必須です。
- [AUL Receptor](https://a2cw.sevenc7c.com/package/Amai_28ftb.AULReceptor)の『@MIDI Receptor』を動作させるのに必須です。
### chord_config.lua
- コード判定用のデータです。判定するコード内容を追加・削除が可能です。
- MIDI_ChordDetection の動作に必須です。


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
  - 「報連相メッセージを送るならフォローしなきゃいけないかな？」って尻込みしなくても良いです。FF外からも常時受け付けています。
  - DM で連絡を取りたい際は一時的にフォローして頂き、こちらから DM へメッセージを送りますので、やり取りが終わりましたら解除して頂いて構いません。
- [Twitter(現X)](https://x.com/Karai_18hth)
  - 進捗とかどうでもいいツイート垂れ流してます。本垢に送るのが怖ければこっちにリプライを飛ばしてください。
  - たまに鍵かけてますが、返信対応する時は鍵外すので遠慮せずに送ってください。フォローをする必要ありません。どうしてもフォローするなら本垢をフォローしてください。
- [その他SNS](https://linktr.ee/amai_28ftb)
  - Twitterやってねぇよという人は他の連絡手段を探してください。Twitter か Discord の DM が一番反応早いです。他は気づいたら返してます。
- [contact](https://forms.gle/j9dP1Lz6hVX8uhpV9)
  - 匿名で送りたい場合はこちらへどうぞ。非匿名でも受け付けています。要するにましゅまろ。気付くの遅くなったらごめんなさい。
- Discord
  - 各鯖に加入していますので、そこから Discord の DM に連絡頂いても構いません。
  - 基本的に @everyone と @here のを含め、通知を切って放置している為、基本的に気付きません。ご了承ください。甘井ふたば 宛にメンションを頂ければ何かしらのリアクションはすると思います。
  - 加入鯖
    - AviUtl / 映像制作関連：『AviUtl2の情報が知りたいだろって!!』『抹茶鯖』『音声波形の部屋』『NCS Script 購入者限定サーバー』『えぶりでいすし』
    - ボイロ / ボイボ関連：『ずんだもん非公式雑談サーバー』『ずんらぶ帝国』『ウナちゃんを推していけ！！』『響立うなうな学院』『ぷゆらぼ！』


## あとがき
Pull Requestする場合はTwitterかDiscordのDMに一報頂ければ多分通します。
