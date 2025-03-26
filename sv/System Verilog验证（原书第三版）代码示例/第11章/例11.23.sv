class Expect_cells;
  NNI_cell q[$];
  int iexpect, iactual;
endclass : Expect_cells
class Scoreboard;
  Config cfg;
  Expect_cells expect_cells[];
  NNI_cell cellq[$];
  int iexpect, iactual;

  extern function new(Config cfg);
  extern virtual function void wrap_up();
  extern function void save_expected(UNI_cell ucell);
  extern function void check_actual(input NNI_cell c, input int portn);
  extern function void display(string prefix = "");
endclass : Scoreboard

function Scoreboard::new(input Config cfg);
  this.cfg = cfg;
  expect_cells = new[NumTx];
  foreach (expect_cells[i]) expect_cells[i] = new();
endfunction : Scoreboard

function void Scoreboard::save_expected(input UNI_cell ucell);
  NNI_cell ncell = ucell.to_NNI;
  CellCfgType CellCfg = top.squat.lut.read(ncell.VPI);

  $display("@%0t: Scb save: VPI = %0x, Forward = %b", $time, ncell.VPI, CellCfg.FWD);
  ncell.display($sformatf("@%0t: Scb save: ", $time));

  // 寻找信元将要转发到的 Tx 端口
  for (int i = 0; i < NumTx; i++)
  if (CellCfg.FWD[i]) begin
    expect_cells[i].q.push_back(ncell);  // 把信元保存到 q
    expect_cells[i].iexpect++;
    iexpect++;
  end
endfunction : save_expected

function void Scoreboard::check_actual(input NNI_cell c, input int portn);
  NNI_cell match;
  int match_idx;

  c.display($sformatf("@%0t: Scb check: ", $time));

  if (expect_cells[portn].q.size() == 0) begin
    $display("@%0t: ERROR: %m cell not found, SCB TX%0d empty", $time, portn);
    c.display("Not Found: ");
    cfg.nErrors++;
    return;
  end

  expect_cells[portn].iactual++;
  iactual++;

  foreach (expect_cells[portn].q[i]) begin
    if (expect_cells[portn].q[i].compare(c)) begin
      $display("@%0t: Match found for cell", $time);
      expect_cells[portn].q.delete(i);
      return;
    end
  end

  $display("@%0t: ERROR: %m cell not found", $time);
  c.display("Not Found: ");
  cfg.nErrors++;
endfunction : check_actual

// 输出仿真结束的报告
function void Scoreboard::wrap_up();
  $display("@%0t: %m %0d expected cells, %0d actual cells rcvd", $time, iexpect, iactual);

  // 寻找剩余的信元
  foreach (expect_cells[i]) begin
    if (expect_cells[i].q.size()) begin
      $display("@%0t: %m cells in SCB Tx[%0d] at end of test", $time, i);
      this.display("Unclaimed: ");
      cfg.nErrors++;
    end
  end
endfunction : wrap_up

// 输出记分牌的内容，主要用于调试
function void Scoreboard::display(input string prefix);
  $display("@%0t: %m so far %0d expected cells, %0d actual rcvd", $time, iexpect, iactual);
  foreach (expect_cells[i]) begin
    $display("Tx[%0d]: exp = %0d, act = %0d", i, expect_cells[i].iexpect, expect_cells[i].iactual);
    foreach (expect_cells[i].q[j])
    expect_cells[i].q[j].display($sformatf("%sScoreboard: Tx%0d: ", prefix, i));
  end
endfunction : display
