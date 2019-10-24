clear
clc

filenameHour0 = '/Users/hammadkhan/Desktop/Live_calcium/CSV/Series21-1/Series21-12.tif';
%filenameHour0 = '/Users/hammadkhan/Desktop/Live_calcium/CSV/Series21-Inner/Series21_Inner.tif';

[Image_StackH0,num_imagesH0,WidthH0,HeightH0] = Image_Reader(filenameHour0);

MinValH0 = 1;
[AverageImageH0,ROIbasesH0] = Average_Image(Image_StackH0,num_imagesH0,WidthH0,HeightH0,MinValH0);
[ROIH0, LH0, ROIboundaryH0] = segmentationNEW(AverageImageH0);

[DeltaFoverFH0] = location_analysis_dFoverF(ROIH0, Image_StackH0,num_imagesH0);


[dDeltaFoverFH0] = location_analysis_dDeltaFoverF(ROIH0, Image_StackH0,num_imagesH0);


std_threshold = 5;
static_threshold = 0.05;

Spikes = Spike_Detector_Single(dDeltaFoverFH0,std_threshold,static_threshold);
figure(1); ShowROIedits(AverageImageH0,ROIboundaryH0,LH0);
figure(2); imshow(mat2gray(Image_StackH0(:,:,1)));
figure(3); plot(linspace(1,num_imagesH0,num_imagesH0),DeltaFoverFH0)
figure(4); plot(linspace(1,num_imagesH0-1,num_imagesH0-1),dDeltaFoverFH0)
figure(5); spikeplotter = Show_Spikes(Spikes);

%%
% DeltaFoverFplotter(dDeltaFoverFH0,std_threshold,static_threshold)
% ylim([-0.5,0.5])

corr = correlation_dice(Spikes);

Connected_ROIH0 = Connectivity_dice(corr, ROIH0);

figure(6); Cell_Map_Dice(AverageImageH0,Connected_ROIH0,ROIbasesH0)
%%
SpikeperROISecond = mean(Spikes,2)*2;
AvgSpikeperROISecond = mean(mean(Spikes,2))*2;