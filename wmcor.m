function correlator(keyChar)
wm_seq = wmseq(keyChar);
load wmRead;
size_wmSequenceRead = size(wmSequenceRead);
wmSequenceRead_vec = [];
% concat the watermarked sequence into a vector.
for i=1:size_wmSequenceRead(1)
    wmSequenceRead_vec = [wmSequenceRead_vec, wmSequenceRead(i,:) ];
end
n1 = length(wm_seq)-1;
n2 = length(wmSequenceRead_vec)-1;
% calculate the cross correlation
r = conv(wmSequenceRead_vec,fliplr(wm_seq));
k = (-n1):n2';
sorted_r = sort(r);
max_matches = floor(length(wmSequenceRead_vec)/length(wm_seq));
len_r = length(sorted_r);
largest_r = sorted_r( len_r - max_matches + 1: len_r );
mean_largest_r = mean(largest_r);
s = 0;
for i = 1:length(wm_seq)
     s = s + wm_seq(i);
end;
if( mean_largest_r > s*.9 )
    display('Watermark is PRESENT!');
else
    display('Watermark is NOT PRESENT!');
end;
figure;
hold on;
stem(k,r,'b');
plot(k,(s*.8), 'r');
xlabel('lag index');ylabel('Amplitude');
v = axis;
axis([-n1 n2 v(3:end)]);
hold off;