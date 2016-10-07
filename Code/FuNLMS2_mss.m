%FuNLMS
%Marko Stamenovic
%April 28, 2016

mus = [0.01 0.05 0.1 0.5 1 2];
for j = 1:length(mus)
    for i = 1:100
        %% initialize values
        % generate input signal
        muOG=mus(j); %learning rate
        M=128; %buffer size (num filter weights)
        x=randn(10000,1); %input signal
        x=x/max(x); %sample rate
        fs=8000; %number of samples of the input signal
        N=length(x); %length of input signal
        
        % generate known filter coefficients
        Pz=0.5*[0:127];  %linear coefficients
        %Pz=randn(128,1); %random coefficients
        ylim = max(Pz)*1.20;
        ymin = min(Pz)-.2*max(Pz);
        % generate filtered input signal == desired signal
        d=conv(Pz,x); %input signal filtered by known filter Pz (primary path)
        
        %% ESTIMATE SECONDARY PATH SIGNAL USING LMS %%
        %generate dummy secondary path response Sz
        Sz = Pz/2;
        %run known signal through filter
        yp=conv(Sz,x);
        %initalize Sz hat values
        Szh=zeros(M,1);
        
        for n=M:N
            ypvec=x(n:-1:n-M+1); %input has to be in reverse orxer has to be
            mu = muOG/(ypvec'*ypvec);
            e(n)=yp(n)-Szh'*ypvec; %update error
            %plot(e)
            Szh=Szh+mu*ypvec*(e(n)); %update filter coefficient
        end
        Szh = abs(ifft(1./abs(fft(Szh))));
        
        %% LMS FOR MAIN ANC %%
        mu=2.6;
        %initialize signal
        y = zeros(N,1);
        %filter input by learned filter to get x prime
        xp = conv(Szh,x);
        yp = conv(Szh,y);
        %initialize delayed cancellation signal
        ypvecLast = zeros(M,1);
        yvecLast = zeros(M,1);
        %initalize adaptive filter values
        Az=zeros(M,1);
        Bz=zeros(M,1);
        %Make sure that x and d are column vectors
        x=x(:);
        d=d(:);
        %LMS
        for n=M:N
            %flip buffer order
            yvec = y(n:-1:n-M+1);
            ypvec=yp(n:-1:n-M+1);
            xvec=x(n:-1:n-M+1)+.8*ypvec; %add feedback to input
            xpvec=xp(n:-1:n-M+1)+.8*ypvec; %add feedback to input
            %update mu
            mu = muOG/(xvec'*xvec);
            %calculate output
            y(n) = Az'*xvec + Bz'*yvecLast;
            %update error
            e(n)=d(n)-y(n);
            %update adaptive filter weights
            Az=Az+mu*xpvec*(e(n));
            Bz=Bz+mu*ypvecLast*(e(n));
            %update delayed cancellation signal
            ypvecLast = ypvec;
            yvecLast = yvec;
            %draw the learned filter in realtime
            %         plot(Pz)
            %         hold on
            %         plot(Az)
            %         axis([0 inf ymin ylim])
            %         title(sprintf('n=%f time=%fs error = %f mu = %f',n-M, (n-M)/fs, e(n),mu))
            %         hold off
            %         legend('Input coefficients','Learned Coefficients')
            %         drawnow;
        end
        e=e(:);
        emean = (emean(:)+e);
    end
    emean=(emean)/i;
    if max(emean)>1e4
        for l = 1:length(emean)
            if abs(emean(l)) > 1e3
                emean(l)=1e3;
            end
        end
        eall(j,:)=emean;
    else
        try
            [eall(j,:),q]=(envelope(abs(emean),500,'peaks'));
        catch
            eall(j,:) = 1e3;
        end
    end
end
figure
for i = 1:length(mus)
    plot(10*log10(abs(eall(i,:))))
    hold on
end
title('Convergence Time in Cycles')
ylabel('Error (dB)');
xlabel('Cycles');
hleg=legend('0.01','0.05','0.1','0.5','1.0', '2.0');
htitle=get(hleg,'Title');
set(htitle,'String','mu');
% %% PLOT RESULTS %%
% figure
% subplot(2,1,1)
% plot(e)
% title('Convergence Time in Cycles')
% ylabel('Amplitude');
% xlabel('Cycles');
% legend('Error');
% subplot(2,1,2)
% stem(Pz)
% hold on
% stem(Wz, 'r*')
% title('Input Coefficients vs Learned Coefficients')
% ylabel('Amplitude');
% xlabel('Numbering of filter tap');
% legend('Input Coefficients', 'learned coefficients')