function fftt(wav_file1, wav_file2)
[f1, r1] = audioread(file1);
[f2, r2] = audioread(file2);
fft_f1 = fft(f1);
fft_f2 = fft(f2);
figure;
hold on;
plot(abs(fft_f2), 'red');
plot(abs(fft_f1), 'blue');
axis([ 0 30000 0 3000 ]);

