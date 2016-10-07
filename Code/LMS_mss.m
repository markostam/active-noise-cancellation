%function [e,w]=lmsBasic(M,x,d,h);
%
% Input arguments:
% M = learned filter length, dim 1x1
% x = input signal, dim Nx1
% d = desired signal, dim Nx1
% h = input coefficients  (coeff of filter we
%       are trying to learn. filter
%       that turns d into u)
%
% Output arguments:
% e = estimation error, dim Nx1
% w = final filter coefficients, dim Mx1
mus = [0.01 0.05 0.1 0.5 1 2];% 0.5 1];
for j = 1:length(mus)
    for i = 1:100
        %%INITIALIZE VALUES%%
        % generate input signal
        M=128; %buffer size (num filter weights)
        x=randn(20000,1); %input signal
        x=x/max(x); %sample rate
        fs=8000; %number of samples of the input signal
        N=length(x); %length of input signal
        muOG = mus(j);
        
        % generate known filter coefficients
        Pz=(0.5*[0:127]).^2;  %linear coefficients
        %Pz=randn(128,1); %random coefficients
        ylim = max(Pz)*1.20;
        ymin = min(Pz)-.2*max(Pz);
        % generate filtered input signal == desired signal
        d=conv(Pz,x); %input signal filtered by known filter Pz (primary path)
        
        
        %% LMS FOR MAIN ANC %%
        
        %initalize Wz filter values
        Wz=zeros(M,1);
        emean=zeros(N,1);
        %Make sure that x and d are column vectors
        x=x(:);
        d=d(:);
        %LMS
        
        for n=M:N
            xvec=x(n:-1:n-M+1); %input has to be in reverse orxer
            %adaptively update mu
            mu(n) = muOG;
            e(n)=d(n)-Wz'*xvec; %update error
            Wz=Wz+mu(n)*xvec*(e(n)); %update filter coefficient
            
            %visualize learned filter in realtime
            %         plot(Pz)
            %         hold on
            %         plot(Wz)
            %         axis([0 inf ymin ylim])
            %         title(sprintf('n=%f time=%fs error = %f mu=%f',n-M, (n-M)/fs, e(n), mu(n-M+1)))
            %         hold off
            %         legend('Input coefficients','Learned Coefficients')
            %         drawnow;
        end
        e=e(:);
        emean = (emean(:)+e);
    end
    emean=(emean)/i;
    if sum(isinf(emean))>0
        emean(~isinf(emean))=1e3;
        eall(j,:)=emean;
    elseif max(emean)>1e4
        for l = 1:length(emean)
            if abs(emean(l)) > 1e3
                emean(l)=1e3;
            end
        end
        eall(j,:)=emean;
    else
        [eall(j,:),q]=(envelope(abs(emean),150,'peaks'));
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