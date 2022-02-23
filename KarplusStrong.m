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
fvtool(b,1,'OverlayedAnalysis','phase')
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
%zi = lowpass(zi,50,Fs,'ImpulseResponse','iir','Steepness',0.95);
note = filter(b, a, x,zi);
note = note-mean(note);
note = note/max(abs(note));

zi1 = rand(max(length(b1),length(a1))-1,1);
%zi1 = lowpass(zi1,50,Fs,'ImpulseResponse','iir','Steepness',0.95);
note1 = filter(b1, a1, x,zi1);
note1 = note1-mean(note1);
note1 = note1/max(abs(note1));

zi2 = rand(max(length(b2),length(a2))-1,1);
%zi2 = lowpass(zi2,50,Fs,'ImpulseResponse','iir','Steepness',0.95);
note2 = filter(b2, a2, x,zi2);
note2 = note2-mean(note2);
note2 = note2/max(abs(note2));

output = (note + note2 + note1)./3;
output = lowpass(output, 1000, Fs,'ImpulseResponse','iir','Steepness',0.5);
sound(output,Fs);
end