dx = 0.01; % Spacing of points on string
dt = 0.001; % Size of time step
c= 5; % speed of wave propagation
L = 10; % length of string
stopTime = 10; % time to run the simulation

r = c*dt/dx;
n = L/dx + 1;

current = 0.5 - 0.5 * cos(2*pi/L*[0:dx:L]);
past = current;
future = zeros(1,n);
for t = 0:dt:stopTime
    future(1) = 0;
    future(2:n-1) = r^2.*(current(1:n-2)+current(3:n)) + ...
        2.*(1-r^2).*current(2:n-1) - past(2:n-1);
    future(n) = 0;
    
    past = current;
    current = future;
    
    if mod(t/dt,10) == 0
        plot([0:dx:L], current)
        axis([0 L -2 2])
        pause(0.001)
    end
end
    