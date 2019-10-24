function Cell_Map_Dice(AverageImage,Connected_ROI,ROIbases)

Centroid = regionprops(AverageImage,'centroid');
centroids = cat(1, Centroid.Centroid);


[H,W] = size(AverageImage);

background = ones(H,W);


%%
% imshow(mat2gray(background))
% axis on
% hold on;

[lengthConnected,~] = size(Connected_ROI);

for i = 1:length(centroids)
%     plot(centroids(i,1),centroids(i,2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);

    radius = 10; 
    centerX = centroids(i,2);
    centerY = centroids(i,1);

%     circle = viscircles([centerX, centerY], radius);
    for x = 1:H
        for y = 1:W
            dX = abs(x-centerX);
            dY = abs(y-centerY);
            pixelrad = (dX)^2 + (dY)^2;
            if pixelrad <= radius^2
                background(x,y) = 0;
            end
        end
    end
end

imshow(background)
hold on
%%


if Connected_ROI(1,:) ~= [0,0,0]
    for j = 1:lengthConnected
        Cell1 = ROIbases(Connected_ROI(j,1),:);
        Cell2 = ROIbases(Connected_ROI(j,2),:);
        corr = Connected_ROI(j,3);
        if corr > 0.9
            LineWidth = 7;
        elseif corr >= 0.5 && corr <= 0.9
            LineWidth = 5;
        end
        x1 = Cell1(1,2);
        x2 = Cell2(1,2);
        y1 = Cell1(1,1);
        y2 = Cell2(1,1);
        Color = 'k';
        x = line([y1,y2],[x1,x2],'LineWidth',3,'Color',Color);
        x.Color(4) = 0.4;
    end
end