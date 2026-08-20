--[[
    MIDI ファイルを読み込み、ノート情報を取得します。

    感染性ライセンスは適用されません。
    そのため、自由に改変・再配布を行って頂いて構いません。
    ニコニコ動画でScript配布を行う場合は可能な限り『親登録』をお願いします。親登録通知で見に行きます。
    Script を使用して作成した動画については特に制限はありません。ご自由に投稿してください。

    改変を行う場合は AviUtl2 の Script 同様、UTF-8 で保存しないと文字化けします。


    AviUtl の Script に渡すデータ
    > midi_data:load(file_path)
        指定した MIDI ファイルを読み込み、midi_data オブジェクトを返します。
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
    > midi_data:note_name(note_num)
        指定した音番号 (0-127) に対応する音名を返します。
    例: 60 -> "C4", 61 -> "C#4", 62 -> "D4"
]]

local MIDI = {}

-- MIDIフォーマット定数
local MIDI_CONSTANTS = {
    -- チャンクタイプ
    CHUNK_HEADER = "MThd",
    CHUNK_TRACK = "MTrk",
    
    -- MIDIメッセージタイプ
    NOTE_OFF = 0x80,           -- ノートオフ
    NOTE_ON = 0x90,            -- ノートオン
    POLY_AFTERTOUCH = 0xA0,    -- ポリフォニックアフタータッチ
    CONTROL_CHANGE = 0xB0,     -- コントロールチェンジ
    PROGRAM_CHANGE = 0xC0,     -- プログラムチェンジ
    CHANNEL_AFTERTOUCH = 0xD0, -- チャンネルアフタータッチ
    PITCH_BEND = 0xE0,         -- ピッチベンド
    SYSTEM_EXCLUSIVE = 0xF0,   -- システムエクスクルーシブ
    META_EVENT = 0xFF,         -- メタイベント
    
    -- メタイベントタイプ
    META_TEMPO = 0x51,         -- テンポ設定
    
    -- その他
    RUNNING_STATUS_THRESHOLD = 0x80,
    VLQ_MAX_BYTES = 4,         -- Variable Length Quantityの最大バイト数
    
    -- 音名定義
    NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"},
}


-- MIDIデフォルト値
local MIDI_DEFAULTS = {
    TICKS_PER_QUARTER = 480,      -- 四分音符あたりのTick数
    DEFAULT_TEMPO = 500000,       -- デフォルトテンポ (120 BPM)
    MICROSECONDS_PER_SECOND = 1000000,
}


local function parse_int(bytes, pos, len)
    local parsed_value = 0
    local end_pos = pos + len - 1
    for i = pos, end_pos do
        parsed_value = parsed_value * 256 + bytes:byte(i)
    end
    return parsed_value
end


local function read_varlen(file)
    local parsed_value = 0
    for byte_index = 1, MIDI_CONSTANTS.VLQ_MAX_BYTES do
        local byte_data = file:read(1)
        if not byte_data then return nil end
        local byte_value = byte_data:byte()
        parsed_value = (parsed_value * 128) + (byte_value % 128)
        -- 最上位bitが0なら終了
        if byte_value < 128 then break end
    end
    return parsed_value
end


local function read_midi_header(file)
    local header_chunk = file:read(8)
    if not header_chunk or header_chunk:sub(1, 4) ~= MIDI_CONSTANTS.CHUNK_HEADER then
        return nil
    end
    
    local header_data = file:read(parse_int(header_chunk, 5, 4))
    local tick_quarter = parse_int(header_data, 5, 2)
    local track_count = parse_int(header_data, 3, 2)
    
    return tick_quarter, track_count
end


local function process_note_on(file, current_tick, active_notes, midi_data, track_index)
    local note_num = file:read(1):byte()
    local velocity = file:read(1):byte()
    
    if velocity > 0 then
        -- ベロシティが0より大きい場合はノートオン
        active_notes[note_num] = current_tick
    elseif active_notes[note_num] then
        -- ベロシティが0の場合はノートオフとして扱う
        table.insert(midi_data.notes, {
            track = track_index,
            note = note_num,
            start_tick = active_notes[note_num],
            end_tick = current_tick
        })
        active_notes[note_num] = nil
    end
end


local function process_note_off(file, current_tick, active_notes, midi_data, track_index)
    local note_num = file:read(1):byte()
    file:read(1)  -- ベロシティを読み飛ばし
    
    if active_notes[note_num] then
        table.insert(midi_data.notes, {
            track = track_index,
            note = note_num,
            start_tick = active_notes[note_num],
            end_tick = current_tick
        })
        active_notes[note_num] = nil
    end
end


local function process_meta_event(file, current_tick, midi_data)
    local meta_type = file:read(1):byte()
    local meta_length = read_varlen(file)
    
    if meta_type == MIDI_CONSTANTS.META_TEMPO and meta_length >= 3 then
        -- テンポ変更イベント
        local tempo_data = file:read(meta_length)
        table.insert(midi_data.tempos, {
            tick = current_tick,
            microsec = parse_int(tempo_data, 1, 3)
        })
    else
        -- その他のメタイベントは読み飛ばし
        file:read(meta_length)
    end
end


function MIDI.load(file_path)
    local file = io.open(file_path, "rb")
    if not file then return nil end
    
    local midi_data = {
        tick_quarter = MIDI_DEFAULTS.TICKS_PER_QUARTER,
        tempos = {{tick = 0, microsec = MIDI_DEFAULTS.DEFAULT_TEMPO}},
        notes = {}
    }

    local tick_quarter, track_count = read_midi_header(file)
    if not tick_quarter then
        file:close()
        return nil
    end
    midi_data.tick_quarter = tick_quarter

    for track_index = 1, track_count do
        local chunk_header = file:read(8)
        if not chunk_header or chunk_header:sub(1, 4) ~= MIDI_CONSTANTS.CHUNK_TRACK then
            break
        end
        
        local chunk_size = parse_int(chunk_header, 5, 4)
        local chunk_start = file:seek()
        local current_tick = 0
        local running_status = 0
        local active_notes = {}

        while file:seek() - chunk_start < chunk_size do
            local delta_time = read_varlen(file)
            if not delta_time then break end
            current_tick = current_tick + delta_time

            local status_byte = file:read(1)
            if not status_byte then break end
            local status = status_byte:byte()
            
            if status < MIDI_CONSTANTS.RUNNING_STATUS_THRESHOLD then
                file:seek("cur", -1)  -- 読み戻し
                status = running_status
            else
                running_status = status
            end
            
            local message_type = math.floor(status / 16) * 16

            if message_type == MIDI_CONSTANTS.NOTE_ON then
                process_note_on(file, current_tick, active_notes, midi_data, track_index)
            elseif message_type == MIDI_CONSTANTS.NOTE_OFF then
                process_note_off(file, current_tick, active_notes, midi_data, track_index)
            elseif message_type == MIDI_CONSTANTS.POLY_AFTERTOUCH or
                message_type == MIDI_CONSTANTS.CONTROL_CHANGE or
                message_type == MIDI_CONSTANTS.PITCH_BEND then
                file:read(2)
            elseif message_type == MIDI_CONSTANTS.PROGRAM_CHANGE or
                message_type == MIDI_CONSTANTS.CHANNEL_AFTERTOUCH then
                file:read(1)
            elseif status == MIDI_CONSTANTS.META_EVENT then
                process_meta_event(file, current_tick, midi_data)
            elseif status == MIDI_CONSTANTS.SYSTEM_EXCLUSIVE or status == 0xF7 then
                file:read(read_varlen(file))
            end
        end
        
        for note_num, start_tick in pairs(active_notes) do
            table.insert(midi_data.notes, {
                track = track_index,
                note = note_num,
                start_tick = start_tick,
                end_tick = current_tick
            })
        end
    end
    
    file:close()
    

    local function tick_to_time(target_tick)
        local current_time = 0
        local previous_tick = 0
        local previous_tempo = midi_data.tempos[1].microsec
        
        for _, tempo in ipairs(midi_data.tempos) do
            if tempo.tick > target_tick then break end
            if tempo.tick > previous_tick then
                current_time = current_time + 
                    (tempo.tick - previous_tick) * previous_tempo / 
                    midi_data.tick_quarter / MIDI_DEFAULTS.MICROSECONDS_PER_SECOND
            end
            previous_tick = tempo.tick
            previous_tempo = tempo.microsec
        end
        if target_tick > previous_tick then
            current_time = current_time + 
                (target_tick - previous_tick) * previous_tempo / 
                midi_data.tick_quarter / MIDI_DEFAULTS.MICROSECONDS_PER_SECOND
        end
        
        return current_time
    end
    
    function midi_data:TimeToTick(target_time)
        local previous_tick = 0
        local previous_tempo = self.tempos[1].microsec
        local accumulated_time = 0

        for _, tempo in ipairs(self.tempos) do
            local next_time = accumulated_time +
                (tempo.tick - previous_tick) * previous_tempo /
                self.tick_quarter / MIDI_DEFAULTS.MICROSECONDS_PER_SECOND

            if next_time > target_time then
                return previous_tick +
                    (target_time - accumulated_time) * self.tick_quarter *
                    MIDI_DEFAULTS.MICROSECONDS_PER_SECOND / previous_tempo
            end

            accumulated_time = next_time
            previous_tick = tempo.tick
            previous_tempo = tempo.microsec
        end
        
        return previous_tick + 
            (target_time - accumulated_time) * self.tick_quarter * 
            MIDI_DEFAULTS.MICROSECONDS_PER_SECOND / previous_tempo
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
                    startTime = tick_to_time(note_info.start_tick),
                    endTime = tick_to_time(note_info.end_tick)
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
        return MIDI_CONSTANTS.NOTE_NAMES[note_index] .. octave
    end
    
    return midi_data
end

return MIDI
