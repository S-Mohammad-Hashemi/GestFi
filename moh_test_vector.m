function a=moh_test_vector()
% csi_trace = read_bf_file(strcat('~/workspace/GestFi/right/home',int2str(number)));
csi_trace = read_bf_file('~/workspace/GestFi/test');
n=5000
ampl2=zeros(1,30);
rss2=zeros(1,10);
for i=1:n
    for j=1:1
        for k=1:3
            aIndex=(j-1)*3+k;
            aIndex=aIndex*10;
            try
    ampl2(i,aIndex-9:1:aIndex)=abs(csi_trace{i}.csi(j,k,1:3:30));
            catch
                ampl2(i,aIndex-2:1:aIndex)=[0 0 0];
%                 disp('errorrrr')
%                 disp(i)
%                 disp(j)
%                 disp(k)
            end
        end
    end
%     rss2(i)=csi_trace{i}.rssi_a;
end

freq=(fft(ampl2));
% figure
% plot(abs(freq),'r')
mag=abs(freq);
num_bins=length(mag);
% figure
% plot([0:1/(num_bins/2-1):1],abs(freq(1:num_bins/2))/max(freq),'g');
[b,a]=butter(20,0.15);
%plot the frequency response (normalised frequency)
% H = freqz(b,a, floor(num_bins/2));
% hold on
% plot([0:1/(num_bins/2 -1):1], abs(H),'r');
%  plot([0:1/(num_bins/2-1):1],abs(H),'r');
filt=filter(b,a,ampl2);
% file=fopen(strcat('ampl',int2str(number)),'w');
a=filt;
% for i=1:27
%     for j=1:length(ampl2)
%         a((i-1)*27+j)=ampl2(j,i);
% %         fprintf(file,'%f ',ampl2(j,i));
%     end
% %         fprintf(file,'\n');
% end
% fclose(file);
% figure
plot(filt)
% axis([0 n 0 50])
% hold on
% plot(filt)
% title('after low pass')
