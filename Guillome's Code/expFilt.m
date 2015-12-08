function [ y ] = expFilt( t, delay,tau )
y=zeros(size(t));
y(t>delay)=1/tau*exp((delay-t(t>delay))/tau);
end

