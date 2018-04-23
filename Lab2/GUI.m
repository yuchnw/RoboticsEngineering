function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 14-Mar-2018 19:32:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

clc

handles.user.currentLocation = 3;
handles.user.currentPlate = 1;
handles.user.gripperOpen = 0;
handles.user.retract = 1;
handles.user.grabbed = 0;
handles.user.bar = handles.axes_bar3;
handles.user.plate = handles.axes_plate3;
handles.user.gripper = handles.axes_gripper3;
handles.user.from = 1;
handles.user.to = 1;
addImageToAxes('robot_background.jpg',handles.axes_background,500);
addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
addImageToAxes('plate_only.jpg',handles.axes_plate1,90);
set(handles.uitable_delay,'Data',[60 20 30;0 30 30;30 0 30; 30 30 0 ;30 60 60 ]);
% Update handles structure
guidata(hObject, handles);

function getLocation(hObject, handles)
switch(handles.user.currentLocation)
    case 1
        handles.user.bar = handles.axes_bar1;
        handles.user.plate = handles.axes_plate1;
        handles.user.gripper = handles.axes_gripper1;
        guidata(hObject, handles);
    case 2
        handles.user.bar = handles.axes_bar2;
        handles.user.plate = handles.axes_plate2;
        handles.user.gripper = handles.axes_gripper2;
        guidata(hObject, handles);
    case 3
        handles.user.bar = handles.axes_bar3;
        handles.user.plate = handles.axes_plate3;
        handles.user.gripper = handles.axes_gripper3;
        guidata(hObject, handles);
    case 4
        handles.user.bar = handles.axes_bar4;
        handles.user.plate = handles.axes_plate4;
        handles.user.gripper = handles.axes_gripper4;
        guidata(hObject, handles);
    case 5
        handles.user.bar = handles.axes_bar5;
        handles.user.plate = handles.axes_plate5;
        handles.user.gripper = handles.axes_gripper5;
        guidata(hObject, handles);
end
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.robot.reset;
set(get(handles.user.bar,'Children'),'Visible','Off');
set(get(handles.user.gripper,'Children'),'Visible','Off');
if handles.user.retract == 0 && handles.user.currentPlate == handles.user.currentLocation
    addImageToAxes('plate_only.jpg',handles.user.plate,90);
else
    set(get(handles.user.gripper,'Children'),'Visible','Off');
end
handles.user.currentLocation = 3;
handles.user.gripperOpen = 0;
handles.user.retract = 1;
handles.user.grabbed = 0;
handles.user.bar = handles.axes_bar3;
handles.user.plate = handles.axes_plate3;
handles.user.gripper = handles.axes_gripper3;
addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
% set(handles.uitable_delay,'Data',zeros(5,3));
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_snake.
function pushbutton_snake_Callback(hObject, eventdata, handles)
handles.user.robot.x(1);
handles.user.robot.open;
handles.user.robot.extend;
handles.user.robot.close;
handles.user.robot.x(2);
handles.user.robot.extend;
handles.user.robot.x(3);
handles.user.robot.extend;
handles.user.robot.x(4);
handles.user.robot.extend;
handles.user.robot.x(5);
handles.user.robot.extend;
handles.user.robot.open;
handles.user.robot.retract;
handles.user.robot.close;
set(get(handles.user.bar,'Children'),'Visible','Off');
set(get(handles.user.gripper,'Children'),'Visible','Off');
set(get(handles.user.plate,'Children'),'Visible','Off');
set(get(handles.axes_plate1,'Children'),'Visible','Off');
handles.user.gripper = handles.axes_gripper5;
handles.user.plate = handles.axes_plate5;
handles.user.bar = handles.axes_bar5;
addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
addImageToAxes('plate_only.jpg',handles.user.plate,90);
handles.user.currentLocation = 5;
handles.user.currentPlate = 5;
handles.user.retract = 1;
handles.uesr.gripperOpen = 0;
handles.user.grabbed = 0;
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_from.
function popupmenu_from_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.user.from = str2double(contents{get(hObject,'Value')});
handles.user.currentLocation = handles.user.from;
if handles.user.from == handles.user.currentPlate
    handles.user.grabbed = 1;
else
    handles.user.grabbed = 0;
end
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_from contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_from


% --- Executes during object creation, after setting all properties.
function popupmenu_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_to.
function popupmenu_to_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.user.to = str2double(contents{get(hObject,'Value')});
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_movePlate.
function pushbutton_movePlate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_movePlate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.robot.movePlate(handles.user.from,handles.user.to);
set(get(handles.user.plate,'Children'),'Visible','Off');
set(get(handles.user.bar,'Children'),'Visible','Off');
set(get(handles.user.gripper,'Children'),'Visible','Off');
if handles.user.currentPlate == handles.user.from
    set(get(handles.axes_plate1,'Children'),'Visible','Off');
    set(get(handles.axes_plate2,'Children'),'Visible','Off');
    set(get(handles.axes_plate3,'Children'),'Visible','Off');
    set(get(handles.axes_plate4,'Children'),'Visible','Off');
    set(get(handles.axes_plate5,'Children'),'Visible','Off');
end
switch(handles.user.from)
    case 1
        handles.user.bar = handles.axes_bar1;
        handles.user.plate = handles.axes_plate1;
    case 2
        handles.user.bar = handles.axes_bar2;
        handles.user.plate = handles.axes_plate2;
    case 3
        handles.user.bar = handles.axes_bar3;
        handles.user.plate = handles.axes_plate3;
    case 4
        handles.user.bar = handles.axes_bar4;
        handles.user.plate = handles.axes_plate4;
    case 5
        handles.user.bar = handles.axes_bar5;
        handles.user.plate = handles.axes_plate5;
end
if handles.user.grabbed == 1
    set(get(handles.user.plate,'Children'),'Visible','Off');
    handles.user.currentPlate = handles.user.to;
end
addImageToAxes('gripper_closed_no_plate.jpg',handles.axes_gripper3,90);
switch(handles.user.to)
    case 1  
        addImageToAxes('plate_only.jpg',handles.axes_plate1,90);
        handles.user.currentPlate = 1;
    case 2  
        addImageToAxes('plate_only.jpg',handles.axes_plate2,90);
        handles.user.currentPlate = 2;
    case 3  
        addImageToAxes('plate_only.jpg',handles.axes_plate3,90);
        handles.user.currentPlate = 3;
    case 4  
        addImageToAxes('plate_only.jpg',handles.axes_plate4,90);
        handles.user.currentPlate = 4;
    case 5  
        addImageToAxes('plate_only.jpg',handles.axes_plate5,90);
        handles.user.currentPlate = 5;
end
handles.user.currentLocation = 3;
handles.user.gripper = handles.axes_gripper3;
handles.user.bar = handles.axes_bar3;
handles.user.plate = handles.axes_plate3;
handles.user.grabbed = 0;
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getLocation(hObject, handles);
if handles.user.currentPlate == handles.user.currentLocation
    image = 'gripper_with_plate.jpg';
else
    image = 'gripper_open_no_plate.jpg';
end
if handles.user.retract == 1
    addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
else
    addImageToAxes(image,handles.user.plate,90);
end
handles.user.gripperOpen = 1;
handles.user.grabbed = 0;
handles.user.robot.open;
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_close.
function pushbutton_close_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getLocation(hObject, handles);
if handles.user.currentPlate == handles.user.currentLocation ...
        && handles.user.retract == 0
    handles.user.grabbed = 1;
else
    handles.user.grabbed = 0;
end
if handles.user.retract == 1
    if handles.user.grabbed == 0
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
    else
        addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
    end
else
    if handles.user.grabbed == 0
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.plate,90);
    else
        addImageToAxes('gripper_with_plate.jpg',handles.user.plate,90);
    end
end
handles.user.gripperOpen = 0;
handles.user.robot.close;
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_retract.
function pushbutton_retract_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_retract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if handles.user.retract == 0
getLocation(hObject, handles);
if handles.user.gripperOpen == 1
    addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
    if handles.user.currentLocation == handles.user.currentPlate
        addImageToAxes('plate_only.jpg',handles.user.plate,90);
    else
        set(get(handles.user.plate,'Children'),'Visible','Off');        
    end
else
    if handles.user.grabbed == 1
        addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
        set(get(handles.user.plate,'Children'),'Visible','Off');
    else
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
        if handles.user.currentLocation == handles.user.currentPlate
            addImageToAxes('plate_only.jpg',handles.user.plate,90);
        else
            set(get(handles.user.plate,'Children'),'Visible','Off');
        end
    end
end
set(get(handles.user.bar,'Children'),'Visible','Off');
handles.user.retract = 1;
handles.user.robot.retract;
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_extend.
function pushbutton_extend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_extend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getLocation(hObject, handles);
addImageToAxes('extended_bars.jpg',handles.user.bar,48);
disp(handles.user.currentLocation == handles.user.currentPlate)
if handles.user.currentPlate == handles.user.currentLocation
    addImageToAxes('gripper_with_plate.jpg',handles.user.plate,90);
else
    if handles.user.gripperOpen == 1
        addImageToAxes('gripper_open_no_plate.jpg',handles.user.plate,90);
    else
        if handles.user.grabbed == 1
            addImageToAxes('gripper_with_plate.jpg',handles.user.plate,90);
        else
            addImageToAxes('gripper_closed_no_plate.jpg',handles.user.plate,90);
        end
    end
end
set(get(handles.user.gripper,'Children'),'Visible','Off');
handles.user.retract = 0;
handles.user.robot.extend;
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_setDelay.
function pushbutton_setDelay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myTimes = [zeros(5,1) get(handles.uitable_delay,'Data') zeros(5,1)];
set(handles.uitable_delay,'Data',get(handles.uitable_delay,'Data'));
handles.user.robot.setTimeValues(myTimes);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_resetDelay.
function pushbutton_resetDelay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.robot.resetDefaultTimes;
set(handles.uitable_delay,'Data',[60 20 30;0 30 30;30 0 30; 30 30 0 ;30 60 60 ]);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_1.
function pushbutton_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(handles.user.gripper,'Children'),'Visible','Off');
set(get(handles.user.bar,'Children'),'Visible','Off');
if handles.user.currentLocation == handles.user.currentPlate && handles.user.grabbed == 0
    addImageToAxes('plate_only.jpg',handles.user.plate,90);
else
    set(get(handles.user.plate,'Children'),'Visible','Off');
end
handles.user.currentLocation = 1;
guidata(hObject, handles);
getLocation(hObject, handles);
handles.user.bar = handles.axes_bar1;
handles.user.plate = handles.axes_plate1;
handles.user.gripper = handles.axes_gripper1;
if handles.user.grabbed == 1
    addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
    handles.user.currentPlate = 1;
else
    if handles.user.gripperOpen == 1
        addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
    else
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
    end
end
% set(get(handles.user.bar,'Children'),'Visible','Off');
handles.user.robot.x(1);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_2.
function pushbutton_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(handles.user.gripper,'Children'),'Visible','Off');
set(get(handles.user.bar,'Children'),'Visible','Off');
if handles.user.currentLocation == handles.user.currentPlate && handles.user.grabbed == 0
    addImageToAxes('plate_only.jpg',handles.user.plate,90);
else
    set(get(handles.user.plate,'Children'),'Visible','Off');
end
handles.user.currentLocation = 2;
guidata(hObject, handles);
getLocation(hObject, handles);
handles.user.bar = handles.axes_bar2;
handles.user.plate = handles.axes_plate2;
handles.user.gripper = handles.axes_gripper2;
if handles.user.grabbed == 1
    addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
    handles.user.currentPlate = 2;
else
    if handles.user.gripperOpen == 1
        addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
    else
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
    end
end
set(get(handles.user.bar,'Children'),'Visible','Off');
handles.user.robot.x(2);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_3.
function pushbutton_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(handles.user.gripper,'Children'),'Visible','Off');
set(get(handles.user.bar,'Children'),'Visible','Off');
if handles.user.currentLocation == handles.user.currentPlate && handles.user.grabbed == 0
    addImageToAxes('plate_only.jpg',handles.user.plate,90);
else
    set(get(handles.user.plate,'Children'),'Visible','Off');
end
handles.user.currentLocation = 3;
guidata(hObject, handles);
getLocation(hObject, handles);
handles.user.bar = handles.axes_bar3;
handles.user.plate = handles.axes_plate3;
handles.user.gripper = handles.axes_gripper3;
if handles.user.grabbed == 1
    addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
    handles.user.currentPlate = 3;
else
    if handles.user.gripperOpen == 1
        addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
    else
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
    end
end
set(get(handles.user.bar,'Children'),'Visible','Off');
handles.user.robot.x(3);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_4.
function pushbutton_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(handles.user.gripper,'Children'),'Visible','Off');
set(get(handles.user.bar,'Children'),'Visible','Off');
if handles.user.currentLocation == handles.user.currentPlate && handles.user.grabbed == 0
    addImageToAxes('plate_only.jpg',handles.user.plate,90);
else
    set(get(handles.user.plate,'Children'),'Visible','Off');
end
handles.user.currentLocation = 4;
guidata(hObject, handles);
getLocation(hObject, handles);
handles.user.bar = handles.axes_bar4;
handles.user.plate = handles.axes_plate4;
handles.user.gripper = handles.axes_gripper4;
if handles.user.grabbed == 1
    addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
    handles.user.currentPlate = 4;
else
    if handles.user.gripperOpen == 1
        addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
    else
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
    end
end
set(get(handles.user.bar,'Children'),'Visible','Off');
handles.user.robot.x(4);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_5.
function pushbutton_5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(handles.user.gripper,'Children'),'Visible','Off');
set(get(handles.user.bar,'Children'),'Visible','Off');
if handles.user.currentLocation == handles.user.currentPlate && handles.user.grabbed == 0
    addImageToAxes('plate_only.jpg',handles.user.plate,90);
else
    set(get(handles.user.plate,'Children'),'Visible','Off');
end
handles.user.currentLocation = 5;
guidata(hObject, handles);
getLocation(hObject, handles);
handles.user.bar = handles.axes_bar5;
handles.user.plate = handles.axes_plate5;
handles.user.gripper = handles.axes_gripper5;
if handles.user.grabbed == 1
    addImageToAxes('gripper_with_plate.jpg',handles.user.gripper,90);
    handles.user.currentPlate = 5;
else
    if handles.user.gripperOpen == 1
        addImageToAxes('gripper_open_no_plate.jpg',handles.user.gripper,90);
    else
        addImageToAxes('gripper_closed_no_plate.jpg',handles.user.gripper,90);
    end
end
set(get(handles.user.bar,'Children'),'Visible','Off');
handles.user.robot.x(5);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);


function edit_port_Callback(hObject, eventdata, handles)
% hObject    handle to edit_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.port = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_connect.
function pushbutton_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.robot = PlateLoader(handles.user.port);
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_disconnect.
function pushbutton_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.robot.shutdown;
guidata(hObject,handles);

% --- Executes on button press in pushbutton_getStatus.
function pushbutton_getStatus_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_getStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text4,'String',handles.user.robot.getStatus);
guidata(hObject, handles);
