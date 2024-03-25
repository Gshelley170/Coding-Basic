%% Vehicle motion, 2D
%  VehicleTest
%  Numerical simulation of a vehicle in a plane

%  Initial version:   Karl H Siebold  02/18/2023
%  Modified by  #1: 
%  Modified by  #2:


clear all

global vehicleTest  

d2r  = pi/180;
kWh2J= 3.6e6;

%% Parameters

vehicleTest.mass              = 600.15;          % [kg]       Mass
vehicleTest.Inertia           = 600.26;          % [kg*m^2]   Inertia
vehicleTest.cd                = 0.24;            % []         Drag coefficient
vehicleTest.rSat              = 1.5;

vehicleTest.MaxThrustForce          = 50 ;          % [N]        Max thrust    
vehicleTest.MaxSteeringTorque       = 50;            % [Nm]       Maximum steering torque
vehicleTest.SteeringDamping         = 500;

vehicleTest.init.pos          = [0 0];               % [m]        Initial position
vehicleTest.init.vel          = [0 0];               % [m/s]      Initial velocity
vehicleTest.init.phi          = 90*d2r;              % [rad]      Initial heading
vehicleTest.init.omega        = 0.0;                 % [rad/s]    Initial angular rate
vehicleTest.init.charge       = 4*kWh2J;             % [J]        Initial charge

%% k values and area for the walls, roof, and floor. 
% Units:      [W/m^2/K]  [m^2]
vehicleTest.habitat.width.wall.k(1)  = 0.32;       vehicleTest.habitat.wall.width.area(1) = 36;   
vehicleTest.habitat.width.wall.k(2)  = 0.32;       vehicleTest.habitat.wall.width.area(2) = 36;
vehicleTest.habitat.length.wall.k(1)  = 0.32;       vehicleTest.habitat.wall.length.area(1) = 72;
vehicleTest.habitat.length.wall.k(2)  = 0.32;       vehicleTest.habitat.wall.length.area(2) = 72;
vehicleTest.habitat.roof.k(1)  = 0.32;       vehicleTest.habitat.roof.area(1) = 120; 
vehicleTest.habitat.floor.k(1) = 0.02;       vehicleTest.habitat.floor.area(1)= 120;

%% specific heat capacities and masses of the walls, roof, and floor. 
% Units:      [J/kg/K]   [kg]
vehicleTest.habitat.wall.cp(1) = 1230;      vehicleTest.habitat.wall.mass(1) = 400;
vehicleTest.habitat.wall.cp(2) = 2340;      vehicleTest.habitat.wall.mass(2) = 500;
vehicleTest.habitat.wall.cp(3) = 2000;      vehicleTest.habitat.wall.mass(3) = 600;
vehicleTest.habitat.wall.cp(4) = 1000;      vehicleTest.habitat.wall.mass(4) = 200;
vehicleTest.habitat.roof.cp(1) = 3000;      vehicleTest.habitat.roof.mass(1) = 400;
vehicleTest.habitat.floor.cp(1)= 5000;      vehicleTest.habitat.floor.mass(1)= 1200;

%% Emissivity and absorptivity 
% Units:      [1]  [1]
vehicleTest.habitat.width.wall.eps(1) = 0.3;     vehicleTest.habitat.wall.alph(1)   = 0.5;
vehicleTest.habitat.width.wall.eps(2) = 0.3;     vehicleTest.habitat.wall.alph(2)   = 0.5;
vehicleTest.habitat.length.wall.eps(1) = 0.3;     vehicleTest.habitat.wall.alph(1)   = 0.5;
vehicleTest.habitat.length.wall.eps(2) = 0.3;     vehicleTest.habitat.wall.alph(2)   = 0.5;
vehicleTest.habitat.roof.eps(1) = 0.3;     vehicleTest.habitat.roof.alph(1)   = 0.125;
vehicleTest.habitat.floor.eps(1)= 0.0;     vehicleTest.habitat.floor.alph(1)  = 0;

%% Heater
% Units: [J/s]
vehicleTest.habitat.heat.qOut(1) = 2000;
vehicleTest.habitat.heat.qOut(2) = 12000;
%%%%%%%%%%%%%%%%%%%%% environment %%%%%%%%%%%%%%%%%%%%%%%%%
vehicleTest.environment.moon.temperature   = 220;      % [K]
vehicleTest.environment.pressure           =   0;      % [Pa]
vehicleTest.environment.qSun               = 1372;     % [W/m^2]
vehicleTest.environment.sigma              = 5.67e-8;  % [W/kg/K^4]
vehicleTest.environment.qEarth             = 237;      % [W/m^2]

%%%%%%%%%%%%%%%%%%%%% habitat %%%%%%%%%%%%%%%%%%%%%%%%%
vehicleTest.habitat.alphaVis = 0.8;
vehicleTest.habitat.epsIR =    0.4;
vehicleTest.habitat.alphaIR = vehicleTest.habitat.epsIR;
vehicleTest.habitat.cp =       400;
vehicleTest.habitat.init.temp =300;      % [K]


%%%%%%%%%%%%%%%%%%%%% initial state %%%%%%%%%%%%%%%%%%%%%%%%%

InitialState = [vehicleTest.init.pos vehicleTest.init.vel vehicleTest.init.phi vehicleTest.init.omega vehicleTest.init.charge vehicleTest.habitat.init.temp];

VehicleTestBus     = eval(Simulink.Bus.createObject(vehicleTest).busName);
vehicleTestInit    = vehicleTest;

