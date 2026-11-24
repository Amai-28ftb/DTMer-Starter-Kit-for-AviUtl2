--[[
    MIDI ファイルを読み込み、ノート情報を取得します。

    感染性ライセンスは適用されません。
    そのため、自由に改変・再配布を行って頂いて構いません。
    ニコニコ動画でScript配布を行う場合は可能な限り『親登録』をお願いします。親登録通知で見に行きます。
    Script を使用して作成した動画については特に制限はありません。ご自由に投稿してください。

    改変を行う場合は AviUtl2 の Script 同様、UTF-8 で保存しないと文字化けします。

    実体は MIDI_module(DLL) に移行しました。このファイルはそれを呼び出す薄いラッパーです。
    （日本語等を含むパスを開けないことがあったため、dll化しました。公開APIは変更していません。）


    AviUtl の Script に渡すデータ
    > MIDI.load(midi_module, file_path)
        指定した MIDI ファイルを読み込み、midi_data オブジェクトを返します。
        midi_module は呼び出し元の @obj2/@anm2 側で obj.module("MIDI_module") して渡してください。
        読み込みに失敗した場合は nil を返します。
    > midi_data:TimeToTick(target_time)
        指定した時間 (秒) に対応する Tick 値を返します
    > midi_data:GetAllNotes(track_no)
        MIDI ファイル内の全ノート情報をテーブル形式で返します。
        track_no を指定した場合は、そのトラック番号のノートのみ返します。
        返されるノート情報の各要素は以下の通りです。
        {
            track = トラック番号 (1始まり),
            note = 音番号 (0-127),
            start_tick = ノートオンの Tick 値,
            end_tick = ノートオフの Tick 値,
            startTime = ノートオンの時間 (秒),
            endTime = ノートオフの時間 (秒)
        }
    > midi_data:GetActiveNotes(target_time)
        指定した時間 (秒) において鳴っているノート情報をテーブル形式で返します。
        返されるノート情報の各要素は以下の通りです。
        {
            track = トラック番号 (1始まり),
            note = 音番号 (0-127),
            note_name = 音名 (例: C4, D#5)
        }
    > midi_data:GetBarStarts()
        拍子変更を反映した各小節の開始 Tick 値の一覧をテーブル形式で返します。(1始まり、bar_starts[1] = 0)
    > midi_data:GetBeatStarts()
        拍子(分母)変更を反映した各拍の開始 Tick 値の一覧をテーブル形式で返します。(1始まり、beat_starts[1] = 0)
    > midi_data:note_name(note_num)
        指定した音番号 (0-127) に対応する音名を返します。
    例: 60 -> "C4", 61 -> "C#4", 62 -> "D4"
]]

local MIDI = {}

-- 音名定義
local NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}


-- midi_module: obj.module("MIDI_module") を呼び出し元(各@obj2/@anm2)で読み込んで渡してください
function MIDI.load(midi_module, file_path)
    -- midi_parseはフラット配列1本を返す（DLL側の戻り値は常に1個というDEK_module系の流儀に合わせている）。
    -- 先頭5要素がヘッダ { tick_quarter, max_tick, note_count, tempo_count, timesig_count }
    local ok, flat = pcall(midi_module.midi_parse, file_path)
    if not ok or not flat then return nil end

    local tick_quarter = flat[1]
    local max_tick = flat[2]
    local note_count = flat[3]
    local tempo_count = flat[4]
    local timesig_count = flat[5]

    local pos = 5
    local notes = {}
    for i = 1, note_count do
        notes[i] = {
            track = flat[pos + 1],
            note = flat[pos + 2],
            start_tick = flat[pos + 3],
            end_tick = flat[pos + 4],
        }
        pos = pos + 4
    end

    -- テンポ・拍子は、DLLに渡す時はフラット配列のまま使うが、
    -- 旧バージョン(Lua実装)と同じ公開フィールド(tempos/timesigs)も復元しておく
    local tempo_flat = {}
    local tempos = {}
    for i = 1, tempo_count do
        local tick = flat[pos + (i - 1) * 2 + 1]
        local microsec = flat[pos + (i - 1) * 2 + 2]
        tempo_flat[(i - 1) * 2 + 1] = tick
        tempo_flat[(i - 1) * 2 + 2] = microsec
        tempos[i] = { tick = tick, microsec = microsec }
    end
    pos = pos + tempo_count * 2

    local timesig_flat = {}
    local timesigs = {}
    for i = 1, timesig_count do
        local tick = flat[pos + (i - 1) * 3 + 1]
        local numerator = flat[pos + (i - 1) * 3 + 2]
        local denominator = flat[pos + (i - 1) * 3 + 3]
        timesig_flat[(i - 1) * 3 + 1] = tick
        timesig_flat[(i - 1) * 3 + 2] = numerator
        timesig_flat[(i - 1) * 3 + 3] = denominator
        timesigs[i] = { tick = tick, numerator = numerator, denominator = denominator }
    end

    local midi_data = {
        tick_quarter = tick_quarter,
        max_tick = max_tick,
        notes = notes,
        tempos = tempos,
        timesigs = timesigs,
        _tempo_flat = tempo_flat,
        _timesig_flat = timesig_flat,
    }


    function midi_data:TimeToTick(target_time)
        return midi_module.midi_time_to_tick(target_time, self.tick_quarter, self._tempo_flat)
    end


    local function tick_to_time(self, target_tick)
        return midi_module.midi_tick_to_time(target_tick, self.tick_quarter, self._tempo_flat)
    end


    function midi_data:GetBarStarts()
        -- 拍子変更を反映した小節開始tickの一覧を返す(結果はキャッシュされる)
        if self._bar_starts then return self._bar_starts end
        self._bar_starts = midi_module.midi_bar_starts(self.tick_quarter, self.max_tick, self._timesig_flat)
        return self._bar_starts
    end


    function midi_data:GetBeatStarts()
        -- 拍子変更(分母)を反映した拍開始tickの一覧を返す(結果はキャッシュされる)
        if self._beat_starts then return self._beat_starts end
        self._beat_starts = midi_module.midi_beat_starts(self.tick_quarter, self.max_tick, self._timesig_flat)
        return self._beat_starts
    end


    function midi_data:GetAllNotes(track_no)
        local notes_list = {}
        for _, note_info in ipairs(self.notes) do
            if not track_no or track_no <= 0 or note_info.track == track_no then
                table.insert(notes_list, {
                    track = note_info.track,
                    note = note_info.note,
                    start_tick = note_info.start_tick,
                    end_tick = note_info.end_tick,
                    startTime = tick_to_time(self, note_info.start_tick),
                    endTime = tick_to_time(self, note_info.end_tick)
                })
            end
        end
        return notes_list
    end


    function midi_data:GetActiveNotes(target_time)
        local active_notes_list = {}
        for _, note_info in ipairs(self:GetAllNotes()) do
            if note_info.startTime <= target_time and note_info.endTime > target_time then
                table.insert(active_notes_list, {
                    track = note_info.track,
                    note = note_info.note,
                    note_name = self:note_name(note_info.note)
                })
            end
        end
        -- 音程順にソート
        table.sort(active_notes_list, function(a, b) return a.note < b.note end)
        return active_notes_list
    end


    function midi_data:note_name(note_num)
        local octave = math.floor(note_num / 12 - 1)
        local note_index = (note_num % 12) + 1
        return NOTE_NAMES[note_index] .. octave
    end

    return midi_data
end

return MIDI
