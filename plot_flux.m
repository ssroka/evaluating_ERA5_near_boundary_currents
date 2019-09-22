clear;close all;clc
addpath('~/Documents/MATLAB/util/')

flag_load_new_vars = false;
filter_flag        = 'box'; % 'box' or 'zonal'
patch_str = 'Kur'; % 'GS'   'Kur'
land_src = '/Volumes/SydneySroka_Anton/ERA5_2018_Dec_1_0_LandSeaMask.nc';

% ---------- Parameters --------------
% filter parameters
L = 500000; % [m] filtering box edge length
% wind-related
rho_a = 1.2;     % kg m^-3
c_p_air = 1000;  % J / kg / K
Lv = 2.26e6;     % J/kg

CD_ref = 1e-3;   % reference drag coefficient

lsm = ncread(land_src,'lsm');

for year = 3
    close all
    clearvars -except year CD_ref L Lv c_p_air filter_flag flag_load_new_vars land_src lsm patch_str rho_a
    switch year
        case 3 % 2003
            srcJFM = '/Volumes/SydneySroka_Anton/ERA5_2003_JFM_31d_6h.nc';
            srcD = '/Volumes/SydneySroka_Anton/ERA5_2002_Dec_31d_6h.nc';
        case 4 % 2004
            srcJFM = '/Volumes/SydneySroka_Remy/eddyFlux_data/ERA5_2004_JFM_31d_6h.nc';
            srcD = '/Volumes/SydneySroka_Remy/eddyFlux_data/ERA5_2003_Dec_31d_6h.nc';
        case 5 % 2005
            srcJFM = '/Volumes/SydneySroka_Remy/eddyFlux_data/ERA5_2005_JFM_31d_6h.nc';
            srcD = '/Volumes/SydneySroka_Remy/eddyFlux_data/ERA5_2004_Dec_31d_6h.nc';
        case 6 % 2006
            srcJFM = '/Volumes/SydneySroka_Remy/eddyFlux_data/ERA5_2006_JFM_31d_6h.nc';
            srcD = '/Volumes/SydneySroka_Remy/eddyFlux_data/ERA5_2005_Dec_31d_6h.nc';
        case 7 % 2007
            srcJFM = '/Volumes/SydneySroka_Anton/ERA5_2007_JFM_31d_6h.nc';
            srcD = '/Volumes/SydneySroka_Anton/ERA5_2006_Dec_31d_6h.nc';
    end
    
    time = double([ncread(srcD,'time');ncread(srcJFM,'time')])*60*60; % hours
    time = datetime(time,'ConvertFrom','epochtime','epoch','1900-01-01');
    
    lat = ncread(srcJFM,'latitude');
    lon = ncread(srcJFM,'longitude');
    
    switch patch_str
        case 'GS'
            % Gulf Stream
            lat_bnds = [25 45];
            lon_bnds = [275 305];
        case 'Kur'
            % Kurishio
            lat_bnds = [25 45];
            lon_bnds = [130 170];
    end
    patch_lat = (lat>lat_bnds(1))&(lat<lat_bnds(2));
    patch_lon = (lon>lon_bnds(1))&(lon<lon_bnds(2));
    
    patch_mat = sprintf('%s_%d_lat_%d_%d_lon_%d_%d.mat',patch_str,time(end).Year,lat_bnds(1),lat_bnds(2),lon_bnds(1),lon_bnds(2));
    
    load(patch_mat)

    figure(year)
    subplot(1,2,1)
    contourf(lon(patch_lon),lat(patch_lat),nanmean(slhf_patch,3)',30,'k')
    colorbar
    xlabel(' Deg lon ')
    ylabel(' Deg lat ')
    p_str = '%';
    t_str = sprintf('Surface Latent Heat Flux [W/$$m^{-2}$$] \n (mean DJFM %d) directly from ERA5',time(end).Year);
    title(t_str,'interpreter','latex')
    set(gca,'ydir','normal','fontsize',20)
    set(gcf,'color','w')
    subplot(1,2,2)
    contourf(lon(patch_lon),lat(patch_lat),nanmean(sshf_patch,3)',30,'k')
    colorbar
    xlabel(' Deg lon ')
    ylabel(' Deg lat ')
    p_str = '%';
    t_str = sprintf('Surface Sensible Heat Flux [W/$$m^{-2}$$] \n (mean DJFM %d) directly from ERA5',time(end).Year);
    title(t_str,'interpreter','latex')
    set(gca,'ydir','normal','fontsize',20)
    set(gcf,'color','w')    
    
    
end


%{








%}