% Create a new model with a Stateflow chart
modelName = 'VOO_Pacemaker';
sfnew(modelName);  % Creates a new model with a chart
open_system(modelName);

% Access Stateflow root and chart
rt = sfroot;
modelObj = rt.find('-isa', 'Simulink.BlockDiagram', '-and', 'Name', modelName);
chartObj = modelObj.find('-isa', 'Stateflow.Chart');

% Define inputs and outputs
Stateflow.Data(chartObj, 'Name', 'clk', 'Scope', 'Input');       % Clock tick
Stateflow.Data(chartObj, 'Name', 'Vpace', 'Scope', 'Output');    % Ventricular pace output
Stateflow.Data(chartObj, 'Name', 'LED_V', 'Scope', 'Output');    % Ventricular LED
Stateflow.Data(chartObj, 'Name', 'mode_out', 'Scope', 'Output'); % Mode indicator

% Define parameters
Stateflow.Data(chartObj, 'Name', 'LRL', 'Scope', 'Parameter');   % Lower Rate Limit (ms)
Stateflow.Data(chartObj, 'Name', 'VPW', 'Scope', 'Parameter');   % Ventricular Pulse Width (ms)

% Create states
pace = Stateflow.State(chartObj);
pace.Name = 'PaceVentricular';
pace.LabelString = 'entry: Vpace=1; LED_V=1; mode_out=3;';
pace.Position = [100, 100, 140, 60];

wait = Stateflow.State(chartObj);
wait.Name = 'WaitInterval';
wait.LabelString = 'entry: Vpace=0; LED_V=0; mode_out=3;';
wait.Position = [300, 100, 140, 60];

% Create transitions
t1 = Stateflow.Transition(chartObj);
t1.Source = pace;
t1.Destination = wait;
t1.LabelString = 'after(VPW, clk)';

t2 = Stateflow.Transition(chartObj);
t2.Source = wait;
t2.Destination = pace;
t2.LabelString = 'after(LRL - VPW, clk)';

% Save and open
save_system(modelName);
open_system(modelName);