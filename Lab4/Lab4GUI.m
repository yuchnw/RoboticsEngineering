function varargout = Lab4GUI(varargin)
% LAB4GUI MATLAB code for Lab4GUI.fig
%      LAB4GUI, by itself, creates a new LAB4GUI or raises the existing
%      singleton*.
%
%      H = LAB4GUI returns the handle to a new LAB4GUI or the handle to
%      the existing singleton*.
%
%      LAB4GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAB4GUI.M with the given input arguments.
%
%      LAB4GUI('Property','Value',...) creates a new LAB4GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Lab4GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Lab4GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Lab4GUI

% Last Modified by GUIDE v2.5 09-Mar-2018 13:57:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lab4GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Lab4GUI_OutputFcn, ...
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


% --- Executes just before Lab4GUI is made visible.
function Lab4GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Lab4GUI (see VARARGIN)

% Choose default command line output for Lab4GUI
handles.output = hObject;

% This is the place where I put my initialization stuff
clc
fprintf('Ready\n')
handles.user.slider1=0;
handles.user.slider2=90;
handles.user.slider3=0;
handles.user.slider4=-90;
handles.user.slider5=90;
handles.user.gripper=0;

set(handles.slider_joint1,'Value',handles.user.slider1);
set(handles.slider_joint2,'Value',handles.user.slider2);
set(handles.slider_joint3,'Value',handles.user.slider3);
set(handles.slider_joint4,'Value',handles.user.slider4);
set(handles.slider_joint5,'Value',handles.user.slider5);
set(handles.gripper_slider,'Value',handles.user.gripper);

str=sprintf('%d %d %d %d %d',handles.user.slider1,handles.user.slider2,handles.user.slider3,handles.user.slider4,handles.user.slider5);
set(handles.joint_info,'String',str);

handles.user.jointAngles = [0 90 0 -90 90]; % Home position.
handles.user.position1Angles = handles.user.jointAngles;
handles.user.position2Angles = handles.user.jointAngles;
handles.user.position3Angles = handles.user.jointAngles;

% Prepare the arm axes
view(handles.axes_arm, [-50 -50 50]);
axis(handles.axes_arm, [-10 10 -6 6 -6 8]);
set(handles.axes_arm, 'Visible', 'off');

% Add the image of the Wild Thumper to the background axes
addImageToAxes('wildThumper.png', handles.axes_thumperImg, 250);

% Create vertices for all the patches
makeLink0(handles.axes_arm, [.5 .5 .5]);  % Doesn't move so save no references.
% Save handles to the patch objects and create a vertices matrix for each.
handles.user.link1Patch = makeLink1(handles.axes_arm, [.9 .9 .9]);
handles.user.link1Vertices = get(handles.user.link1Patch, 'Vertices')';
handles.user.link1Vertices(4,:) = ones(1, size(handles.user.link1Vertices,2));
handles.user.link2Patch = makeLink2(handles.axes_arm, [.9 .9 .9]);
handles.user.link2Vertices = get(handles.user.link2Patch, 'Vertices')';
handles.user.link2Vertices(4,:) = ones(1, size(handles.user.link2Vertices,2));
handles.user.link3Patch = makeLink3(handles.axes_arm, [.9 .9 .9]);
handles.user.link3Vertices = get(handles.user.link3Patch, 'Vertices')';
handles.user.link3Vertices(4,:) = ones(1, size(handles.user.link3Vertices,2));
handles.user.link4Patch = makeLink4(handles.axes_arm, [.9 .9 .9]);
handles.user.link4Vertices = get(handles.user.link4Patch, 'Vertices')';
handles.user.link4Vertices(4,:) = ones(1, size(handles.user.link4Vertices,2));
handles.user.link5Patch = makeLink5(handles.axes_arm, [.95 .95 0]);
handles.user.link5Vertices = get(handles.user.link5Patch, 'Vertices')';
handles.user.link5Vertices(4,:) = ones(1, size(handles.user.link5Vertices,2));

% Move the arm into the HOME position.
updateArm(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Lab4GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Lab4GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_joint1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.user.slider1 = get(handles.slider_joint1,'Value');
str=sprintf('%d %d %d %d %d',round(handles.user.slider1),round(handles.user.slider2),...
    round(handles.user.slider3),round(handles.user.slider4),...
    round(handles.user.slider5));
set(handles.joint_info,'String',str);
fprintf(handles.user.port, sprintf('JOINT 1 ANGLE %d',round(handles.user.slider1)));
% Update handles structure
updateArm(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_joint1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.user.slider2 = get(handles.slider_joint2,'Value');
str=sprintf('%d %d %d %d %d',round(handles.user.slider1),round(handles.user.slider2),...
    round(handles.user.slider3),round(handles.user.slider4),...
    round(handles.user.slider5));
set(handles.joint_info,'String',str);
fprintf(handles.user.port, sprintf('JOINT 2 ANGLE %d',round(handles.user.slider2)));
% Update handles structure
updateArm(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_joint2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.user.slider3 = get(handles.slider_joint3,'Value');
str=sprintf('%d %d %d %d %d',round(handles.user.slider1),round(handles.user.slider2),...
    round(handles.user.slider3),round(handles.user.slider4),...
    round(handles.user.slider5));
set(handles.joint_info,'String',str);
fprintf(handles.user.port, sprintf('JOINT 3 ANGLE %d',round(handles.user.slider3)));
% Update handles structure
updateArm(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_joint3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint4_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.user.slider4 = get(handles.slider_joint4,'Value');
str=sprintf('%d %d %d %d %d',round(handles.user.slider1),round(handles.user.slider2),...
    round(handles.user.slider3),round(handles.user.slider4),...
    round(handles.user.slider5));
set(handles.joint_info,'String',str);
fprintf(handles.user.port, sprintf('JOINT 4 ANGLE %d',round(handles.user.slider4)));
% Update handles structure
updateArm(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_joint4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint5_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.user.slider5 = get(handles.slider_joint5,'Value');
str=sprintf('%d %d %d %d %d',round(handles.user.slider1),round(handles.user.slider2),...
    round(handles.user.slider3),round(handles.user.slider4),...
    round(handles.user.slider5));
set(handles.joint_info,'String',str);
fprintf(handles.user.port, sprintf('JOINT 5 ANGLE %d',round(handles.user.slider5)));
% Update handles structure
updateArm(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_joint5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function port_number_Callback(hObject, eventdata, handles)
% hObject    handle to port_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.num = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function port_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button_open.
function button_open_Callback(hObject, eventdata, handles)
% hObject    handle to button_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open_ports = instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
    fclose(open_ports);
end
handles.user.port = serial(sprintf('COM%d',handles.user.num),'Baudrate', 9600);
fopen(handles.user.port);

guidata(hObject, handles);


% --- Executes on button press in button_close.
function button_close_Callback(hObject, eventdata, handles)
% hObject    handle to button_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open_ports = instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
    fclose(open_ports);
fprintf('Disconnected\n');
fclose(handles.user.port);
end

% --- Executes on slider movement.
function gripper_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gripper_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.user.gripper = get(handles.gripper_slider,'Value');
fprintf(handles.user.port, sprintf('GRIPPER %d',round(handles.user.gripper)));
updateArm(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function gripper_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gripper_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function updateArm(hObject, handles)
handles.user.jointAngles = [handles.user.slider1 handles.user.slider2 ...
    handles.user.slider3 handles.user.slider4 handles.user.slider5];

% DONE: Create the five homogeneous transformation matrices.
[A1,A2,A3,A4,A5] = makeHomogeneousTransformations(...
    handles.user.jointAngles(1),...
    handles.user.jointAngles(2),...
    handles.user.jointAngles(3),...
    handles.user.jointAngles(4),...
    handles.user.jointAngles(5));

% DONE: Use the A matricies to form the T0_n matricies.
T0_1 = A1;
T0_2 = A1 * A2;
T0_3 = A1 * A2 * A3;
T0_4 = A1 * A2 * A3 * A4;
T0_5 = A1 * A2 * A3 * A4 * A5;

% DONE: Use the T matricies to transform the patch vertices
link1verticesWRTground = T0_1 * handles.user.link1Vertices;
link2verticesWRTground = T0_2 * handles.user.link2Vertices;
link3verticesWRTground = T0_3 * handles.user.link3Vertices;
link4verticesWRTground = T0_4 * handles.user.link4Vertices;
link5verticesWRTground = T0_5 * handles.user.link5Vertices;


% DONE: Update the patches with the new vertices.
set(handles.user.link1Patch,'Vertices', link1verticesWRTground(1:3,:)');
set(handles.user.link2Patch,'Vertices', link2verticesWRTground(1:3,:)');
set(handles.user.link3Patch,'Vertices', link3verticesWRTground(1:3,:)');
set(handles.user.link4Patch,'Vertices', link4verticesWRTground(1:3,:)');
set(handles.user.link5Patch,'Vertices', link5verticesWRTground(1:3,:)');

% Making sure the joint angles are integers before sending to robot (should already be ints).
handles.user.jointAngles(1) = round(handles.user.jointAngles(1));
handles.user.jointAngles(2) = round(handles.user.jointAngles(2));
handles.user.jointAngles(3) = round(handles.user.jointAngles(3));
handles.user.jointAngles(4) = round(handles.user.jointAngles(4));
handles.user.jointAngles(5) = round(handles.user.jointAngles(5));

% TODO: Send a position command to the serial robot if open.
fprintf('TODO: Send a position command to the serial robot if open.\n');

guidata(hObject, handles);
