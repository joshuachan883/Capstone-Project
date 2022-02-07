function simplesynth(midiDeviceName)
    
    midiInput = mididevice(midiDeviceName);
    osc = audioOscillator('sine', 'Amplitude', 0);
    deviceWriter = audioDeviceWriter;
    deviceWriter.SupportVariableSizeInput = true;
    deviceWriter.BufferSize = 64; % small buffer keeps MIDI latency low

    while true
        msgs = midireceive(midiInput);
        for i = 1:numel(msgs)
            msg = msgs(i);
            if isNoteOn(msg)
%                 osc.Frequency = note2freq(msg.Note);
%                 osc.Amplitude = msg.Velocity/127;
                  KarplusStrong(note2freq(msg.Note));
            elseif isNoteOff(msg)
                if msg.Note == msg.Note
                    osc.Amplitude = 0;
                end
            end
        end
        deviceWriter(osc());
    end
end

function yes = isNoteOn(msg)
    yes = msg.Type == midimsgtype.NoteOn ...
        && msg.Velocity > 0;
end

function yes = isNoteOff(msg)
    yes = msg.Type == midimsgtype.NoteOff ...
        || (msg.Type == midimsgtype.NoteOn && msg.Velocity == 0);
end

function freq = note2freq(note)
    freqA = 440;
    noteA = 69;
    freq = freqA * 2.^((note-noteA)/12);
end

function output = KarplusStrong(frequency)
Fs       = 44100;
A        = frequency; % The A string of a guitar is normally tuned to 110 Hz
% Eoffset  = -5;
% Doffset  = 5;
% Goffset  = 10;
% Boffset  = 14;
% E2offset = 19;
A1 = frequency * ((nthroot(2, 1200))^(rand * 8));  % 2 cents above
A2 = frequency / ((nthroot(2, 1200))^(rand * 8)); % 2 cents below

F = linspace(1/Fs, 1000, 2^12);

x = zeros(Fs*4, 1);

delay = round(Fs/A);
delay1 = round(Fs/A1);
delay2 = round(Fs/A2);


b  = firls(42, [0 1/delay 2/delay 1], [0 0 1 1]);
a  = [1 zeros(1, delay) -0.5 -0.5];
b1 = firls(42, [0 1/delay1 2/delay1 1], [0 0 1 1]);
a1  = [1 zeros(1, delay1) -0.5 -0.5];
b2 = firls(42, [0 1/delay2 2/delay2 1], [0 0 1 1]);
a2  = [1 zeros(1, delay2) -0.5 -0.5];

% [H,W] = freqz(b, a, F, Fs);
% plot(W, 20*log10(abs(H)));
% title('Harmonics of an open A string');
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');

zi = rand(max(length(b),length(a))-1,1);
note = filter(b, a, x,zi);
note = note-mean(note);
note = note/max(abs(note));

zi1 = rand(max(length(b1),length(a1))-1,1);
note1 = filter(b1, a1, x,zi1);
note1 = note1-mean(note1);
note1 = note1/max(abs(note1));

zi2 = rand(max(length(b2),length(a2))-1,1);
note2 = filter(b2, a2, x,zi2);
note2 = note2-mean(note2);
note2 = note2/max(abs(note2));

output = (note + note2 + note1)./3;
sound(output,Fs);
end