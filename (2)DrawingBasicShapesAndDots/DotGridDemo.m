%%
% 清空现有窗口和变量
sca;
close all;
clearvars;

% 设置随机种子
rand('seed', sum(100 * clock));

% 检测当前连在电脑的屏幕，返回一个数组，这个数组记录了当前屏幕的编号，如果只有一个屏幕，则编号为0
screens = Screen('Screens');
screenNumber = max(screens);

% 获得白色和黑色的颜色值，可以默认它们分别为0与255
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% 计算灰色的颜色值
grey = white / 2;

% 打开一个窗口，将背景设置为黑色，返回窗口句柄和窗口大小
[window, windowRect] = Screen('OpenWindow', screenNumber, black);

% 获取窗口大小
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% 获取窗口中心坐标
[xCenter, yCenter] = RectCenter(windowRect);

% 开启alpha通道来抗锯齿
% 详情请见Screen BlendFunction? 或查看第六章OpenGL编程指导
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% 
% 使用函数meshgrid生成点阵的坐标。meshgrid将会生成一个等距坐标网格，中心点为(0, 0)
% help meshgrid获取帮助
% 在绘图的过程中，我们经常想要建立一个坐标系矩阵，矩阵的每个元素都由(x,y)来表示，比如：
%   |
% ------------------------------------------> x
%   | (0, 0)  (1, 0)  (2, 0) ... (n_x, 0) 
%   | (0, 1)  (1, 1)  (2, 1) ... (n_x, 1) 
%   | ................................. 
% y | (0,n_y) (1,n_y) (2,n_y)... (n_x, n_y) 
%   V
% meshgrid本质上在做这件事件，只不过返回的分别是X坐标和Y坐标的矩阵
dim = 10;
[x, y] = meshgrid(-dim:1:dim, -dim:1:dim);

% 在这里我们调整网格的大小使得它适合屏幕
% .*符号为对应元素相乘
pixelScale = screenYpixels / (dim * 2 + 2);
x = x .* pixelScale;
y = y .* pixelScale;

% 计算点的总数量
numDots = numel(x);

% Screen('DrawDots')允许使用者一次绘制多个点
% 制作代表点位置的2*numDots矩阵，每一列都代表一个点的坐标，第一行代表横坐标，第二行代表
% 纵坐标
dotPositionMatrix = [reshape(x, 1, numDots); reshape(y, 1, numDots)];

% 定义点阵的中点，例子中将屏幕中心作为点阵的中点
dotCenter = [xCenter yCenter];

% 制作3*numDots的颜色矩阵，将点的颜色设置为随机
dotColors = rand(3, numDots) .* white;

% 制作1*numDots的随机向量，代表点的大小
dotSizes = rand(1, numDots) .* 20 + 10;

% 一行便绘制了我们所有需要的点
Screen('DrawDots', window, dotPositionMatrix,...
    dotSizes, dotColors, dotCenter, 2);
dotSizes = rand(1, numDots) .* 20 + 10;

% 翻转屏幕。
Screen('Flip', window);

% 按下任意键继续执行程序
KbStrokeWait;

% 关闭所有窗口
sca;