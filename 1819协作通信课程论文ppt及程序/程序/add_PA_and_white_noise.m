function [rx]=add_PA_and_channel_effect(channel,signal_sequence,rx,p,noise_vector);
rx.received_signal=sqrt(p).*signal_sequence.*channel.attenuation.h+noise_vector;