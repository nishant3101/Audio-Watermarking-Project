function filtering(inFile, outfile)
[s, r] = audioread(inFile);
[N,Wn] = cheb1ord( 0.005, 0.0001, 0.1, 40);
[num, den] = cheby1(N,.1,Wn,'high');
freqz(num, den); title('freq response');
y = filter( num, den, s );
pause;
soundsc( y,r );
audiowrite(outfile,y,r );
