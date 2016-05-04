number=19
% csi_trace = read_bf_file(strcat('~/workspace/GestFi/right/home',int2str(number)));
csi_trace = read_bf_file('~/workspace/GestFi/test');
n=2000
ampl2=zeros(1,30);
rss2=zeros(1,10);
for i=1:n
    ampl2(i,1:1:30)=abs(csi_trace{i}.csi(2,3,1:1:30));
%     rss2(i)=csi_trace{i}.rssi_a;
end

freq=(fft(ampl2));
% figure
% plot(abs(freq),'r')
mag=abs(freq);
num_bins=length(mag);
figure
% plot([0:1/(num_bins/2-1):1],abs(freq(1:num_bins/2))/max(freq),'g');
[b,a]=butter(20,0.15);
%plot the frequency response (normalised frequency)
% H = freqz(b,a, floor(num_bins/2));
% hold on
% plot([0:1/(num_bins/2 -1):1], abs(H),'r');
%  plot([0:1/(num_bins/2-1):1],abs(H),'r');
filt=filter(b,a,ampl2);
% file=fopen(strcat('ampl',int2str(number)),'w');
% for i=1:30
%     for j=1:length(ampl2)
%         fprintf(file,'%f ',ampl2(j,i));
%     end
%         fprintf(file,'\n');
% end
% fclose(file);
% figure
plot(filt)
axis([0 inf 0 inf])
% hold on
% plot(filt)
% title('after low pass')
