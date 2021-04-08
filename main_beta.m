
clear;close all;clc
fileloc = mfilename('fullpath');
filedir = fileloc(1:max(strfind(fileloc,'/')));
cd(filedir)
addpath('~/Documents/MATLAB/util/')
addpath('~/MIT/Research/eddyFlux/filter/')
addpath('~/MIT/Research/eddyFlux/filter/lanczosfilter/')
addpath('~/MIT/Research/eddyFlux/filter/fft_filter/')
addpath('~/MIT/Research/eddyFlux/')
addpath('~/MIT/Research/eddyFlux/get_CD_alpha')
addpath('~/MIT/Research/eddyFlux/ERA5_data/')
addpath('/Users/ssroka/Documents/MATLAB/mpm/sandbox/NayarFxns')

year_vec = [2003];

data_src = '/Users/ssroka/MIT/Research/eddyFlux/ERA5_data/';

L = 250000; % m

filter_type = 'fft'; % filter type 'lanczos' or 'boxcar' or 'fft'

debug_flag = false;

box_num = 2;


calc_CD_beta_flag = true;
plot_flag = true;

%     % Kurishio
%     lat_bnds = [25 45];
%     lon_bnds = [130 170];


bCd0 =   [  0.2087  0.3381    0.0014]'; % fft L = 250 km 

%

switch box_num
    case 1
        box_opt = [36 41.5; 143 152];
    case 2
        box_opt = [30 44.5; 148 169];
end

if strcmp(filter_type,'boxcar')
    box_opt = [25 45; 130 170];
elseif strcmp(filter_type,'fft')
    cf = (1/(2*L));
%     box_limits = [30 40; 143 168];
%     box_limits = [30 42; 144 168];
%     box_limits = [30 44.5; 148 169];
%     box_limits = [36 41.5; 143 152];
elseif strcmp(filter_type(1:7),'lanczos')
    cf = (1/(2*L));
    box_opt = [25 45; 130 170];
end

beta_pos_flag = false;

if beta_pos_flag
    LB = [0;0; 0];
    UB = [Inf; Inf; Inf];
    con_str = 'cons_';
else
    LB = [-Inf; -Inf; 0];
    UB = [Inf; Inf; Inf];
    con_str = '';
end

year1 = 2003;

intvl = 1; % look at every intvl'th timpepoint

fft_first_flag = true;



%%
make_multipliers_beta(year_vec,L,data_src,filter_type,box_num,box_opt,cf,debug_flag);
% make_multipliers
get_CD_beta;

calc_AbBbCb
plot_AbBbCb












