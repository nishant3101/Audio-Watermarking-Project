%Audio Watermarking using DC level Shifting
%Khalid Lodhi-2017160
%Nishant Kumar- 2017171
%%
clear all,
close all,
key='paul';
biasmultiplier=0.5;
inputfile='beatles.wav';
frameduration=25;
output=[];
%%
[input,output]=encoder(key,inputfile,frameduration,biasmultiplier);
%soundsc(input,sampleFreq);
%pause(8);
%soundsc(output, sampleFreq);
decoder('beatles_enc.wav',frameduration);
%title('low frequencies is the codeword encoded');
%title('Correlation with correct keyword');
filtering('beatles_enc.wav','beatles_filtered.wav');
%fftt('beatles_enc.wav','beatles_filtered.wav');
%title('Watermark removed');
[s]=correlator1('paul');
pause(5);
[s]=correlator1('wxyz');
fftt('beatles.wav','beatles_enc.wav'); title('low frequencies is the codeword encoded'); 
pause;
fftt('beatles_enc.wav','beatles_filtered.wav'); title('After filtering'); 











