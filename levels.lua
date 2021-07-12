--[[
format for each level:
  {items}   items: I, L, T, +, dog
  {sheep}   flock 1 length, rest length, flock 2 length, etc.
  "grid"
    space = empty
    o = obstacle
    1234 = sheepfold with entrance facing down
    ABCD = sheepfold with entrance facing left
    box drawing characters = fixed paths
      ─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼
]]
return {
  [1] = {
    {2, 1, 0, 0, 0},
    {6},
    "  1 ",
    "    ",
    ">   ",
    tutorial = {
      {-1, 'btn_storehouse 1'},
      {0.17, 0.08, '从仓库中取出一个道路格子', 'storehouse_click 1'},
      {-1, 'cell 3 2'},
      {0.5, 0.875, '放在这里', 'put 3 2'},
      {-1, 'cell 3 2', nil, nil, {instant = true}},
      {0.5, 0.875, '点击以旋转', 'rotate_path 3 2'},
      {0.55, 0.2, '建造一条通往羊圈的道路\n剩下的都交给你啦！', 'empty'},
      {0.05, 0.785, '完成后就让小羊回到羊圈吧', 'run'},
    }
  },
  [2] = {
    {0, 0, 2, 0, 2},
    {6},
    "    1 ",
    "    │ ",
    ">─ ─  ",
    tutorial = {
      {-1, 'btn_storehouse 3'},
      {0.17, 0.35, '交叉路口格子', 'storehouse_click 3'},
      {-1, 'cell 3 3'},
      {0.45, 0.55, '放置在这里', 'put 3 3'},
      {-1, 'cell 3 3', nil, nil, {instant = true}},
      {0.45, 0.55, '点击旋转', 'rotate_path 3 3'},
      {-1, 'btn_run'},
      {0.05, 0.785, '小羊能顺利通行吗？', 'run'},
      {0, 0, '', 'delay 540'},
      {0.45, 0.4, '小羊还不太会认路呢！', 'delay 480'},
      {-1, 'btn_run'},
      {0.45, 0.4, '小羊还不太会认路呢！', nil, {instant = true}},
      {0.05, 0.785, '需要我们做些改动', 'stop'},
      {-1, 'btn_storehouse 5'},
      {0.17, 0.6, '牧羊犬是小羊的好伙伴', 'storehouse_click 5'},
      {-1, 'cell 3 3'},
      {0.45, 0.55, '交叉路口需要放置牧羊犬引路', 'put 3 3'},
      {0.45, 0.4, '道路上出现的脚印表示\n牧羊犬指引小羊向右前进', 'delay 480'},
      {0.45, 0.4, '道路上出现的脚印表示\n牧羊犬指引小羊向右前进', nil, {instant = true}},
      {0.17, 0.35, '接下来就交给你啦！', 'empty'},
      {0.05, 0.785, '完成后就让小羊回到羊圈吧'},
    }
  },
  [3] = {
    {0, 0, 0, 0, 1},
    {4, 3, 4},
    "  1   ",
    "  │   ",
    ">─┴──B",
    "      ",
    tutorial = {
      {-1, 'prog_ind'},
      {0.2, 0.8, '两群小羊需要回到各自对应颜色（红色和黄色）的羊圈', 'delay 900'},
      {-1, 'btn_storehouse 5'},
      {-1, 'cell 3 3'},
      {0.5, 0.78, '在这里放置牧羊犬', 'put 3 3'},
      {-1, 'btn_run'},
      {0, 0, '', 'run'},
      {0.5, 0.78, '第一群小羊顺利抵达羊圈……', 'delay 1080'},
      {-1, 'cell 3 3'},
      {0.5, 0.78, '点击改变牧羊犬指引的方向', 'rotate_dog 3 3', {blocksBoard = true}},
      {0.5, 0.78, '第二群小羊也能回到正确的羊圈了！'},
    }
  },
  [4] = {
    {4, 3, 2, 0, 2},
    {6, 4, 6},
    "       ",
    "    o A",
    " ┌─┼   ",
    "  o    ",
    "  o   B",
    ">      ",
  },
  [5] = {
    {5, 1, 2, 0, 2},
    {4, 4, 4},
    " 1  2 ",
    "      ",
    "  oo  ",
    " ├oo  ",
    ">  ─  ",
  },
  [6] = {
    {10, 10, 10, 10, 10},
    {4},
    "        ",
    "        ",
    ">       ",
    "        ",
    "        ",
    "        ",
  },
  [91] = {
    {0, 0, 0, 0, 0},
    {10},
    "                             ",
    ">                           1",
    "                             ",
  },
  [92] = {
    {0, 1, 0, 0, 0},
    {10},
    "  1 ",
    ">─  ",
  },
  [93] = {
    {0, 0, 0, 0, 0},
    {10},
    ">┐ ",
    " │ ",
    " │ ",
    " │ ",
    " │ ",
    " │ ",
  },
  [94] = {
    {0, 0, 0, 0, 1},
    {10},
    "  1  ",
    ">─┼──",
  },
}
