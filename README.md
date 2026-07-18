## 紹介動画
https://www.nicovideo.jp/watch/sm45949170


## 確認事項
私の配布してる Aviutl / Aviutl2 の Script に関しては、紹介動画さえ親登録してくれれば事前・事後報告無しで勝手にフォーク版作って貰って構わないので、誰か軽量化とか機能追加とかしてください。
必須事項はニコニコ動画への投稿と、親登録です。クリ奨OKです。

## 注意事項
- 私の書いたコードが各方面から怒られるレベルであまりにも汚すぎたのと、冗長な処理が多すぎて動作がかなり重かったので、可読性を高める為&処理の簡略化の為、AIにリファクタを手伝って貰っています。使用前にご了承ください。
- GitHub Copilotが提案するコードは著作権的にクリーンのはずですが、万が一問題がありましたら連絡ください。該当箇所を修正します。
- 現在はβ版ですので、バグや不具合が多いと思いますがご了承ください。

## 使用方法
- 詳細は以下の URL から Notion をご覧ください。
- https://app.notion.com/p/DTMerStarterKit-Wiki-AviUtl2-300bea655f64804d975fea11976ad85c

## 内容物
# @DTMer Starter Kit.obj2
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
# @DTMer Starter Kit.anm2
- BitterDance：FL Studio の Fruity Dance の様なものです。
# @DTMer Starter Kit.tra2
- SoundSync_Live：カスタムオブジェクト側で設定した情報からトラックバーの動きを音声同期させます。
- SoundSync_Cumulative：カスタムオブジェクト側で設定した情報からトラックバーの動きを音声同期させます。
# MIDI_for_AviUtl.lua
- MIDI系スクリプト用です。MIDIを読み込み、ノーツデータを取得する用のファイルです。
# chord_config.lua
- コード判定用のデータです。判定するコード内容を追加・削除が可能です。
