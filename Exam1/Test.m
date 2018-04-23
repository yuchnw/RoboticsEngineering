clc
fprintf('-- Flight 1 --\n');
flight1 = Flight('AA248', 5, 10)
fprintf('-- Take off --\n');
flight1.takeOff(6)
flight1
fprintf('-- Land --\n');
flight1.land(12)
flight1

fprintf('\n\n-- Flight 2 --\n');
flight2 = Flight('AA777', 50, 100)
fprintf('-- Take off --\n');
flight2.takeOff(45)
flight2
fprintf('-- Land --\n');
flight2.land(90)
flight2

fprintf('\n\n-- Flight 3 --\n');
flight3 = Flight('AA555', 50, 100)
fprintf('-- Land --\n');
flight3.land(2)
flight3

fprintf('\n\n-- Flight 4 --\n');
flight4 = Flight('AA222', 50, 100)
fprintf('-- Take off --\n');
flight4.takeOff(99)
fprintf('-- Land --\n');
flight4.land(1)
flight4