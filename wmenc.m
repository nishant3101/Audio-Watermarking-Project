function encoder(key,inputfile,frameduration,biasmultiplier)
bitsperbyte = 8;
nc = length(key);
y = zeros(1,nc*bitsperbyte);
for i = 1:nc
  v = real(key(i));
  b = 1;
  for j = 1:bitsperbyte
    y(bitsperbyte*(i-1)+j) = rem(floor(v/b),2);
    b = 2*b;
  end
end
% read input file
[input, sampleFreq] = audioread(inputfile);
sizeIn = size(input);
inputsize = sizeIn(1,1);
% generate watermark sequence
wmSequence = y
wmSeqLength = length(wmSequence);
% calculate frame means
samplesinoneframe = floor( (frameduration/1000)*sampleFreq ) ;
totalframes = floor(inputsize/samplesinoneframe);    % total frame number in given audio sample calculated
dczeroinput = zeros(inputsize,1);   % initialization
tempFrame = zeros(1, samplesinoneframe);%initialization
tempFramePower = 0;  % temporary frame power
framePowers = zeros(1, totalframes);   % initialization
for frameIndex = 1:1:totalframes    % frame powers and frame means are calculated
   lowIndex = (frameIndex-1)*samplesinoneframe + 1;
   highIndex = frameIndex*samplesinoneframe;
   tempFrame = input(lowIndex:highIndex ,1);
   dczeroinput(lowIndex:highIndex, 1) = tempFrame - mean(tempFrame);
   framePowers(1, frameIndex) =  mean(tempFrame.^2);
end
for si = 1:1:inputsize  % clipping
   if( dczeroinput(si,1) < -1 )
      dczeroinput(si,1) = -1;
   elseif( dczeroinput(si,1) > 1 )
      dczeroinput(si,1) = 1;
   end   
end   
times = floor(totalframes/wmSeqLength);   % the number of watermark data writing onto host audio
output = zeros(inputsize, 1);
wmSample = 0;  
for index = 1:1:times    % watermarking 
   lowFrameIndex = (index - 1) * wmSeqLength + 1;
   highFrameIndex = index * wmSeqLength;
   for frameIndex = lowFrameIndex:1:highFrameIndex
       lowIndex = (frameIndex-1)*samplesinoneframe + 1;   % finding indexes
       highIndex = frameIndex*samplesinoneframe;
       wmSample = frameIndex-((index-1)*wmSeqLength);
       if(wmSequence(1, wmSample) == 1)  % embedding bits
          output(lowIndex:highIndex, 1) = dczeroinput(lowIndex:highIndex ,1) + ( biasmultiplier*framePowers(1, frameIndex) )  ;
       elseif(wmSequence(1, wmSample) == 0)
          output(lowIndex:highIndex, 1) = dczeroinput(lowIndex:highIndex ,1) - ( biasmultiplier*framePowers(1, frameIndex) )  ;
       end   
      
   end  % for frameIndex... 
      
end  % for index... 
for si = 1:1:inputsize    % clipping
   if( output(si,1) < -1 )
      output(si,1) = -1;
   elseif( output(si,1) > 1 )
      output(si,1) = 1;
   end   
end   
figure     % displaying watermarked waveform
hold on;
plot(output, 'r'); % display watermarked verison in red
plot(input, 'b'); % show original version in blue
title('Audio Waveforms');
xlabel('Sample index');
ylabel('Magnitude');
disp('Watermarked signal');  % sounding watermarked waveform
%soundsc(input,sampleFreq);
%pause(8);
%soundsc(output, sampleFreq);  
audiowrite('beatles_enc.wav',output, sampleFreq);     % saving watermarked waveform
