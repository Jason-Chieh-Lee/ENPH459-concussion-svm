function plotChannels(data)

if size(data, 1) == 65
	numChan = size(data, 1) - 1;
else
	numChan = size(data, 1);
end

figure
hold on
for i = 1:numChan
	plot(1:length(data), (numChan - i)*5000+data(i,1:length(data)));
end
hold off

end