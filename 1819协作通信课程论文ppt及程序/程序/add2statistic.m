function add2statistic(x,y,leg);
% Ìí¼ÓÍ¼
global statistic;
statistic.x = [statistic.x;x];
statistic.y = [statistic.y;y];
statistic.legend = strvcat(statistic.legend,leg);