 function decoder(inputfile, fram_duration_ms)
    wm_seq_len =32;
    [sample, sample_freq] = audioread(inputfile);
    [sample_no,t]=size(sample);
    
    frame_duration_sample = floor( (fram_duration_ms/1000)*sample_freq);
    total_frame_num = floor(sample_no/frame_duration_sample);

    tmp_frame = zeros(1,frame_duration_sample);
    temp_frame_mean = 0;
    frame_Means = zeros(1,total_frame_num);
    
    for i = 1:1:total_frame_num
        l=(i-1)*frame_duration_sample+1;
        h = i*frame_duration_sample;
        tmp_frame = sample(l:h,1);
        temp_frame_mean= mean(tmp_frame);
        frame_Means(1,i) = temp_frame_mean;
        
        if frame_Means(1,i) > 0
            frame_dcd(i) = 0.1;
        else
            frame_dcd(i) = -0.1;
        end
    end
 
    figure
    hold on;
    title('FRAME MEANS &  Decoded Watermark Sequence ');
    xlabel('FRAME NUMBERS');
    ylabel("Means");
    stem(frame_Means(1:32),'g');
    stem(frame_dcd(1:32), 'b');
    legend('frame means','decoded: -0.1 to 0 & 0.1 to 1');
    epoch_num = floor(total_frame_num/wm_seq_len);
    temp = 0;
    wm_sequence= zeros(epoch_num,wm_seq_len);
    
    for i = 1:1:epoch_num
        l = (i-1)*wm_seq_len + 1;
        h = i*wm_seq_len;
        
        for j = l:1:h
            temp = j - ((i - 1)*wm_seq_len);
            if(frame_Means(1,j) < 0)
                wm_sequence(i,temp) = 0;
            elseif(frame_Means(1,j) > 0)
                wm_sequence(i,temp) = 1;
            end
        end
    end
    
    save wmRead wm_sequence


    
%end