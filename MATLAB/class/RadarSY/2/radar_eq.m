function [snr]=radar_eq(pt, freq, g, sigma, te, b, nf, loss, range)
% This program implements Eq. (1.56)
c=3.0e+8; % speed oflight
lambda=c /freq; % wavelength
p_peak=10*log10(pt); % convert peak power to dB
lambda_sqdb=10*log10(lambda^2);% compute wavelength square in dB
sigmadb =10*log10(sigma);%convert sigma to dB
four_pi_cub=10*log10((4.0 *pi)^3); % (4pi)^3 in dB
k_db=10*log10(1.38e-23);% Boltzman's constant in dB
te_db =10*log10(te); % noise temp. in dB
b_db=10*log10(b); % bandwidth in dB
range_pwr4_db=10*log10(range.^4); % vector oftarget range^4 in dB
% Implement Equation (1.56)
num=p_peak+g+g+lambda_sqdb+sigmadb;
den=four_pi_cub+k_db+te_db+b_db+nf+loss+range_pwr4_db;
snr=num-den;
return