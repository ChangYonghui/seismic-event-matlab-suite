
clear,clc

Fs = 200;                          %Sampling Frequency (Hz)
Ny_Fs = Fs/2;                      %Nyquist Frequency
Norm_freq_range = [0,.6];           %Normalized Frequency range to plot
F_range = Norm_freq_range*Ny_Fs;   %Frequency range to plot
dt = 1/Fs;                         %Sample Time

F_c = 10; %Hz
F_m = 2; %Hz


t = (1:500)*dt;       %Time vector
L = max(length(t));   %Length of time vector
I = 2*pi*F_c/15;       %Modulation Index

%y = sin(2*pi*F_c*t + I*sin(2*pi*F_m*t)).*exp(.3*t);
y = sin(2*pi*F_c*t + I*sin(2*pi*F_m*t)).*sin(t/5*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imf = eemd(y,0,1);
start_imf = 1;
end_imf = 8;
imf_numbers = (start_imf : end_imf);  %Array of IMF numbers
imf_sub = imf(:,imf_numbers);         %Array of IMF subset to be plotted
H = hilbert(imf_sub);  

omega = unwrap(angle(H));
dwdt = (diff(omega));       %Radians/sec  
dwdt(L,:) = dwdt(L-1,:);

Inst_Freq_Hz = abs(dwdt/(2*pi)*Fs);
Inst_Amplitude = abs(H);

[im,tt] = toimage(Inst_Amplitude',Inst_Freq_Hz'/(2*F_range(2)),t);

Smooth_g = 10*gausswin(10);
im = conv2(im, Smooth_g);
im = im';
im = conv2(im, Smooth_g);
im = im';

M=max(max(im));
warning off
im = 10*log10(im/M);
warning on

figure

subplot(3,1,1)
plot(t,y)
title('Signal')

subplot(3,1,2)
[SS,FF,TT]=spectrogram(y,40,30,.1:.1:F_range(2),Fs);
SS = abs(SS);
imagesc(t,F_range,SS);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title('Windowed Fourier Spectrum')

subplot(3,1,3)
inf = -20;
imagesc(t,F_range,im,[inf,0]);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
xlabel('Time (s)')
title('Hilbert Spectrum')


                                           






