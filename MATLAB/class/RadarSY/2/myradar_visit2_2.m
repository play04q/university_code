clear all
close all
swid = 3; 
pfa = 1e-7; 
np = 1; 
R_1st_frame = 61e3; % Range for first frame 
RO = 55e3; % range to last frame 
SNRO = 9; % SNR at RO 
frame= 0.3e3; %frame size 
nfa=log(2)/pfa; 
range_frame = R_1st_frame:-frame:RO; 
% Range to each frame % implement Eq. (2.98) 
SNRi = SNRO + 40.*log10((RO./range_frame));
pd5=0;
% calculate the Swerling 5 Pd at each frame 
b = sqrt(-2.0 * log(pfa));
if np ==1 
    for frame= 1:1:size(SNRi,2)
        a = sqrt(2.0 * 10^(.1*SNRi(frame)));
        pd5(frame) = marcumsq(a,b);
    end
else
    [pd5] = pd_swerling5(pfa,1,np, SNRi); 
end 
% compute additional SNR needed due to fluctuation 
for frame= 1:1:size(SNRi,2) 
    [Lf(frame),Pd_Sw5] = fluct_loss(pd5(frame),pfa,np,swid);
end 
% adjust SNR at each frame 
SNRi = SNRi -Lf; 
% compute the frame Pd 
for frame = 1:1:size(SNRi,2) 
    if(swid==1) 
        Pdi(frame) = pd_swerling1 (nfa. np, SNRi(frame));
    end 
    if(swid==2)
        Pdi(frame) = pd_swerling2 (nfa, np, SNRi(frame));
    end 
    if(swid==3) 
        Pdi(frame) = pd_swerling3 (nfa, np, SNRi(frame));
    end 
    if(swid==4) 
        Pdi(frame) = pd_swerling4 (nfa, np, SNRi(frame)); 
    end 
    if(swid==5)
        Pdi(frame) = pd5(frame); 
    end 
end 
Pdc(1:size(SNRi,2))=0; 
Pde(1) = 1 - Pdi(1); 
% compute the cumulative Pd 
for frame = 2: 1 :size(SNRi,2) 
    Pdc(frame) = (1-Pdi(frame))*Pdc(frame-1);
end 
PDC = 1 - Pdc(21); 