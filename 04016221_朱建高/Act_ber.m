function number_of_errbits = Act_ber(signal_x,signal_y)

[number,ratio] = biterr(signal_x,signal_y);
number_of_errbits = number;