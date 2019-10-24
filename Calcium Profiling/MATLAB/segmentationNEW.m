function [ROInew, L, ROIboundary] = segmentationNEW(AverageImage)
% 
% Width = size(AverageImage,2);
% Height = size(AverageImage,1);

[ROIboundary,L,~,~] = bwboundaries(AverageImage);
num_ROI = length(ROIboundary);

H = waitbar(0,'Segmenting Regions of Interest');
for x = 1:num_ROI
    waitbar(x/length(ROIboundary))
    ROIs = zeros(length(ROIboundary{x}),2);
    ROIs = ROIboundary{x,1};

    minX = min(ROIs(:,2));
    minY = min(ROIs(:,1));
    maxX = max(ROIs(:,2));
    maxY = max(ROIs(:,1));


    ROIadj = zeros(length(ROIboundary{x}),2);
    ROIadj(:,1) = ROIs(:,1)-minY+1;
    ROIadj(:,2) = ROIs(:,2)-minX+1;


    SingleBoundary = zeros(maxY-minY+2,maxX-minX+2);
    for i = 1:length(ROIadj)
        SingleBoundary(ROIadj(i,1),ROIadj(i,2)) = 1;
    end
    FilledCell = zeros(maxY-minY+2,maxX-minX+2);
    FilledCell = imfill(SingleBoundary(:,:),'holes');
    num = 1;
    clear Cell
    for i = 1:size(FilledCell,1)
        for j = 1:size(FilledCell,2)
            if FilledCell(i,j) == 1
                Cell{num,:} = [i+minY-1,j+minX-1];
                num = num+1;
            end
        end
    end

    ROInew{x,1} = Cell;
end

delete(H)