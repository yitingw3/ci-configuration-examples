function plan = buildfile
<<<<<<< HEAD

% Add the source folder to the path
addpath("code");

% Create a plan
plan = buildplan(localfunctions);

% Add a task to run tests
plan("test") = matlab.buildtool.tasks.TestTask("tests");

% Make the "test" task the default task in the plan
plan.DefaultTasks = "test";

end

=======
import matlab.buildtool.tasks.TestTask;
import matlab.buildtool.tasks.MexTask;

% Create a plan from task functions
plan = buildplan(localfunctions);

% Add a task to build a MEX file
plan("mex") = MexTask("src/arrayProduct.c","toolbox");

% Add a task to run tests and generate test and coverage results
plan("test") = TestTask(TestResults="test-results/results.xml");
plan("test").Dependencies = ["mex"];

end

function packageToolboxTask(~)
    % Create an mltbx toolbox package
    dir toolbox/*.mex*;
    identifier = "arrayProduct";
    toolboxFolder = "toolbox";
    opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder,identifier);
    
    opts.ToolboxName = "Cross-Platform Array Product Toolbox";
    opts.MinimumMatlabRelease = "R2024a";

    matlab.addons.toolbox.packageToolbox(opts);
end
>>>>>>> 7d2e9d99d6f1879ac0730317d0fbe30ecdd8d3bf
