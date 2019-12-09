clear all;
clc;
%function wmdec(inFile, frameDurationMs)
% read the file
inFile='beatles_enc.wav';
frameDurationMs=25;
[inVector, sampleFreq] = audioread(inFile);
sizeIn = size(inVector);
sampleNo = sizeIn(1,1);
wmSeqLength = 32;         % watermark sequence length in bits
frameDurationSample = floor( (frameDurationMs/1000)*sampleFreq ) ; %this many values in one sample 
totalFrameNo = floor(sampleNo/frameDurationSample);  % total frame number in given audio sample
tempFrame = zeros(1, frameDurationSample);   % initialization temp one frame.
tempFrameMean = 0;  % initialization
frameMeans = zeros(1, totalFrameNo);  % contains frame means of every frame.
for frameIndex = 1:1:totalFrameNo   % frame means are calculated
   lowIndex = (frameIndex-1)*frameDurationSample + 1;
   highIndex = frameIndex*frameDurationSample;
   tempFrame = inVector( lowIndex:highIndex , 1);
   tempFrameMean = mean( tempFrame);
   frameMeans(1, frameIndex) = tempFrameMean; 
   if frameMeans(1,frameIndex) > 0
       framespm(frameIndex) = .1;
   else
       framespm(frameIndex) = -.1;
   end
   
end
figure    % frame means displayed
hold on;
stem(framespm(1:32),'r');
stem(frameMeans(1:32), 'b');
%axis([1 totalFrameNo -0.5 0.5]);
title('Frame means');
xlabel('Frame numbers');
ylabel('Means');
epochNo = floor(totalFrameNo/wmSeqLength);    % this many times the watermark has been encoded into the full audio sample 
wmSample = 0;   % initialization
wmSequenceRead = zeros(epochNo, wmSeqLength);   % initialization
for epochIndex = 1:1:epochNo    % watermark decoding 
   frameLow = (epochIndex - 1)*wmSeqLength + 1;
   frameHigh = epochIndex*wmSeqLength; 
   for frameIndex = frameLow:1:frameHigh
      wmSample = frameIndex - ( (epochIndex - 1)*wmSeqLength);
      if( frameMeans(1, frameIndex) < 0 )  % bit reading from individual frames
         wmSequenceRead(epochIndex, wmSample) = 0;    
      elseif( frameMeans(1, frameIndex) > 0 )
         wmSequenceRead(epochIndex, wmSample) = 1; 
      end   
      
   end  % for frameIndex...        
   
end  % for epochIndex... 
save wmRead wmSequenceRead   % saving decoded watermark sequences