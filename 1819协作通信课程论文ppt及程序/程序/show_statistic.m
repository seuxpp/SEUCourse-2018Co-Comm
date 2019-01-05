function [handle] = show_statistic(colour_bw, order);
% œ‘ æÕº
global statistic;
if (nargin<1), colour_bw = 0; end
if (nargin<2), order = 1:size(statistic.x,1); end
if (colour_bw == 1)
colours = ['k-o';'k-*';'k-s';'k-+';'k-^';'k-h';'k-v';'k-p'];
else
colours = ['b-o';'r-d';'g-s';'k-v';'m-^';'b-<';'r->';'g-p'];
end
legend_ordered = [];
handle = figure;
colour = 0;
for n = order
colour = colour + 1;
semilogy(statistic.x(n,:),statistic.y(n,:),colours(colour,:));
legend_ordered = strvcat(legend_ordered,statistic.legend(n,:));
hold on
end
grid on;
legend (legend_ordered,3)
xlabel (statistic.xlabel)
ylabel (statistic.ylabel)