function [binOne] = findBinOne(y, nBins)

[~, edges] = histcounts(y, nBins);
binOne = edges(2);

end