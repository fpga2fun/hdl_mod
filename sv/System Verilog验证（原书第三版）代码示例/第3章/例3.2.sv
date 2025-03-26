initial begin
    bit [127:0] cmd;
    int file, c;

    file = $fopen("commands.txt", "r");
    while (!$feof(file)) begin
        c = $fscanf(file, "%s", cmd);
        case (cmd)
            "":     continue;    // 空行—，跳到本轮循环的末尾
            "done": break;       // done，终止并跳出循环
            ...                  // 此处处理其他命令
        endcase // case(cmd)
        end
    $fclose(file);
end