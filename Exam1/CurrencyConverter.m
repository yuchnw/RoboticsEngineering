function varargout = CurrencyConverter(varargin)
% CURRENCYCONVERTER MATLAB code for CurrencyConverter.fig
%      CURRENCYCONVERTER, by itself, creates a new CURRENCYCONVERTER or raises the existing
%      singleton*.
%
%      H = CURRENCYCONVERTER returns the handle to a new CURRENCYCONVERTER or the handle to
%      the existing singleton*.
%
%      CURRENCYCONVERTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURRENCYCONVERTER.M with the given input arguments.
%
%      CURRENCYCONVERTER('Property','Value',...) creates a new CURRENCYCONVERTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CurrencyConverter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CurrencyConverter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CurrencyConverter

% Last Modified by GUIDE v2.5 19-Mar-2018 13:15:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CurrencyConverter_OpeningFcn, ...
                   'gui_OutputFcn',  @CurrencyConverter_OutputFcn, ...
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


% --- Executes just before CurrencyConverter is made visible.
function CurrencyConverter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CurrencyConverter (see VARARGIN)

% Choose default command line output for CurrencyConverter
handles.output = hObject;

clc
addImageToAxes('dollar.png',handles.axes_dollar,100);
addImageToAxes('euro.png',handles.axes_euro,100);
addImageToAxes('pound.png',handles.axes_pound,100);

handles.user.dollar = 1;
str = sprintf('$ %.2f',handles.user.dollar);
set(handles.text_dollar,'String',str);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CurrencyConverter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CurrencyConverter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_euro_Callback(hObject, eventdata, handles)
% hObject    handle to edit_euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.euro = str2double(get(hObject,'String'));
set(handles.edit_pound,'String',' ');
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_euro as text
%        str2double(get(hObject,'String')) returns contents of edit_euro as a double


% --- Executes during object creation, after setting all properties.
function edit_euro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pound_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.pound = str2double(get(hObject,'String'));
set(handles.edit_euro,'String',' ');
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_pound as text
%        str2double(get(hObject,'String')) returns contents of edit_pound as a double


% --- Executes during object creation, after setting all properties.
function edit_pound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_euro.
function pushbutton_euro_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.dollar = handles.user.euro * 1.24;
str = sprintf('$ %.2f',handles.user.dollar);
set(handles.text_dollar,'String',str);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_pound.
function pushbutton_pound_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.dollar = handles.user.pound * 1.40;
str = sprintf('$ %.2f',handles.user.dollar);
set(handles.text_dollar,'String',str);
guidata(hObject, handles);
