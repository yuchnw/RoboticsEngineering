classdef Flight < handle
    
    properties
        name
        expDeparture
        expArrival
        actDeparture
        actArrival
        state
    end
    
    methods
        
        function obj = Flight(name,expDeparture,expArrival)
            obj.name = name;
            obj.expDeparture = expDeparture;
            obj.expArrival = expArrival;
            obj.state = 0;
        end
        
        function takeOff(obj,actDeparture)
            if obj.state == 0
                obj.actDeparture = actDeparture;
                obj.expArrival = obj.actDeparture - obj.expDeparture + obj.expArrival;
                obj.state = 1;
            else
                obj.state = 5;
            end
        end
        
        function land(obj,actArrival)
            if obj.state == 1 && actArrival > obj.actDeparture
                obj.actArrival = actArrival;
                obj.state = 2;
            else
                obj.state = 5;
            end
        end
        
        function disp(obj)
            if obj.state == 0
                fprintf('Flight %s scheduled for departure at %d, expected arrival time is %d.\n',...
                    obj.name,obj.expDeparture,obj.expArrival);
            elseif obj.state == 1
                fprintf('Flight %s left at %d, projected arrival time is %d.\n',obj.name,...
                obj.actDeparture,obj.expArrival);
            elseif obj.state == 2
                fprintf('Flight %s left at %d and arrived at %d.\n',obj.name,...
                obj.actDeparture,obj.actArrival);
            else
                fprintf('Invalid state!\n')
            end
        end
    end
end