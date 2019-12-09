function [s]=correlator1( keyChar )
wm_seq = keytobits(keyChar);
load wmRead;
size_wm_sequence = size(wm_sequence);
wm_sequence_vec = [];
% concat the watermarked sequence into a vector.
for i=1:size_wm_sequence(1)
    wm_sequence_vec = [ wm_sequence_vec, wm_sequence(i,:) ];
end;
n1 = length(wm_seq)-1;
n2 = length(wm_sequence_vec)-1;
% calculate the cross correlation
r = conv(wm_sequence_vec,fliplr(wm_seq));
k = (-n1):n2';
sorted_r = sort(r);
max_matches = floor(length(wm_sequence_vec)/length(wm_seq));
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
mat=zeros(length(k));
for i=1:length(k)
    mat(i)=s*.9;
end

figure;
hold on;
plot(k,mat, 'r');
stem(k,r,'b'); title('correlation');
xlabel('lag index');ylabel('Amplitude');
v = axis;
axis([-n1 n2 v(3:end)]);
hold off;
disp(s);